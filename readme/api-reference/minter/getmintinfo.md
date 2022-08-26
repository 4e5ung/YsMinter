# getMintInfo

function getMintInfo(\
)external returns(MintInfo \[] mintInfo, uint256 totalBalance, uint256 \_currentBalance)

\
민팅 정보 얻기\
\


**Return Values**

```
struct MintInfo{
    uint8   mintIndex;        // 민팅 차수
    uint256 buyCoinAmount;    // 민팅 코인 금액
    uint256 buyTokenAmount;   // 민팅 토큰 금액(존재하지 않을 시 0)
    uint256 buyMaxCount;      // 구매 가능 개수 최대 개수
    uint256 policyType;       // 화리/Public 등.. 정책
    uint256 nftAmount;        // 민팅 발행 개(해당 차수)
    uint256 startTime;        // 민팅 시작 시간(sec)
    uint256 endTime;          // 민팅 종료 시간(sec)
}
```

| Type        | Value            | Explain  |
| ----------- | ---------------- | -------- |
| MintInfo\[] | \_mintInfo       | 민팅 정보들   |
| uint256     | \_totalBalance   | 전체 민팅 개수 |
| uint256     | \_currentBalance | 현재 민팅 개수 |

\
**Example**

```
    // exec    
    await minterContract.getMintInfo();

    // Result
    _mintInfo: [
    [
      mintIndex: 1,
      buyCoinAmount: BigNumber { value: "500" },
      buyTokenAmount: BigNumber { value: "0" },
      buyMaxCount: BigNumber { value: "2" },
      policyType: BigNumber { value: "0" },
      nftAmount: BigNumber { value: "1" },
      startTime: BigNumber { value: "1661412408" },
      endTime: BigNumber { value: "1661416008" }
    ],
    [
      mintIndex: 2,
      buyCoinAmount: BigNumber { value: "1000" },
      buyTokenAmount: BigNumber { value: "0" },
      buyMaxCount: BigNumber { value: "2" },
      policyType: BigNumber { value: "1" },
      nftAmount: BigNumber { value: "5" },
      startTime: BigNumber { value: "1661412408" },
      endTime: BigNumber { value: "1661416008" }
    ],
    [
      mintIndex: 3,
      buyCoinAmount: BigNumber { value: "1500" },
      buyTokenAmount: BigNumber { value: "0" },
      buyMaxCount: BigNumber { value: "2" },
      policyType: BigNumber { value: "1" },
      nftAmount: BigNumber { value: "10" },
      endTime: BigNumber { value: "1661423208" }
    ]
  ],
  _totalBalance: BigNumber { value: "200" },
  _currentBalance: BigNumber { value: "0" }
```

\
2022.08.25
