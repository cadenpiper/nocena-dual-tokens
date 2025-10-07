import { network } from "hardhat";

const { ethers } = await network.connect();

async function main() {
  const [deployer] = await ethers.getSigners();
  
  console.log("Deploying contracts with account:", deployer.address);
  console.log("Network:", network.name);
  
  // Deploy Nocenite (NCT)
  console.log("\nDeploying Nocenite (NCT)...");
  const nocenite = await ethers.deployContract("Nocenite", [deployer.address]);
  const noceniteAddress = await nocenite.getAddress();
  console.log("Nocenite deployed to:", noceniteAddress);
  
  // Deploy Nocenix (NCX)
  console.log("\nDeploying Nocenix (NCX)...");
  const nocenix = await ethers.deployContract("Nocenix", [deployer.address]);
  const nocenixAddress = await nocenix.getAddress();
  console.log("Nocenix deployed to:", nocenixAddress);
  
  // Deploy Airdrop
  console.log("\nDeploying Airdrop contract...");
  const airdrop = await ethers.deployContract("Airdrop", [
    noceniteAddress,
    nocenixAddress,
    deployer.address
  ]);
  const airdropAddress = await airdrop.getAddress();
  console.log("Airdrop deployed to:", airdropAddress);
  
  // Transfer NCX ownership to Airdrop contract
  console.log("\nTransferring NCX ownership to Airdrop contract...");
  await nocenix.transferOwnership(airdropAddress);
  console.log("NCX ownership transferred to Airdrop contract");
  
  console.log("\n✅ Deployment complete!");
  console.log("Contract addresses saved to CONTRACT_REFERENCES.md");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
