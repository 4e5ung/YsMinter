# kola-pfp-minter

Minter SmartContract

- Polygon WhiteList

- Mumbai WhiteList 


## 실행 환경
npm install

- mumbai cvtx ledger deploy

npx hardhat run .\scripts\deploy-cvtx-ledger.js (deploy) --network mumbai_ledger


## ERROR CODE

Error String 정의

| ErrorCode | Description |
| :--- | :--- |
| `WhiteList: E01` |  admin 계정이 올바르지 않음 |
| `WhiteList: E02` |  화이트리스트에 계정이 존재하지 않음|
| `WhiteList: E03` |  화이트리스트에 등록된 계정 없음|

<hr>