const { expect, assert } = require("chai");
const { ethers, waffle } = require("hardhat");
const { Bignumber } = require("ethers");




describe("Minter", function () {

    let accounts;
    let minterContract;
    const MaxUint256 = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

    const overrides = {
        gasLimit: 9999999
    }


    beforeEach(async function () { 
        accounts = await ethers.getSigners();

        minterContract = await (await ethers.getContractFactory("Minter")).deploy(accounts[0].address);

        let accountsInfo = [
            [accounts[0].address, 1],
            [accounts[1].address, 2],
            [accounts[2].address, 1],
            [accounts[3].address, 3]
        ]

        const abiCoder = ethers.utils.defaultAbiCoder;
        const encodeAccountsInfo = abiCoder.encode(["tuple(address, uint256)[]"], [accountsInfo]);

        tx = await minterContract.addWhitelist(encodeAccountsInfo, overrides);
        tx.wait();
    });

    it("addWhitelist, 화이트 리스트 추가(복수가능)", async function(){
        
        let accountsInfo = [
            [accounts[3].address, 1],
            [accounts[4].address, 2],
            [accounts[5].address, 1],
            [accounts[6].address, 3]
        ]

        const abiCoder = ethers.utils.defaultAbiCoder;
        const encodeAccountsInfo = abiCoder.encode(["tuple(address, uint256)[]"], [accountsInfo]);

        tx = await minterContract.addWhitelist(encodeAccountsInfo, overrides);
        tx.wait();

        expect(await minterContract.isWhitelist(accounts[6].address))
        .to.equal(3)
    })

    it("removeWhitelist, 화이트 리스트 제거(복수가능)", async function(){
        
        let accountsInfo = [
            [accounts[0].address],
            [accounts[1].address],
            [accounts[2].address],
            [accounts[3].address]
        ]

        const abiCoder = ethers.utils.defaultAbiCoder;
        const encodeAccountsInfo = abiCoder.encode(["tuple(address)[]"], [accountsInfo]);

        tx = await minterContract.removeWhitelist(encodeAccountsInfo, overrides);
        tx.wait();

        await expect(minterContract.isWhitelist(accounts[1].address))
        .to.be.revertedWith("Minter: E02");
    })

    it("removeAllWhitelist, 화이트 리스트 모두 제거", async function(){
        tx = await minterContract.removeAllWhitelist(overrides);
        tx.wait();
        
        await expect(minterContract.isWhitelist(accounts[1].address))
        .to.be.revertedWith("Minter: E02");
    })

    it("isWhitelist, 화이트리스트 등록된 사용자인지 확인", async function(){        
        expect(await minterContract.isWhitelist(accounts[1].address))
        .to.equals(2);
    })

    it("getWhitelist, 화이트 리스트 정보 받아오기", async function(){        
        whitelist = await minterContract.getWhitelist();
        assert.equal(whitelist.length, 4);
    })

    it.only("setMintInfo, 민팅정보 입력", async function(){        
        // uint8   mintIndex;
        // uint256 buyCoinAmount;
        // uint256 buyTokenAmount;
        // uint256 buyMaxCount;
        // uint256 policyType;
        // uint256 nftAmount;
        // uint256 startTime;
        // uint256 endTime;

        let mintInfo = [
            [1, 500, 0, 2, 1, 2000, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600],
            [2, 1000, 0, 2, 1, 4000, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600],
            [3, 1500, 0, 2, 1, 6000, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600]
        ]

        const abiCoder = ethers.utils.defaultAbiCoder;
        const encodeMintInfo = abiCoder.encode(["tuple(uint8,uint256,uint256,uint256,uint256,uint256,uint256,uint256)[]"], [mintInfo]); 

        tx = await minterContract.setMintInfo(encodeMintInfo, overrides);
        tx.wait();

        result = await minterContract.getMintInfo(1, overrides);
        console.log(result)
    })

});
