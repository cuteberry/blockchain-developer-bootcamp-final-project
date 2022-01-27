# blockchain-developer-bootcamp-final-project

## Table of Contents

# Crypto Fund Withholding
The current nature of Crypto transation has been non-revertable. It's a challenge for use cases that need the fund to be withhold for a period of time before release it to the other party or have the ability to cancel the transaction if certain conditiaons don't meet. 

## Use case 
1. Withhold: this is used to hold certain amount of money so that some transaction can be executed later. 

2. For merchandise purchase, we can hold the fund before the buyer recieves the merchandise. This protected the seller for the risk of not getting the payment and the buyer for not recieve the goods. 

3. For donation management, we can hold the fund in the contract. The distribution of fund to recievers will be managed by the contractor. 

## Test
run `truffle test` with ganche-cli on port 8545

## Folder structure
```
BLOCKCHAIN-DEVELOPER-BOOTCAMP-FINAL-PROJECT
|── client
|    └── public
|    └── src
|           └── components
|           └── contracts // json file for smart contract abi
|           └── hooks
|               └── useMiddleMan.js // how smart contact is used by frontend code
|           └── pages
|           └── static
|           └── styles
|           └── utils
|── contracts // smart contracts source code
|── docs
|── migrations
|── test
|── truffle-config.js // smartcontract network deployment configuration 
```

## Command 
[Ganache-cli](https://trufflesuite.com/docs/ganache/quickstart.html)

[truffle](https://trufflesuite.com/docs/truffle/quickstart.html) command
```
truffle develop
truffle console
truffle migrate
truffle migrate —network ganache
truffle test --debug
truffle migrate --network develop
truffle migrate —network ropsten
``` 

for front end
```
pm install --global yarn
cd client
yarn start
```


## Author's public ethereum account
Mei Lazell
0x32A0b7fE6C354b8333EB00096C62ba32062FCcB8

## [Screen cast of final project](https://drive.google.com/file/d/116_89AJQnns5Jth5AYIigYG79U8ycLLA/view?usp=sharing)

## Public Deployed Frontend Site Using Netlify
[https://musing-leavitt-df2f94.netlify.app/](https://musing-leavitt-df2f94.netlify.app/)





