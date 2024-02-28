// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//importing our erc20 smart contract from Zeppelin since we are staking it.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//creating our erc20 staking contract
contract MyToken is ERC20 {
// mapping to get the address and amount of token you want to stake
mapping(address => uint) public staked;
//mapping to get the address and amount of token you want to stake privately
//i.e the function can only be used by this smart contract.
mapping(address => uint) private stakedFromTS;
// special function to initialise our token through the msg.sender
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1000);
    }
    
//function named stake taking the input amount of token you will like to keep
function stake(uint amount) external{
//conditional statement to validate the amount before executing the contract
require(amount >0, "amount is <=0");
//statement to validate the balance of the sender after staking
require(balanceOf(msg.sender) >= amount, "balance is <= amount");
//statement to transfer from the sender with an address and amount to stake.
_transfer(msg.sender, address(this), amount);
//conditional statement saying the sender stakes a token or an amount, claim it
if(staked[msg.sender] > 0){
claim();
}
//privately record the time the sender stakes the token, recording amount and his address
stakedFromTS[msg.sender] = block.timestamp;
//the amount left after the token is staked
staked[msg.sender] += amount;
}
 

//function that you no longer want to stake or keep the token 
function unstake(uint amount) external{
//statement to validate the amount to be unstaked
require(amount >0, "amount is <=0");
//statement to validate that the staked token 
require(staked[msg.sender] > 0, "You did not stake with us");
//the time the sender wants to unstake, though it is private.
stakedFromTS[msg.sender] = block.timestamp;
//reduction in the balance of the sender as he is unstaking. 
staked[msg.sender] -= amount;
//returning the amount of staked token to the sender.
_transfer(address(this), msg.sender, amount);
}
 
//function to claim the staked token
function claim() public {
//statement to validate that the sender's token to be staked is greater than 0
require(staked[msg.sender] > 0, "Staked is <= 0 ");
//the time the sender stakes the token
uint secondsStaked = block.timestamp - stakedFromTS[msg.sender];
//returns on investing of the token staked.
uint rewards = staked[msg.sender] * secondsStaked / 3.154e7;
//adding up the amount of the returns to the address. 
_mint(msg.sender, rewards);
//time of rewards added to the address, tho it is private.
stakedFromTS[msg.sender] = block.timestamp;
 
}
   
}