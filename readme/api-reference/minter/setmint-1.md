# 🔒 setMintInfo

function setMintInfo( \
&#x20;   bytes \_mintInfo\
)

\
민팅 정보 입력\
\
\
**Parameters**

| Type  | Value      | Explain  |
| ----- | ---------- | -------- |
| bytes | \_mintInfo | 민팅 정보 목록 |

**※ ABI Encode 형태**

\
**Example**

```
    // 민팅 정보 입력 (아래 순으로 기입)

    uint8   mintIndex;        // 민팅 차수
    uint256 buyCoinAmount;    // 민팅 코인 금액
    uint256 buyTokenAmount;   // 민팅 토큰 금액(존재하지 않을 시 0)
    uint256 buyMaxCount;      // 구매 가능 개수 최대 개수
    uint256 policyType;       // 정책 (Public:0, whiltelist: 1)
    uint256 nftAmount;        // 민팅 발행 개(해당 차수)
    uint256 startTime;        // 민팅 시작 시간(sec)
    uint256 endTime;          // 민팅 종료 시간(sec)

    //  특정 날짜 시간 구하기
    // let date = new Date(2022, 7, 25, 12, 16, 0, 0);
    // console.log(Math.floor(date.getTime())/1000);

    let mintInfo = [
        [1, 500, 0, 2, 1, 2000, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600],
        [2, 1000, 0, 2, 1, 4000, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600],
        [3, 1500, 0, 2, 1, 6000, Math.floor(Date.now()/1000), Math.floor(Date.now() / 1000)+3600]
    ]

    // Encode 형태로 치환
    const abiCoder = ethers.utils.defaultAbiCoder;
    const encodeMintInfo = abiCoder.encode(["tuple(uint8,uint256,uint256,uint256,uint256,uint256,uint256,uint256)[]"], [mintInfo]); 

    // exec
    await minterContract.setMintInfo(encodeMintInfo);
    
```

\
2022.08.26
