// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {console2} from "forge-std/Test.sol";

contract Time {
    uint32 public start_date = uint32(block.timestamp) + 1 days;
    uint32 public end_date = uint32(block.timestamp) + 30 days;

    error InvalidTimeForBid();
    error CannotEnd(uint256);

    function bid() external view {
        if (block.timestamp < start_date || block.timestamp > end_date) {
            revert InvalidTimeForBid();
        }
    }

    function end() external view {
        if (block.timestamp < end_date) {
            revert CannotEnd(block.timestamp);
        }
    }
}
