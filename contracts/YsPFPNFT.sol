// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import './token/ERC721/extensions/ERC721URIStorage.sol';
import './token/ERC721/extensions/ERC721Enumerable.sol';

import './access/Ownable.sol';
import "./utils/Counters.sol";

contract YsPFPNFT is ERC721URIStorage, ERC721Enumerable, Ownable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    string private _baseTokenURI;

    struct NFTINFO{
        string uri;
        uint256 tokenId;
    }
    
    constructor() ERC721("TEST NFT", "NFT"){}

    function _baseURI() internal view virtual override returns (string memory) {
         return _baseTokenURI;
     }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory){
        return super.tokenURI(tokenId);
    }

    function setBaseURI(string memory _uri) external onlyOwner{
        _baseTokenURI = _uri;
    }

    function mintWithTokenURI(address to) external onlyOwner{
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json")));
        _tokenIdCounter.increment();
    }

    function preNMint(address to, uint mintCount) external onlyOwner{
        for( uint256 i = 0; i < mintCount; i++ ){
            uint256 tokenId = _tokenIdCounter.current();
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json")));
            _tokenIdCounter.increment();
        }
    }

    function tokensURI() external view returns (NFTINFO[] memory list){
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