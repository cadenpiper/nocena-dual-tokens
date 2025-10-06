import { network } from "hardhat";

const { ethers } = await network.connect();

async function main() {
  const [owner, user1, user2, user3] = await ethers.getSigners();
  
  console.log("=== 3-Week Airdrop Simulation ===");
  
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
  
  const recipients = [user1.address, user2.address, user3.address];
  
  // === WEEK 1 ===
  console.log("\n🗓️  WEEK 1");
  await nocenite.mint(user1.address, ethers.parseEther("1000")); // User1: 1000 NCT
  await nocenite.mint(user2.address, ethers.parseEther("500"));  // User2: 500 NCT
  await nocenite.mint(user3.address, ethers.parseEther("300"));  // User3: 300 NCT
  
  await showBalances("Week 1 NCT Holdings", nocenite, nocenix, [user1, user2, user3]);
  await airdrop.executeAirdrop(recipients);
  await showBalances("Week 1 After Airdrop", nocenite, nocenix, [user1, user2, user3]);
  
  // Time travel 1 week
  await ethers.provider.send("evm_increaseTime", [7 * 24 * 60 * 60]); // 7 days
  await ethers.provider.send("evm_mine", []);
  
  // === WEEK 2 ===
  console.log("\n🗓️  WEEK 2");
  // User2 completes more challenges, User3 gets big reward, User1 stays same
  await nocenite.mint(user2.address, ethers.parseEther("800"));  // User2: +800 NCT
  await nocenite.mint(user3.address, ethers.parseEther("2000")); // User3: +2000 NCT
  
  await showBalances("Week 2 NCT Holdings", nocenite, nocenix, [user1, user2, user3]);
  await airdrop.executeAirdrop(recipients);
  await showBalances("Week 2 After Airdrop", nocenite, nocenix, [user1, user2, user3]);
  
  // Time travel 1 week
  await ethers.provider.send("evm_increaseTime", [7 * 24 * 60 * 60]);
  await ethers.provider.send("evm_mine", []);
  
  // === WEEK 3 ===
  console.log("\n🗓️  WEEK 3");
  // User1 makes comeback, User2 gets small reward, User3 gets moderate
  await nocenite.mint(user1.address, ethers.parseEther("1500")); // User1: +1500 NCT
  await nocenite.mint(user2.address, ethers.parseEther("200"));  // User2: +200 NCT
  await nocenite.mint(user3.address, ethers.parseEther("700"));  // User3: +700 NCT
  
  await showBalances("Week 3 NCT Holdings", nocenite, nocenix, [user1, user2, user3]);
  await airdrop.executeAirdrop(recipients);
  await showBalances("Week 3 Final Results", nocenite, nocenix, [user1, user2, user3]);
  
  console.log("\n📊 SUMMARY:");
  console.log("Total NCX distributed over 3 weeks: 3,000,000 NCX");
  console.log("Users earned different amounts each week based on their NCT activity!");
}

async function showBalances(title: string, nocenite: any, nocenix: any, users: any[]) {
  console.log(`\n=== ${title} ===`);
  
  const totalNCT = await nocenite.totalSupply();
  
  for (let i = 0; i < users.length; i++) {
    const user = users[i];
    const nctBalance = await nocenite.balanceOf(user.address);
    const ncxBalance = await nocenix.balanceOf(user.address);
    const percentage = totalNCT > 0 ? (Number(nctBalance) * 100 / Number(totalNCT)).toFixed(1) : "0.0";
    
    console.log(`User${i+1}: ${ethers.formatEther(nctBalance)} NCT (${percentage}%) | ${ethers.formatEther(ncxBalance)} NCX`);
  }
  
  console.log(`Total Supply: ${ethers.formatEther(totalNCT)} NCT | ${ethers.formatEther(await nocenix.totalSupply())} NCX`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
