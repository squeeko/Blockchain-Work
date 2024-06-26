// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MyContractTimelock {
    uint public unlockTime; // timestamp since jan 1st 1970
    address public owner;

    constructor(uint _unlockOffset) payable {
        unlockTime = block.timestamp + _unlockOffset;
        owner = msg.sender; // Contract Address - 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    }

    function withdraw() external {
            require(block.timestamp >= unlockTime, "Funds are locked");
            require(msg.sender == owner, "Only owner can withdraw");
            (bool sent, ) = payable(owner).call{value: address(this).balance}("");
            require(sent == true, "Transfer failed");

        }
}