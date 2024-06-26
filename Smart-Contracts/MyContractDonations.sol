// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MyContractDonations {
    address public owner;
    address public beneficiary;


constructor(address _beneficiary) {
    owner = msg.sender;
    beneficiary = _beneficiary;
}

function updateBeneficiary(address _beneficiary) external {
    require(msg.sender == owner, "Only owner can update beneficiary");
    beneficiary = _beneficiary;
}

function deposit() external payable {
    uint donationAmount = msg.value * 1 / 100;
    (bool sent, ) = payable(beneficiary).call{value: donationAmount} ("");
    require(sent == true, "Transfer failed");
    }

function withdraw(address recipient, uint amount) external {
    require(msg.sender == owner, "Only owner can withdraw");
    require(address(this).balance >= amount, "Amount too large");
    (bool sent, ) = payable(recipient).call{value: amount} ("");
    require(sent == true, "Transfer failed");
    }
    // 1 ETH = 10 ** 18 Wei
    // 990000000000000000
    receive() external payable {
        uint donationAmount = msg.value * 1 / 100;
        (bool sent, ) = payable(beneficiary).call{value: donationAmount} ("");
        require(sent == true, "Transfer failed");

    }
}