import { network } from "hardhat";

const { ethers } = await network.connect();

// Challenge reward tiers
const REWARDS = {
  DAILY: ethers.parseEther("100"),    // 100 NCT
  WEEKLY: ethers.parseEther("500"),   // 500 NCT  
  MONTHLY: ethers.parseEther("2500")  // 2500 NCT
};

async function main() {
  const [owner, user1, user2, user3] = await ethers.getSigners();
  
  console.log("=== Challenge Reward System ===");
  console.log("Owner:", owner.address);
  
  // Deploy Nocenite contract
  const nocenite = await ethers.deployContract("Nocenite", [owner.address]);
  console.log("Nocenite (NCT) deployed to:", await nocenite.getAddress());
  
  // Simulate different challenge completions
  console.log("\n🎯 Daily Challenge Completed!");
  await nocenite.connect(owner).mint(user1.address, REWARDS.DAILY);
  console.log(`Rewarded ${ethers.formatEther(REWARDS.DAILY)} NCT to ${user1.address}`);
  
  console.log("\n📅 Weekly Challenge Completed!");
  await nocenite.connect(owner).mint(user2.address, REWARDS.WEEKLY);
  console.log(`Rewarded ${ethers.formatEther(REWARDS.WEEKLY)} NCT to ${user2.address}`);
  
  console.log("\n🏆 Monthly Challenge Completed!");
  await nocenite.connect(owner).mint(user3.address, REWARDS.MONTHLY);
  console.log(`Rewarded ${ethers.formatEther(REWARDS.MONTHLY)} NCT to ${user3.address}`);
  
  // Check all balances
  console.log("\n=== Final Balances ===");
  console.log(`User 1 (Daily): ${ethers.formatEther(await nocenite.balanceOf(user1.address))} NCT`);
  console.log(`User 2 (Weekly): ${ethers.formatEther(await nocenite.balanceOf(user2.address))} NCT`);
  console.log(`User 3 (Monthly): ${ethers.formatEther(await nocenite.balanceOf(user3.address))} NCT`);
  
  const totalSupply = await nocenite.totalSupply();
  console.log(`Total NCT Supply: ${ethers.formatEther(totalSupply)} NCT`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
