// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract MyContractCounter {
    uint public count;

    function increment() external {
        count += 1;
    }

    function decrement() external {
        
        require(count > 0, "Count is already at 0");
        count -= 1;
    }

    function getCount() external view returns(uint) {
        return count;
    }
}