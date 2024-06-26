// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MyContractCrowdFunding {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public fundsRaised;

    mapping(address => uint) public contributions;

    constructor(uint _goal, uint _duration) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
        }

    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign is over");
        require(msg.value > 0, "Contribution must be greater than zero");
        contributions[msg.sender] += msg.value;
        fundsRaised += msg.value;
    }

    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw funds");
        require(block.timestamp >= deadline, "Campaign is not over yet");
        require(fundsRaised >= goal, "Funding goal not reached");
        (bool sent, ) = payable(owner).call{value: address(this).balance}(""); 
        require(sent == true, "Transfer failed");

    }

    function getRefund() external {
        require(block.timestamp >= deadline, "Campaign is over");
        require(fundsRaised < goal, "Funding goal was reached");
        uint amount = contributions[msg.sender];
        require(amount > 0, "No contributions found");
        contributions[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}(""); 
        require(sent == true, "Transfer failed");
    }
}