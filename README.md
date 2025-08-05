# Megatron ERC-20 Token

A fully tested ERC-20 token smart contract built with [Solidity](https://soliditylang.org/) and [Foundry](https://book.getfoundry.sh/), following the [OpenZeppelin ERC-20 standard](https://docs.openzeppelin.com/contracts/).
This project demonstrates token deployment, transfers, allowances, and edge-case handling — complete with a Foundry test suite.

---

## 📂 Project Structure

```plaintext
.
├── src/
│   └── ERC20Token.sol        # ERC-20 token contract
├── script/
│   └── DeployToken.s.sol     # Deployment script
├── test/
│   └── TestToken.t.sol       # Unit tests
├── lib/                      # External dependencies (OpenZeppelin, forge-std)
├── foundry.toml              # Foundry configuration
└── README.md
```
