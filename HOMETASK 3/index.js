const Web3 = require("web3");
var web3 = new Web3(
  "https://goerli.infura.io/v3/9fb9998718a74e1b8582070cb09f86c0"
);
const address = "0x32E8d309d0BD2c446C4e6c0A5DAfab8dB6664d17";
const ABI = require("./abi.json");
const myContract = new web3.eth.Contract(ABI, address);
myContract.methods
  .balanceOf("0xC6A3D8A337164C2ECA9558e5844Bc303A6075CF5")
  .call()
  .then(console.log);