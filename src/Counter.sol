// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }
}

// defining the interface

interface ICounter {
    function number() external view returns (uint256);
    function setNumber(uint256 newNumber) external;
    function increment() external;
}
