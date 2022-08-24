const { expect, assert } = require("chai");
const { ethers, waffle } = require("hardhat");
const { Bignumber } = require("ethers");




describe("Minter", function () {

    let accounts;
    let account1;
    let account2;
    let minterContract;
    let nftContract;
    let tokenContract;
    const MaxUint256 = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

    const overrides = {
        gasLimit: 9999999
    }


    beforeEach(async function () { 
        accounts = await ethers.getSigners();

        tokenContract = await (await ethers.getContractFactory("ERC20Token")).deploy();
        nftContract = await (await ethers.getContractFactory("YsPFPNFT")).deploy();
        minterContract = await (await ethers.getContractFactory("Minter")).deploy(accounts[0].address, accounts[0].address, tokenContract.address, nftContract.address);

        // 임의 화이트리스트 등록
        let accountsInfo = [
            [accounts[0].address, 1],
            [accounts[1].address, 2],
            [accounts[2].address, 1],
            [accounts[3].address, 3]
        ]

        let abiCoder = ethers.utils.defaultAbiCoder;
        const encodeAccountsInfo = abiCoder.encode(["tuple(address, uint256)[]"], [accountsInfo]);

        tx = await minterContract.addWhitelist(encodeAccountsInfo, overrides);
        tx.wait();

        // 임의 민팅 및 권한 허용
        await nftContract.preNMint(accounts[0].address, 200);
        await nftContract.setApprovalForAll(minterContract.address, true);

        // 민팅 옵션 설정
        // uint8   mintIndex;
        // uint256 buyCoinAmount;
        // uint256 buyTokenAmount;
        // uint256 buyMaxCount;
        // uint256 policyType;
        // uint256 nftAmount;
        // uint256 startTime;
        // uint256 endTime;
        let mintInfo = [
            [1, 500, 0, 2, 0, 1, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600],
            [2, 1000, 500, 2, 1, 5, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600],
            [3, 1500, 0, 2, 1, 10, Math.floor(Date.now()/1000)+7200, Math.floor(Date.now() / 1000)+(3600*3)]
        ]

        abiCoder = ethers.utils.defaultAbiCoder;
        const encodeMintInfo = abiCoder.encode(["tuple(uint8,uint256,uint256,uint256,uint256,uint256,uint256,uint256)[]"], [mintInfo]); 

        tx = await minterContract.setMintInfo(encodeMintInfo, overrides);
        tx.wait();
    });

    it("setMint, 구매(토큰) 금액 오류", async function(){
        await tokenContract.approve(accounts[0].address, MaxUint256);
        await tokenContract.transferFrom(accounts[0].address, accounts[1].address, ethers.utils.parseEther("1000.0"));

        await tokenContract.connect(accounts[1]).approve(minterContract.address, MaxUint256);

        await expect(minterContract.connect(accounts[1]).setMint(2, 2, 1))
        .to.be.revertedWith("Minter: E11")
    });

    it("setMint, 구매(토큰) Approve 오류", async function(){
        await tokenContract.approve(accounts[0].address, MaxUint256);
        await tokenContract.transferFrom(accounts[0].address, accounts[1].address, ethers.utils.parseEther("1000.0"));

        await expect(minterContract.connect(accounts[1]).setMint(2, 1, 1))
        .to.be.revertedWith("ERC20: insufficient allowance")
    });
    
    it("setMint, 구매(코인) 금액 오류", async function(){
        await expect(minterContract.connect(accounts[1]).setMint(2, 1, 0, {value: ethers.utils.parseEther("500.0")}))
        .to.be.revertedWith("Minter: E10");

        await expect(minterContract.connect(accounts[1]).setMint(2, 1, 0, {value: ethers.utils.parseEther("1500.0")}))
        .to.be.revertedWith("Minter: E10");
    });

    it("setMint, 현재 NFT 구매 개수 오류", async function(){
        await minterContract.connect(accounts[1]).setMint(2, 2, 0, {value: ethers.utils.parseEther("2000.0")});

        await expect(minterContract.connect(accounts[1]).setMint(2, 1, 0, {value: ethers.utils.parseEther("1000.0")}))
        .to.be.revertedWith("Minter: E09");

        await expect(minterContract.connect(accounts[1]).setMint(2, 2, 0, {value: ethers.utils.parseEther("2000.0")}))
        .to.be.revertedWith("Minter: E09");
    });

    it("setMint, 화이트리스트 오류", async function(){
        await expect(minterContract.connect(accounts[4]).setMint(2, 2, 0, {value: ethers.utils.parseEther("1000.0")}))
        .to.be.revertedWith("Minter: E08");
    });

    it("setMint, 전체 발행량 대비 현재 발행량 오류", async function(){
        await expect(minterContract.connect(accounts[1]).setMint(1, 2, 0, {value: ethers.utils.parseEther("1000.0")}))
        .to.be.revertedWith("Minter: E07");
    });

    it("setMint, 최소,최대 구매 개수 오류", async function(){
        await expect(minterContract.connect(accounts[1]).setMint(1, 0, 0, {value: ethers.utils.parseEther("0.0")}))
        .to.be.revertedWith("Minter: E06");

        await expect(minterContract.connect(accounts[1]).setMint(1, 3, 0, {value: ethers.utils.parseEther("0.0")}))
        .to.be.revertedWith("Minter: E06");
    });

    it("setMint, 민팅 기간 오류", async function(){
        await expect(minterContract.connect(accounts[1]).setMint(3, 1, 0, {value: ethers.utils.parseEther("500.0")}))
        .to.be.revertedWith("Minter: E05");
    });

    it("setMint, 민팅 차수 오류", async function(){
        await expect(minterContract.connect(accounts[1]).setMint(0, 1, 0, {value: ethers.utils.parseEther("500.0")}))
        .to.be.revertedWith("Minter: E04");

        await expect(minterContract.connect(accounts[1]).setMint(4, 1, 0, {value: ethers.utils.parseEther("500.0")}))
        .to.be.revertedWith("Minter: E04");
    });
});
