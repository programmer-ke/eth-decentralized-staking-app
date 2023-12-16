// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;
  mapping ( address => uint256 ) public balances;
  uint public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 30 seconds;

  // a variable to increment so that we can generate blocks hardhat network.
  uint private count;

  event Stake(address sender, uint256 amount);
  
  /// An enumeration of possible states + state variable to track the current one
  enum State { Opened, OpenForWithdrawals, Completed }
    State public currentState;

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
      currentState = State.Opened;
  }

  /* The 3 possible events handlers follow: */
  
  /// The `stake` event handler for adding funds to the contract
  function stake () public payable {
    bool _deadlinePassed = block.timestamp > deadline;

    if (currentState == State.Opened && !_deadlinePassed) {
      doStake();
    } else {
      revert("Cannot stake at this time");
    }
    
  }

  /// The `execute` event handler for closing the staking operation
  /// Either transfer funds to external contract, or
  /// allow stakers to withdraw their balances.
  function execute () public {
    bool _deadlinePassed = block.timestamp > deadline;
    bool _thresholdMet = address(this).balance >= threshold;
    
    if (currentState == State.Opened && _deadlinePassed) {

      if (_thresholdMet) {
	completeStake();
      } else {
	openStakeForWithdrawals();

      }
    } else {
      revert("Cannot execute at this time");
    }
  }

  /// The `withdraw` event handler for removal of funds
  function withdraw () public {

    if (currentState == State.OpenForWithdrawals) {
      doWithdraw();
    } else {
      revert("Cannot withdraw at this time");
    }
  }

  /* helper function for the events above */
  
  function doWithdraw() private {
    uint256 _senderBalance = balances[msg.sender];
    balances[msg.sender] -= _senderBalance;
    (bool sent, ) = msg.sender.call{value: _senderBalance}("");
    require(sent, "UNABLE TO SEND ETHER");
  }

  function completeStake() private {
    currentState = State.Completed;
    exampleExternalContract.complete{value: address(this).balance}();
  }

  function openStakeForWithdrawals() private {
    currentState = State.OpenForWithdrawals;
  }

  function doStake() private {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  
  /* Additional helper function for contract interaction */ 

  /// Sends time left to the client UI
  function timeLeft() public view returns (uint256) {
    return deadline < block.timestamp ? 0 : deadline - block.timestamp;
  }

  /// Allows funds sent directly to the contract to be automatically staked
  receive() external payable {
    stake();
  }

  /// Dummy block generator for the local network
  /// We need to write to the local network to generate new blocks
  /// used for timestamp comparisons
  function generateBlocks() public {
    count += 1;
  }

}
