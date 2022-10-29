import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract } from "ethers";
import { ethers } from "hardhat";

let erc20Contract;
let erc20: Contract;
let owner: SignerWithAddress;
let addr1: SignerWithAddress;
let addr2: SignerWithAddress;

beforeEach(async function () {
  erc20Contract = await ethers.getContractFactory("MyErc20Token");
  [owner, addr1, addr2] = await ethers.getSigners();
  erc20 = await erc20Contract.deploy("My Token", "MTK");
});

describe("Deploy erc20", function () {
  it("Deploy", async function () {
    await erc20.deployed();
  });
});

describe("Mint erc20", function () {
  it("Mint", async function () {
    await erc20.mint(owner.address, 20000);
  });
});
