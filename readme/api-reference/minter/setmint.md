# setMint

function setMint(\
uint8 mintIndex,\
uint8 mintCount,\
uint8 buyType\
)external

\
민팅하기\
\
\
**Parameters**

| Type  | Value     | Explain                        |
| ----- | --------- | ------------------------------ |
| uint8 | mintIndex | 민팅 차수                          |
| uint8 | mintCount | 민팅 개수                          |
| uint8 | buyType   | <p>구매 형태<br>(코인: 1, 토큰: 2)</p> |

\
**Example**

```
    // exec (1차 민팅, 2개 구매, 코인 형태 구매)
    await minterContract.connect(accounts[1]).setMint(1, 2, 1)
    
```

