// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  mapping ( address => uint256 ) public balances;
  uint public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 72 hours;
  bool public openForWithdraw = false;
  bool private executed = false;

  event Stake(address sender, uint256 amount);
  
  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  modifier executeOnce () {
    if (block.timestamp <= deadline) return;
    require(!executed, "CAN ONLY EXECUTE ONCE");
    _;
    executed = true;
  }

  modifier onlyBeforeDeadline () {
    require(block.timestamp <= deadline, "ONLY ALLOWED BEFORE DEADLINE");
    _;
  }

  modifier notCompleted () {
    require(!exampleExternalContract.completed(), "ALREADY COMPLETED");
    _;
  }
  

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)

  function stake () public payable onlyBeforeDeadline notCompleted {

    balances[msg.sender] += msg.value;  // each new record initialized by zero
    emit Stake(msg.sender, msg.value);
    
  }


  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance

  function execute () public executeOnce notCompleted {

    if (address(this).balance >= threshold) {
      exampleExternalContract.complete{value: address(this).balance}();
    } else {
      openForWithdraw = true;
    }

  }

  function withdraw () public notCompleted {
    require(openForWithdraw, "NOT OPEN FOR WITHDRAWAL");

    uint256 _senderBalance = balances[msg.sender];
    (bool sent, ) = msg.sender.call{value: _senderBalance}("");
    require(sent, "UNABLE TO SEND ETHER");
    balances[msg.sender] -= _senderBalance;
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    return deadline < block.timestamp ? 0 : deadline - block.timestamp;
  }
  

  // Add the `receive()` special function that receives eth and calls stake()
  receive() external payable {
    stake();
  }

}
