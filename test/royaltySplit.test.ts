import { ethers } from "hardhat";
import chai from "chai";
import { solidity } from "ethereum-waffle";
import { SplitRoyalty__factory, MockRoyaltySendContract__factory } from "../typechain";
import { BigNumber } from "ethers";

chai.use(solidity);
const { expect } = chai;

describe("Royalty Split Test", () => {
  let splitterAddress: string;  
  let royaltySenderAddress: string;
  describe("Deploy Contracts", async () => {
    it("Should Deploy The Contract", async () => {
      const [deployer, creator1, creator2, creator3, creator4, buyer] = await ethers.getSigners();
      const splitterFactory = new SplitRoyalty__factory(deployer);
      const RoyaltySenderFactory = new MockRoyaltySendContract__factory(deployer);
      const publishers = [creator1.address, creator2.address, creator3.address, creator4.address];
      const percentageSplits = [2000, 3000, 4500, 500];
      const splitter = await splitterFactory.deploy(publishers, percentageSplits);
      const royaltySender = await RoyaltySenderFactory.deploy();
      splitterAddress = splitter.address;
      royaltySenderAddress = royaltySender.address;
    });
  });

  describe("Send 1 Eth to the Splitter", async () => {
    it("Should split and distribute the ETH", async () => {
      const [deployer, creator1, creator2, creator3, creator4, buyer] = await ethers.getSigners();
      const royaltySender = new MockRoyaltySendContract__factory(buyer).attach(royaltySenderAddress);
      const price = ethers.utils.parseEther("1");
      const bal1Before = await creator1.getBalance();
      const bal2Before = await creator2.getBalance();
      const bal3Before = await creator3.getBalance();
      const bal4Before = await creator4.getBalance();
      const tx = await royaltySender.sendRoyaltyTest(splitterAddress, price, { value: price });
      //const tx = await splitterInstance.receiveRoyalty(price, 0, { value: price });
      const txConf = await tx.wait();
      const bal1After = await creator1.getBalance();
      const bal2After = await creator2.getBalance();
      const bal3After = await creator3.getBalance();
      const bal4After = await creator4.getBalance();
      const split1 = ethers.utils.parseEther("0.2");
      const split2 = ethers.utils.parseEther("0.3");
      const split3 = ethers.utils.parseEther("0.45");
      const split4 = ethers.utils.parseEther("0.05");

      expect(bal1After).to.eq((bal1Before).add(split1));
      expect(bal2After).to.eq((bal2Before).add(split2));
      expect(bal3After).to.eq((bal3Before).add(split3));
      expect(bal4After).to.eq((bal4Before).add(split4));
    });
  });

});
