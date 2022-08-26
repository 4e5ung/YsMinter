# 🔒 setAddress

function setAddress(\
address \_admin,\
address \_tokenOwner,\
address \_token,\
address \_nftContract\
)

\
계정 및 연결 컨트랙트 주소 변경\
\
\
**Parameters**

| Type    | Value         | Explain                |
| ------- | ------------- | ---------------------- |
| address | \_admin       | Admin 계정 주소            |
| address | \_tokenOwner  | Pre-Mint NFT 소유자 계정 주소 |
| address | \_token       | ERC20 토큰 컨트랙트 주소       |
| address | \_nftContract | ERC721 NFT 컨트랙트 주소     |

\
**Example**

```
    // exec 
    await setAddress.setMint(accounts[1].address, 
                            accounts[1].address, 
                            nftContract.address, 
                            nftContract.address
                        )
    
```

