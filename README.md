# Royalty Splitter Contract

Royalty Splitter Contract - will receive royalties on behalf of a group of creators/owners and will distribute based on the percentages given at deployment.

## Installation

```bash
yarn
```
## Env File

You must create a .env file with a seed phrase for an address containing enough gas to deploy your contract. See example .env file.


## Usage

Replace the publishers and percentages in the deploy file variables shown below. You may have as many addresses as you like in the publishers array so long as the length of the percentages array matches the length of the publishers array. The total sum of the percentages array must equal 10,000.

```typescript
const publishers = [user1.address, user2.address, user3.address, user4.address];
const percentages = [3000, 2500, 2500, 2000];

// User 1 would receive 30% of all payments
// User 2 would receive 25% of all payments
// User 3 would receive 25% of all payments
// User 4 would receive 20% of all payments
```

## Deployment
```typescript
npx hardhat run scripts/deploy.ts --network songbird //(see hardhat config file to add networks and rpc urls)
```
## Tests
```typescript
npx hardhat test
```
