// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './token/ERC721/ERC721.sol';
import './token/ERC721/extensions/ERC721URIStorage.sol';

import './access/Ownable.sol';
import "./utils/Counters.sol";


contract YsPFPNFT is ERC721, ERC721URIStorage, Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct NFTINFO{
        string uri;
        uint256 tokenId;
    }
    receive() external payable {}
    
    constructor() ERC721("TEST NFT", "NFT"){}

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }

    function mintWithTokenURI(address to, string memory uri) public{

        (bool sent,) = address(to).call{value: 1*(10**17)}("");
        require(sent, "Failed dripping ETH");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function preNMint( uint mintCount, bytes memory uri) public onlyOwner{
        (string[] memory uriList ) = abi.decode(uri, (string[]));

        for( uint256 i = 0; i < mintCount; i++ ){
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);
            _setTokenURI(tokenId, uriList[i]);            
        }
    }

    function tokensURI() public view returns (NFTINFO[] memory list){
        require( balanceOf(msg.sender) > 0, "ZERO_TOKEN");

        NFTINFO[] memory uriList = new NFTINFO[](balanceOf(msg.sender));

        uint256 k;
        for( uint256 i = 0; i < _tokenIdCounter.current(); i++ ){
            if( msg.sender == ownerOf(i) ){
                uriList[k].uri = tokenURI(i);
                uriList[k].tokenId = i;
                k++;
            }
        }

        return uriList;
    }
}