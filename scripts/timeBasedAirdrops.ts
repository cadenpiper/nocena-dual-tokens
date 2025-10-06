import { network } from "hardhat";

const { ethers } = await network.connect();

async function main() {
  const [owner, user1, user2] = await ethers.getSigners();
  
  console.log("=== Time-Based Airdrop System ===");
  
  // Deploy contracts
  const nocenite = await ethers.deployContract("Nocenite", [owner.address]);
  const nocenix = await ethers.deployContract("Nocenix", [owner.address]);
  const airdrop = await ethers.deployContract("Airdrop", [
    await nocenite.getAddress(),
    await nocenix.getAddress(), 
    owner.address
  ]);
  
  // Give airdrop contract permission to mint NCX
  await nocenix.transferOwnership(await airdrop.getAddress());
  
  // Setup initial NCT balances
  await nocenite.mint(user1.address, ethers.parseEther("1000"));
  await nocenite.mint(user2.address, ethers.parseEther("500"));
  
  const recipients = [user1.address, user2.address];
  
  // Test Year 1 (1M NCX per week)
  console.log("\n🗓️  YEAR 1 - Week 1");
  await showAirdropInfo(airdrop);
  await airdrop.executeWeeklyAirdrop(recipients);
  await showBalances(nocenite, nocenix, [user1, user2]);
  
  // Jump to Year 2 (750K NCX per week)
  console.log("\n⏭️  Time travel to Year 2...");
  await ethers.provider.send("evm_increaseTime", [365 * 24 * 60 * 60]); // 1 year
  await ethers.provider.send("evm_mine", []);
  
  console.log("\n🗓️  YEAR 2 - Week 53");
  await showAirdropInfo(airdrop);
  await airdrop.executeWeeklyAirdrop(recipients);
  await showBalances(nocenite, nocenix, [user1, user2]);
  
  // Jump to Year 3 (500K NCX per week)
  console.log("\n⏭️  Time travel to Year 3...");
  await ethers.provider.send("evm_increaseTime", [365 * 24 * 60 * 60]); // 1 year
  await ethers.provider.send("evm_mine", []);
  
  console.log("\n🗓️  YEAR 3 - Week 105");
  await showAirdropInfo(airdrop);
  await airdrop.executeWeeklyAirdrop(recipients);
  await showBalances(nocenite, nocenix, [user1, user2]);
  
  // Jump to Year 4 (250K NCX per week)
  console.log("\n⏭️  Time travel to Year 4...");
  await ethers.provider.send("evm_increaseTime", [365 * 24 * 60 * 60]); // 1 year
  await ethers.provider.send("evm_mine", []);
  
  console.log("\n🗓️  YEAR 4 - Week 157");
  await showAirdropInfo(airdrop);
  await airdrop.executeWeeklyAirdrop(recipients);
  await showBalances(nocenite, nocenix, [user1, user2]);
  
  // Jump to Year 6 (100K NCX minimum)
  console.log("\n⏭️  Time travel to Year 6...");
  await ethers.provider.send("evm_increaseTime", [2 * 365 * 24 * 60 * 60]); // 2 years
  await ethers.provider.send("evm_mine", []);
  
  console.log("\n🗓️  YEAR 6 - Week 261");
  await showAirdropInfo(airdrop);
  await airdrop.executeWeeklyAirdrop(recipients);
  await showBalances(nocenite, nocenix, [user1, user2]);
}

async function showAirdropInfo(airdrop: any) {
  const info = await airdrop.getAirdropInfo();
  console.log(`Week: ${info.currentWeek} | Year: ${info.currentYear + 1n} | Reward: ${ethers.formatEther(info.weeklyReward)} NCX | Executed: ${info.weekExecuted} | Total Airdrops: ${info.totalExecuted}`);
}

async function showBalances(nocenite: any, nocenix: any, users: any[]) {
  console.log("Balances after airdrop:");
  for (let i = 0; i < users.length; i++) {
    const user = users[i];
    const nctBalance = await nocenite.balanceOf(user.address);
    const ncxBalance = await nocenix.balanceOf(user.address);
    console.log(`  User${i+1}: ${ethers.formatEther(nctBalance)} NCT | ${ethers.formatEther(ncxBalance)} NCX`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
