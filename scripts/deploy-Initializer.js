const {ethers} = require("hardhat");
const { LedgerSigner } = require("@anders-t/ethers-ledger");

const overrides = {
    // gasPrice: 50000000000,
    gasLimit: 30000000
}

let tokenContract;
let nftContract;
let minterContract;

async function setMintInfo(){
    let mintInfo = [
      [1, 500, 500, 2, 0, 1000, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000) + (86400*3)],
      [2, 1000, 0, 2, 1, 4000, Math.floor(Date.now()/1000)+(86400*3), Math.floor(Date.now() / 1000)+(86400*7)],
    ]

    const abiCoder = ethers.utils.defaultAbiCoder;
    const encodeMintInfo = abiCoder.encode(["tuple(uint8,uint256,uint256,uint256,uint256,uint256,uint256,uint256)[]"], [mintInfo]); 

    tx = await minterContract.setMintInfo(encodeMintInfo, overrides);
    tx.wait();
}

async function preNMint(){
  for(let i = 0; i < 25; i++ ){
    tx = await nftContract.preNMint(accounts[0].address, 200, overrides);
    tx.wait();
  }

  total = await nftContract.totalSupply();
  console.log(total);
}

async function main() {

  accounts = await ethers.getSigners();

  tokenContract = await (await ethers.getContractFactory("ERC20Token")).deploy();
  tokenContract.deployed(overrides);

  nftContract = await (await ethers.getContractFactory("KolaPFPNFT")).deploy(accounts[0].address);
  nftContract.deployed(overrides);

  minterContract = await (await ethers.getContractFactory("Minter")).deploy(accounts[0].address, accounts[0].address, tokenContract.address, nftContract.address);
  minterContract.deployed(overrides);

  console.log("tokenContract deployed to:", tokenContract.address);
  console.log("nftContract deployed to:", nftContract.address);
  console.log("minterContract deployed to:", minterContract.address);

  await preNMint();
  await setMintInfo();
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
