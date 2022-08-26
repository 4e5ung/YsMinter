# 🔒 removeWhitelist

function removeWhitelist(\
bytes \_accounts\
)

\
화이트리스트 제거\
\
\
**Parameters**

| Type  | Value      | Explain        |
| ----- | ---------- | -------------- |
| bytes | \_accounts | 제거 할 화이트리스트 목록 |

**※ ABI Encode 형태**

\
**Example**

```
    // 화이트리스트 계정 정보
    let accountsInfo = [
        [accounts[3].address],
        [accounts[4].address],
        [accounts[5].address],
        [accounts[6].address]
    ]

    // Encode 형태로 치환
    const abiCoder = ethers.utils.defaultAbiCoder;
    const encodeAccountsInfo = abiCoder.encode(["tuple(address)[]"], [accountsInfo]);

    // exec
    await minterContract.removeWhitelist(encodeAccountsInfo);
    
```

