import { ethers } from "hardhat";

async function main() {

  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account: ", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());
	
  const rpsFactory = await ethers.getContractFactory("RockPaperScissors");
  const rps = await rpsFactory.deploy();

  console.log("Created origin contract at address: ", rps.address);

  const rpsCallerFactory = await ethers.getContractFactory("RockPaperScissorsCaller");
  const rpsCaller = await rpsCallerFactory.deploy();

  console.log("Deployed rpsCaller contract at address: ", rpsCaller.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});