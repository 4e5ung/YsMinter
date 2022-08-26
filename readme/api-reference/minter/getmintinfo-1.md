# 🔒 getWhitelist

function getWhitelist(\
)external returns(WhiteListInfo\[] info)

\
등록 된 화이트리스트 계정 정보 보기\
\


**Return Values**

```
struct WhiteListInfo{
    address account;        // 화이트리스트 계정
    uint256 policyType;     // 정책(기본:1)
}
```

| Type             | Value | Explain    |
| ---------------- | ----- | ---------- |
| WhiteListInfo\[] | info  | 화이트리스트 정보들 |

\
**Example**

```
    // exec    
    await minterContract.getWhitelist();

    // Result
    [
      [
        account: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        policyType: BigNumber { value: "1" }
      ],
      [
        account: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
        policyType: BigNumber { value: "2" }
      ],
      [
        account: '0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC',
        policyType: BigNumber { value: "1" }
      ],
      [
        account: '0x90F79bf6EB2c4f870365E785982E1f101E93b906',
        policyType: BigNumber { value: "3" }
      ]
    ]
```

\
2022.08.26
