# forge-dao-governance-token

[![CI](https://github.com/Blockchains/forge-dao-governance-token/actions/workflows/ci.yml/badge.svg)](https://github.com/Blockchains/forge-dao-governance-token/actions/workflows/ci.yml) [![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Blockchains/forge-dao-governance-token?quickstart=1)

> **Idea:** A community governance token with permit approvals, vote delegation and an on-chain governor with a timelock

Composed end to end by [blockchainlab-compose](https://github.com/Blockchains/blockchainlab-compose) (the Blockchain Lab `/forge` engine), with no hand edits:
capabilities detected (`governance` (index-taxonomy), `fungible-token` (index-taxonomy), `token-permit` (index-taxonomy)) → archetype `token` → components picked from [blockchainlab-index](https://github.com/Blockchains/blockchainlab-index) → exact source files (plus import closure) copied from the Blockchains forks at pinned commits → pragma check against solc 0.8.30 and licence check → generated glue, tests, deploy script and CI → `forge build && forge test` → repo created → CI.

## Features
- ERC-20 with supply cap
- EIP-2612 permit
- ERC20Votes delegation
- Governor + TimelockController
- role-based minting (AccessControl)

## Run
```bash
git clone https://github.com/Blockchains/forge-dao-governance-token && cd forge-dao-governance-token
forge test -vv                      # unit tests; set MAINNET_RPC_URL to also run live-chain fork tests
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --account <keystore> --broadcast
```
Or run the **Deploy (Sepolia)** workflow after adding `DEPLOYER_PRIVATE_KEY` and `SEPOLIA_RPC_URL` secrets.

## Components
| Capability | Component | Licence | How chosen |
|---|---|---|---|
| fungible-token | [`ERC20`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/token/ERC20/ERC20.sol) | MIT | planner-selected |
| fungible-token | [`ERC20Permit`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/token/ERC20/extensions/ERC20Permit.sol) | MIT | planner-selected |
| fungible-token | [`ERC20Votes`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/token/ERC20/extensions/ERC20Votes.sol) | MIT | planner-selected |
| governance | [`Governor`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/Governor.sol) | MIT | planner-selected |
| governance | [`TimelockController`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/TimelockController.sol) | MIT | planner-selected |
| governance | [`GovernorSettings`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/extensions/GovernorSettings.sol) | MIT | indexed |
| governance | [`GovernorCountingSimple`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/extensions/GovernorCountingSimple.sol) | MIT | indexed |
| governance | [`GovernorVotes`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/extensions/GovernorVotes.sol) | MIT | indexed |
| governance | [`GovernorVotesQuorumFraction`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/extensions/GovernorVotesQuorumFraction.sol) | MIT | indexed |
| governance | [`GovernorTimelockControl`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/extensions/GovernorTimelockControl.sol) | MIT | indexed |
| governance | [`IGovernor`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/governance/IGovernor.sol) | MIT | indexed |
| support | [`Nonces`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/utils/Nonces.sol) | MIT | indexed |
| support | [`AccessControl`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/access/AccessControl.sol) | MIT | indexed |
| support | [`IAccessControl`](https://github.com/Blockchains/openzeppelin-contracts/blob/cab19933c33c2ad1d4c7a84864a3601dddfd16f3/contracts/access/IAccessControl.sol) | MIT | indexed |

| Fork | Pinned | Upstream | Files copied |
|---|---|---|---|
| [Blockchains/forge-std](https://github.com/Blockchains/forge-std/tree/f3dae6e6ee381f25eb6a246f7da9b85c91a68219) | v1.17.0 | [foundry-rs/forge-std](https://github.com/foundry-rs/forge-std) | 20 |
| [Blockchains/openzeppelin-contracts](https://github.com/Blockchains/openzeppelin-contracts/tree/cab19933c33c2ad1d4c7a84864a3601dddfd16f3) | v5.7.0 | [OpenZeppelin/openzeppelin-contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) | 52 |

Every copied file is unmodified and keeps its SPDX header; see [NOTICE](NOTICE). Machine-readable: [`plan.json`](plan.json), [`component-map.json`](component-map.json).

<!-- blocks:start -->
## Use as a building block

> **For AI agents and builders:** read [`AGENTS.md`](AGENTS.md) (setup, commands, structure, rules), [`llms.txt`](llms.txt) (doc map) and the machine-readable [`blocks.json`](blocks.json) ([schema](https://github.com/Blockchains/.github/blob/main/docs/BLOCKS-SCHEMA.md)). How all Blockchains blocks fit together: **[Build with Blocks](https://github.com/Blockchains/.github/blob/main/docs/BUILD-WITH-BLOCKS.md)** · org catalogue: [https://blockchains.github.io/blocks.json](https://blockchains.github.io/blocks.json).

**What it exports**

| Export | Type | Install / access |
|---|---|---|
| `DaoGovernanceToken` | solidity | `forge install Blockchains/forge-dao-governance-token` |
| `DaoGovernanceGovernor` | solidity | `forge install Blockchains/forge-dao-governance-token` |
| `script/Deploy.s.sol` | file | `forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --account <keystore> --broadcast` |
| `component-map.json, plan.json` | file | `provenance: capability → component → pinned fork commit` |

**Minimal example** (compiled and passed a deploy + delegate test on 2026-10-04 in a fresh Foundry project)

```solidity
// forge install Blockchains/forge-dao-governance-token Blockchains/openzeppelin-contracts@v5.7.0
// remappings.txt: @openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/
import {DaoGovernanceToken} from "forge-dao-governance-token/src/DaoGovernanceToken.sol";
import {DaoGovernanceGovernor} from "forge-dao-governance-token/src/DaoGovernanceGovernor.sol";
import {TimelockController} from "@openzeppelin/contracts/governance/TimelockController.sol";

DaoGovernanceToken token = new DaoGovernanceToken(admin, 1_000_000e18, 10_000_000e18);
TimelockController tl = new TimelockController(2 days, new address[](0), new address[](0), admin);
DaoGovernanceGovernor gov = new DaoGovernanceGovernor(token, tl, 1 /* delay blocks */, 50400 /* period blocks */);
token.delegate(admin);   // votes need delegation (ERC20Votes)
```

**Inputs → outputs**

- In: `constructor args` (Solidity) DaoGovernanceToken(admin, initialSupply, cap); DaoGovernanceGovernor(IVotes token, TimelockController timelock, uint48 votingDelay, uint32 votingPeriod)
- Out: `deployed contracts` (EVM); `events/errors` (ABI) see src/

**Composes with**

- [Blockchains/blockchainlab-compose](https://github.com/Blockchains/blockchainlab-compose): the composer that generated this repo
- [Blockchains/forge-usd-priced-membership-nft](https://github.com/Blockchains/forge-usd-priced-membership-nft): pair: members NFT + governance token
- [Blockchains/blockchainlab-sdk](https://github.com/Blockchains/blockchainlab-sdk): front end data (chains, RPC health, sanctions screening)
- [Blockchains/blockchainlab-labs](https://github.com/Blockchains/blockchainlab-labs): L15 Timelock lab explains the pattern

**Versioning & stability:** `reference`. Reference output of an automated composer; copied components are pinned to fork release tags (see NOTICE / component-map.json). Not audited. Treat as a starting point and review before deploying with value.
<!-- blocks:end -->

## Licence
MIT for the generated glue. All copied components are permissively licensed.

Not audited. Review before deploying with real value.

Composed by [blockchainlab-compose](https://github.com/Blockchains/blockchainlab-compose), the engine behind [blockchainlab.com/forge](https://blockchainlab.com/forge). Contracts only, no hosted site.

## Configuration

`script/Deploy.s.sol` reads (deployer = broadcaster = admin):

| Variable | Required | Default | Purpose |
|---|---|---|---|
| `INITIAL_SUPPLY` | no | 1,000,000e18 | Minted to the deployer |
| `SUPPLY_CAP` | no | 10,000,000e18 | Hard cap |
| `TIMELOCK_DELAY` | no | 2 days | TimelockController delay (seconds) |

The **Deploy (Sepolia)** workflow needs `DEPLOYER_PRIVATE_KEY` and `SEPOLIA_RPC_URL` repository secrets and stops with a clear error without them.

## Contributing

Issues and pull requests are welcome. Please read the [contributing guide](https://github.com/Blockchains/.github/blob/main/CONTRIBUTING.md), [code of conduct](https://github.com/Blockchains/.github/blob/main/CODE_OF_CONDUCT.md) and [security policy](https://github.com/Blockchains/.github/blob/main/SECURITY.md) first.

---
Built by Blockchain Lab — [blockchainlab.com](https://blockchainlab.com/?utm_source=github&utm_medium=readme&utm_campaign=forge-dao-governance-token)
