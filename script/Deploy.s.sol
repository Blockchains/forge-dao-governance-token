// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/DaoGovernanceToken.sol";
import "../src/DaoGovernanceGovernor.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

/// forge script script/Deploy.s.sol --rpc-url $RPC_URL --account <keystore> --broadcast
contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        address admin = msg.sender;
        DaoGovernanceToken token = new DaoGovernanceToken(admin, vm.envOr("INITIAL_SUPPLY", uint256(1_000_000e18)), vm.envOr("SUPPLY_CAP", uint256(10_000_000e18)));
        console2.log("token", address(token));
        address[] memory proposers = new address[](0);
        address[] memory executors = new address[](1); // address(0) = anyone may execute after the delay
        TimelockController timelock = new TimelockController(vm.envOr("TIMELOCK_DELAY", uint256(2 days)), proposers, executors, admin);
        DaoGovernanceGovernor gov = new DaoGovernanceGovernor(token, timelock, 7200, 50400);
        timelock.grantRole(timelock.PROPOSER_ROLE(), address(gov));
        timelock.grantRole(timelock.CANCELLER_ROLE(), address(gov));
        token.grantRole(token.MINTER_ROLE(), address(timelock));
        console2.log("timelock", address(timelock));
        console2.log("governor", address(gov));
        vm.stopBroadcast();
    }
}
