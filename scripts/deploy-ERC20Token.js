const {ethers} = require("hardhat");
const { LedgerSigner } = require("@anders-t/ethers-ledger");

const overrides = {
    // gasPrice: 50000000000,
    gasLimit: 9999999
}

async function main() {

  accounts = await ethers.getSigners();

  tokenContract = await (await ethers.getContractFactory("ERC20Token")).deploy();

  tokenContract.deployed(overrides);
  console.log("tokenContract deployed to:", tokenContract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
