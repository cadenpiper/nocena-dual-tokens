# Contract References for External Integration

## Flow EVM Testnet Deployment

**Network**: Flow EVM Testnet  
**Chain ID**: 545  
**RPC URL**: https://testnet.evm.nodes.onflow.org

## Contract Addresses

```javascript
const CONTRACTS = {
  Nocenite: "0xfeb47DfF2bb9eB3e9bC0E7C57B30c3633483F634",
  Nocenix: "0xF4B4e4040816D46230584181B07BbAae743D774B",
  Airdrop: "0xF4d7519ec9B758AAB0E46545E4f38b13897AB0ef"
};
```

## Token Details

- **Nocenite (NCT)**: Unlimited supply reward token
- **Nocenix (NCX)**: 1 billion max supply value token
- **Challenge Rewards**: 100 NCT (daily), 500 NCT (weekly), 2500 NCT (monthly)
- **Airdrop Schedule**: Decreasing weekly NCX rewards based on NCT holdings

## ABI Files Location

Contract ABIs are available in:
- `artifacts/contracts/Nocenite.sol/Nocenite.json`
- `artifacts/contracts/Nocenix.sol/Nocenix.json`
- `artifacts/contracts/Airdrop.sol/Airdrop.json`

Copy the `abi` field from each JSON file for your external integration.
