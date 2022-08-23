// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Minter{


    address private admin;
    address[] private whiteList;

    mapping(address=>uint256) whiteMap;
    mapping(uint8=>MintInfo) mintInfo;


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

    constructor(address _admin) {
        admin = _admin;
	}

    receive() external payable {
    }

    modifier onlyAdmin(){
         require(admin == msg.sender, "Minter: E01");
        _;
    }

    function setMintInfo(bytes memory _mintInfo) external onlyAdmin{
        (MintInfo[] memory mintInfos ) = abi.decode(_mintInfo, (MintInfo[]));

        for( uint256 i = 0; i < mintInfos.length; i++ ){            
            mintInfo[mintInfos[i].mintIndex] = mintInfos[i];
        }
    }

    function getMintInfo(uint8 mintIndex) external view returns (MintInfo memory _mintInfo){
        require(mintInfo[mintIndex].mintIndex != 0, "Minter: E0X");
        _mintInfo = mintInfo[mintIndex];
    }

    function setMint(uint8 mintIndex, uint8 mintCount, uint8 buyType) external payable{
        // 설정된 차수 존재하는지 확인
        require(mintInfo[mintIndex].mintIndex != 0, "1");

        // 지정된 차수에 대해 시간 체크
        uint256 _currentTime = block.timestamp;
        require(mintInfo[mintIndex].startTime <= _currentTime, "");
        require(mintInfo[mintIndex].endTime > _currentTime, "");

        // 전체 발행량 대비 현재 발행량 체크


        // whitelist라면 권한 체크
        if( mintInfo[mintIndex].policyType == uint8(PolicyType.OGWhiteList) ){
            require(whiteMap[msg.sender] != 0, "");
        }
        
        // 최대 구매 개수 및 현재 구매한 개수 확인
        require(mintInfo[mintIndex].buyMaxCount >= mintCount, "");



        // 구매 금액 확인
        if( buyType == uint8(BuyType.Coin) ){
            require((mintInfo[mintIndex].buyCoinAmount*mintCount) == msg.value, "");
        }

        // 토큰 밸런스 확인        
        if( buyType == uint8(BuyType.Token) ){
            // require((mintInfo[mintIndex].buyCoinAmount*mintCount) == msg.value, "");
        }
        
        // 금액 전송

        // Mint 진행(transfer)
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
}