// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ICounter, Counter} from "./Counter.sol";

contract MyContract is Counter {
    function incrementCounter(address addr) external {
        ICounter(addr).increment();
    }

    function getCounter(address addr) external view returns (uint256) {
        return ICounter(addr).number();
    }
}
