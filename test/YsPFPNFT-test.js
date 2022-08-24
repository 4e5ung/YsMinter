const { expect, assert } = require("chai");
const { ethers, waffle } = require("hardhat");
const { Bignumber } = require("ethers");




describe("YsPFPNFT", function () {

    let accounts;
    let nftContract;
    const MaxUint256 = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

    const overrides = {
        gasLimit: 9999999
    }


    beforeEach(async function () { 
        accounts = await ethers.getSigners();
        nftContract = await (await ethers.getContractFactory("YsPFPNFT")).deploy();
        await nftContract.setBaseURI("https://test.com/");
    });

    it("mintWithTokenURI, NFT 단일 민팅", async function(){
        await nftContract.mintWithTokenURI(accounts[0].address);     
        
        expect(await nftContract.totalSupply())
        .to.equal(1);
    })

    it("preNMint, NFT 복수 민팅", async function(){
        await nftContract.preNMint(accounts[0].address, 10);
        
        expect(await nftContract.totalSupply())
        .to.equal(10);
    })

});
