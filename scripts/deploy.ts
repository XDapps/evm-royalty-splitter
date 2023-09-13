
import { ethers } from 'hardhat';
import { Contract, ContractFactory } from 'ethers';

async function main(): Promise<void> {
  const SplitRoyaltyFactory: ContractFactory = await ethers.getContractFactory('SplitRoyalty');
  const [user1, user2, user3, user4] = await ethers.getSigners();

  //Replace with your own addresses and percentages
  const publishers = [user1.address, user2.address, user3.address, user4.address];
  const percentages = [3000, 2500, 2500, 2000];

  const contract: Contract = await SplitRoyaltyFactory.deploy(publishers, percentages);
  await contract.deployed();
  console.log('deployed to: ', contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
