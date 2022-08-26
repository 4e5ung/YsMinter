# isWhitelist

function isWhitelist( \
&#x20;   address \_account\
)external returns(uint256 policyType)

\
화이트리스트 권한 체크\
\
\
**Parameters**

| Type    | Value     | Explain     |
| ------- | --------- | ----------- |
| address | \_account | 확인 할 계정 주소  |



**Return Values**

| Type    | Value      | Explain                   |
| ------- | ---------- | ------------------------- |
| uint256 | policyType | <p>화이트리스트 권한<br>(기본1)</p> |

\
**Example**

```
    // exec    
    await minterContract.isWhitelist(accounts[6].address)

    // Result
    BigNumber { value: "1" }
```

\
2022.08.25
