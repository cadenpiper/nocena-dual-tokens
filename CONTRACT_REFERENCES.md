# Contract References for External Integration

## Flow EVM Testnet Deployment

**Network**: Flow EVM Testnet  
**Chain ID**: 545  
**RPC URL**: https://testnet.evm.nodes.onflow.org

## Contract Addresses

```javascript
const CONTRACTS = {
  Nocenite: "0x9601F4ECE8976Ac2609D852e995117d0598A78B9",
  Nocenix: "0x784ab4827124285b062d0B63E483FAE345385D86",
  Airdrop: "0x984514f68E946Fd8A8C877C71a763Ab44397db66"
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
