# Nocena Dual Token System

A dual ERC20 token system built on Flow EVM featuring challenge rewards and time-based airdrops.

## Overview

This project implements two interconnected tokens:

- **Nocenite (NCT)**: Unlimited supply reward token earned through challenges
- **Nocenix (NCX)**: Capped supply value token (1B max) distributed via weekly airdrops

## Token Mechanics

### Nocenite (NCT) - Reward Token
- **Purpose**: Challenge completion rewards
- **Supply**: Unlimited
- **Rewards**: 
  - Daily challenges: 100 NCT
  - Weekly challenges: 500 NCT  
  - Monthly challenges: 2,500 NCT

### Nocenix (NCX) - Value Token
- **Purpose**: Time-based value distribution
- **Supply**: 1 billion token cap
- **Distribution**: Weekly airdrops proportional to NCT holdings
- **Schedule**: Decreasing rewards over time
  - Year 1: 1M NCX per week
  - Year 2: 750K NCX per week
  - Year 3: 500K NCX per week
  - Year 4: 250K NCX per week
  - Year 5+: 100K NCX per week (minimum)

## Deployed Contracts

**Flow EVM Testnet** (Chain ID: 545)
- Nocenite (NCT): `0x9601F4ECE8976Ac2609D852e995117d0598A78B9`
- Nocenix (NCX): `0x784ab4827124285b062d0B63E483FAE345385D86`
- Airdrop: `0x984514f68E946Fd8A8C877C71a763Ab44397db66`

See `CONTRACT_REFERENCES.md` for complete integration details.

## Development

### Setup
```bash
npm install
```

### Testing
```bash
npx hardhat test
```

### Deployment
```bash
# Deploy to Flow EVM testnet
npx hardhat run scripts/deploy.ts --network flowTestnet

# Run simulations locally
npx hardhat run scripts/challengeRewards.ts
npx hardhat run scripts/timeBasedAirdrops.ts
```

### Configuration
Set your private key for Flow EVM testnet:
```bash
npx hardhat keystore set FLOW_PRIVATE_KEY
```

## Architecture

The system incentivizes continued participation through:
1. **Challenge Rewards**: Immediate NCT tokens for completing tasks
2. **Proportional Airdrops**: NCX distribution based on NCT holdings percentage
3. **Time Scarcity**: Decreasing airdrop amounts create early adopter advantages
4. **Weekly Cadence**: Regular distribution maintains engagement

## Integration

For frontend integration, reference the deployed contract addresses and ABIs from:
- Contract addresses: `CONTRACT_REFERENCES.md`
- Contract ABIs: `artifacts/contracts/*/` folders

The system is designed for gasless transactions on Flow EVM through Flow's custom gateway.
