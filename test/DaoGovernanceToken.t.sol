// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/DaoGovernanceToken.sol";
import "../src/DaoGovernanceGovernor.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts/governance/IGovernor.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";

contract DaoGovernanceTokenTest is Test {
    DaoGovernanceToken token;
    address admin = makeAddr("admin");
    address alice;
    uint256 aliceKey;
    address bob = makeAddr("bob");
    uint256 constant SUPPLY = 1_000_000e18;
    uint256 constant CAP = 10_000_000e18;

    function setUp() public {
        (alice, aliceKey) = makeAddrAndKey("alice");
        token = new DaoGovernanceToken(admin, SUPPLY, CAP);
    }

    function test_initialSupplyAndMetadata() public view {
        assertEq(token.totalSupply(), SUPPLY);
        assertEq(token.balanceOf(admin), SUPPLY);
        assertEq(token.decimals(), 18);
        assertEq(token.cap(), CAP);
    }

    function test_transfer() public {
        vm.prank(admin);
        token.transfer(alice, 100e18);
        assertEq(token.balanceOf(alice), 100e18);
    }

    function test_mintRespectsCap() public {
        vm.startPrank(admin);
        token.mint(bob, CAP - SUPPLY);
        assertEq(token.totalSupply(), CAP);
        vm.expectRevert(abi.encodeWithSelector(DaoGovernanceToken.CapExceeded.selector, CAP + 1, CAP));
        token.mint(bob, 1);
        vm.stopPrank();
    }

    function test_onlyMinterCanMint() public {
        vm.expectRevert(abi.encodeWithSelector(IAccessControl.AccessControlUnauthorizedAccount.selector, bob, token.MINTER_ROLE()));
        vm.prank(bob);
        token.mint(bob, 1);
    }

    function testFuzz_transfer(uint96 amount) public {
        vm.assume(amount <= SUPPLY);
        vm.prank(admin);
        token.transfer(bob, amount);
        assertEq(token.balanceOf(bob), amount);
        assertEq(token.balanceOf(admin), SUPPLY - amount);
    }

    function test_permitSetsAllowanceFromSignature() public {
        bytes32 PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
        uint256 deadline = block.timestamp + 1 hours;
        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, alice, bob, 50e18, token.nonces(alice), deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", token.DOMAIN_SEPARATOR(), structHash));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(aliceKey, digest);
        token.permit(alice, bob, 50e18, deadline, v, r, s);
        assertEq(token.allowance(alice, bob), 50e18);
        assertEq(token.nonces(alice), 1);
        vm.expectRevert();
        token.permit(alice, bob, 50e18, deadline, v, r, s); // replay rejected
    }

    function test_delegationGivesVotingPower() public {
        vm.prank(admin);
        token.transfer(alice, 300e18);
        vm.prank(alice);
        token.delegate(alice);
        assertEq(token.getVotes(alice), 300e18);
        vm.prank(alice);
        token.delegate(bob);
        assertEq(token.getVotes(alice), 0);
        assertEq(token.getVotes(bob), 300e18);
    }

    /// Full lifecycle: delegate -> propose (timelock mints to bob) -> vote -> queue -> execute.
    function test_governorProposalExecutesThroughTimelock() public {
        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1);
        TimelockController timelock = new TimelockController(1 days, proposers, executors, address(this));
        DaoGovernanceGovernor gov = new DaoGovernanceGovernor(token, timelock, 1, 50400);
        timelock.grantRole(timelock.PROPOSER_ROLE(), address(gov));
        timelock.grantRole(timelock.CANCELLER_ROLE(), address(gov));
        bytes32 minterRole = token.MINTER_ROLE();
        vm.prank(admin);
        token.grantRole(minterRole, address(timelock));

        vm.prank(admin);
        token.delegate(admin);
        vm.roll(vm.getBlockNumber() + 1);

        address[] memory targets = new address[](1); targets[0] = address(token);
        uint256[] memory values = new uint256[](1);
        bytes[] memory calldatas = new bytes[](1); calldatas[0] = abi.encodeCall(DaoGovernanceToken.mint, (bob, 1234e18));
        string memory description = "Mint 1234 tokens to bob";
        vm.prank(admin);
        uint256 id = gov.propose(targets, values, calldatas, description);
        assertEq(uint8(gov.state(id)), uint8(IGovernor.ProposalState.Pending));

        vm.roll(vm.getBlockNumber() + gov.votingDelay() + 1);
        vm.prank(admin);
        gov.castVote(id, 1);
        vm.roll(vm.getBlockNumber() + gov.votingPeriod() + 1);
        assertEq(uint8(gov.state(id)), uint8(IGovernor.ProposalState.Succeeded));

        bytes32 descHash = keccak256(bytes(description));
        gov.queue(targets, values, calldatas, descHash);
        vm.warp(vm.getBlockTimestamp() + 1 days + 1);
        gov.execute(targets, values, calldatas, descHash);
        assertEq(uint8(gov.state(id)), uint8(IGovernor.ProposalState.Executed));
        assertEq(token.balanceOf(bob), 1234e18);
    }
}
