
const {ethers} = require("hardhat");
const { LedgerSigner } = require("@anders-t/ethers-ledger");

const overrides = {
    // gasPrice: 50000000000,
    gasLimit: 9999999
}

async function main() {

  accounts = await ethers.getSigners();

  nftContract = await (await ethers.getContractFactory("KolaPFPNFT")).deploy(accounts[0].address);
  nftContract.deployed(overrides);
  console.log("nftContract deployed to:", nftContract.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
