// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// register an wallet address to a human readable name - https://ens.domains/ Ethereum Name Service
contract MyContractNameRegistry {
    mapping(string => address) public names;
    address public owner;

    constructor()  {
        owner = msg.sender;
    }

    function registerName(string memory _name) external payable {
        require(names[_name] == address(0), "Name is already taken");
        require(msg.value >= 0.1 ether, "Not enough funds");
        (bool sent, ) = payable(owner).call{value: msg.value} ("");
        require(sent == true, "Transfer failed");
        names[_name] = msg.sender;

    }
    function getAddress(string memory _name) external view returns(address) {
        return names[_name];
    }
}
    