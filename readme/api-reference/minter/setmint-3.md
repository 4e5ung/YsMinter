# 🔒 addWhitelist

function addWhitelist( \
&#x20;   bytes \_list\
)

\
화이트리스트 추가\
\
\
**Parameters**

| Type  | Value  | Explain        |
| ----- | ------ | -------------- |
| bytes | \_list | 등록 할 화이트리스트 목록 |

**※ ABI Encode 형태**

\
**Example**

```
    // 화이트리스트 계정 정보 및 권한(기본:1)
    let accountsInfo = [
        [accounts[3].address, 1],
        [accounts[4].address, 2],
        [accounts[5].address, 1],
        [accounts[6].address, 3]
    ]

    // Encode 형태로 치환
    const abiCoder = ethers.utils.defaultAbiCoder;
    const encodeAccountsInfo = abiCoder.encode(["tuple(address, uint256)[]"], [accountsInfo]);

    // exec
    await minterContract.addWhitelist(encodeAccountsInfo);
    
```

\
2022.08.26
