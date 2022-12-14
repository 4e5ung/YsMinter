// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import './token/ERC721/extensions/IERC721Enumerable.sol';
import './token/ERC721/IERC721.sol';
import './token/ERC20/IERC20.sol';
import "./utils/Counters.sol";

contract Minter{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    address private admin;
    address private tokenOwner;
    address private token;
    address private nftContract;
    
    address[] private whiteList;

    uint8 private totalIndex;


    mapping(address=>mapping(uint256=>uint256)) mintAccount;
    mapping(address=>uint256) whiteMap;
    mapping(uint8=>MintInfo) mintInfo;


    event mint(address, uint256);
    event addList(address, uint256);
    event removeList(address);
    event removeAllList();

    enum PolicyType {
        Public,
        OGWhiteList
    }

    enum BuyType {
        Coin,
        Token
    }

    struct WhiteListInfo{
        address account;
        uint256 policyType;
    }


    struct MintInfo{
        uint8   mintIndex;
        uint256 buyCoinAmount;
        uint256 buyTokenAmount;
        uint256 buyMaxCount;
        uint256 policyType;
        uint256 nftAmount;
        uint256 startTime;
        uint256 endTime;
    }

    constructor(address _admin, address _tokenOwner, address _token, address _nftContract) {
        admin = _admin;
        tokenOwner = _tokenOwner;
        token = _token;
        nftContract = _nftContract;
	}

    receive() external payable {
    }

    modifier onlyAdmin(){
         require(admin == msg.sender, "Minter: E01");
        _;
    }

    function setMintInfo(bytes memory _mintInfo) external onlyAdmin{
        (MintInfo[] memory info ) = abi.decode(_mintInfo, (MintInfo[]));

        for( uint256 i = 0; i < info.length; i++ ){        
            mintInfo[info[i].mintIndex] = info[i];
        }

        totalIndex = uint8(info.length);
    }

    function getMintInfo() external view returns (MintInfo[] memory _mintInfo, uint256 _totalBalance, uint256 _currentBalance){
        require(totalIndex != 0, "Minter: E12");

        _mintInfo = new MintInfo[](totalIndex);

        for(uint8 i = 0; i < totalIndex; i++){
            _mintInfo[i] = mintInfo[i+1];
        }

        _totalBalance = IERC721Enumerable(nftContract).totalSupply();
        _currentBalance = _tokenIdCounter.current();
    }

    function setMint(uint8 mintIndex, uint8 mintCount, uint8 buyType) external payable{
        // ????????? ?????? ??????????????? ??????
        require(mintInfo[mintIndex].mintIndex != 0, "Minter: E04");

        // ????????? ????????? ?????? ?????? ??????
        uint256 _currentTime = block.timestamp;
        require((mintInfo[mintIndex].startTime <= _currentTime) && (mintInfo[mintIndex].endTime > _currentTime), "Minter: E05");

        // ??????, ?????? ?????? ??????
        require( (0 < mintCount) && (mintInfo[mintIndex].buyMaxCount >= mintCount), "Minter: E06");

        // ?????? ????????? ?????? ?????? ????????? ??????
        uint tokenId = _tokenIdCounter.current();
        uint accumulateAmount;

        for(uint8 i = 1; i <= mintIndex; i++){
            accumulateAmount += mintInfo[i].nftAmount;
        }

        require(accumulateAmount >= (tokenId+mintCount), "Minter: E07");

        // whitelist?????? ?????? ??????
        if( mintInfo[mintIndex].policyType == uint8(PolicyType.OGWhiteList) ){
            require(whiteMap[msg.sender] != 0, "Minter: E08");
        }
        
        // ?????? ????????? ?????? ??????
        require(mintInfo[mintIndex].buyMaxCount >= (mintAccount[msg.sender][mintIndex]+mintCount), "Minter: E09");

        // ?????? ?????? ??????
        if( buyType == uint8(BuyType.Coin) ){
            uint amount = mintInfo[mintIndex].buyCoinAmount*(10**18);
            require((amount > 0) && ((amount*mintCount) == msg.value), "Minter: E10");
        }

        // ?????? ?????? ?????? ??? ??????
        if( buyType == uint8(BuyType.Token) ){
            uint256 amount = mintInfo[mintIndex].buyCoinAmount*mintCount*(10**18);
            require((amount > 0) && (IERC20(token).balanceOf(msg.sender) >= amount*mintCount), "Minter: E11");
            IERC20(token).transferFrom(msg.sender, address(this), amount*mintCount);
        }
        
        // Mint ??????(transfer)
        for( uint256 i=0 ; i < mintCount; i++ ){
            IERC721(nftContract).transferFrom(address(tokenOwner), msg.sender, tokenId);
            emit mint(msg.sender, tokenId);

            _tokenIdCounter.increment();
            tokenId = _tokenIdCounter.current();
            mintAccount[msg.sender][mintIndex]++;
        }
    }

    function addWhitelist(bytes memory _list) external onlyAdmin{
        (WhiteListInfo[] memory lists ) = abi.decode(_list, (WhiteListInfo[]));

        for( uint256 i = 0; i < lists.length; i++ ){
            if( whiteMap[lists[i].account] == 0 ){
                whiteList.push(lists[i].account);
            }

            whiteMap[lists[i].account] = lists[i].policyType;
            emit addList(lists[i].account, lists[i].policyType);
        }
        
    }

    function removeWhitelist(bytes memory _accounts) external onlyAdmin{
        (address[] memory accounts ) = abi.decode(_accounts, (address[]));

        for( uint256 i = 0; i < accounts.length; i++ ){
            if( whiteMap[accounts[i]] != 0 ){
                delete whiteMap[accounts[i]];
                emit removeList(accounts[i]);

                for( uint256 j = 0; j<whiteList.length; j++ ){
                    if( whiteList[j] == accounts[i] ){
                        whiteList[j] = whiteList[whiteList.length-1];
                        whiteList.pop();
                        break;
                    }
                }
            }
        }
    }

    function removeAllWhitelist() external onlyAdmin{
        for( uint256 i = 0; i<whiteList.length; i++ ){
            delete whiteMap[whiteList[i]];
        }

        delete whiteList;
        emit removeAllList();
    }

    function isWhitelist(address _account) external view returns(uint256 policyType){
        require( whiteMap[_account] != 0, "Minter: E02");
        policyType = whiteMap[_account];
    }

    function getWhitelist() external view onlyAdmin returns(WhiteListInfo[] memory info){
        require(whiteList.length != 0, "Minter: E03");

        info = new WhiteListInfo[](whiteList.length);

        for( uint256 i = 0; i < whiteList.length; i++ ){
            info[i].account = whiteList[i];
            info[i].policyType = whiteMap[whiteList[i]];
        }
    }

    function setAddress(address _admin, address _tokenOwner, address _token, address _nftContract) external onlyAdmin{
        admin = _admin;
        tokenOwner = _tokenOwner;
        token = _token;
        nftContract = _nftContract;
    }
}