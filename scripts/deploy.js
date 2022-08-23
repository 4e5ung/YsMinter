const {ethers} = require("hardhat");
const { LedgerSigner } = require("@anders-t/ethers-ledger");

const overrides = {
    // gasPrice: 50000000000,
    gasLimit: 9999999
}

async function main() {

  accounts = await ethers.getSigners();

  whiteListContract = await (await ethers.getContractFactory("Minter")).deploy(accounts[0].address);
  whiteListContract.deployed(overrides);

  console.log("whiteListContract deployed to:", whiteListContract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
