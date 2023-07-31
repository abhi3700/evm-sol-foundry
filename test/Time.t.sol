// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Time} from "../src/Time.sol";

contract TimeTest is Test {
    Time public time;
    uint32 private start_date;

    function setUp() public {
        time = new Time();
        start_date = uint32(block.timestamp);
    }

    function testBidFailsBeforeStartTime() public {
        vm.expectRevert(Time.InvalidTimeForBid.selector);
        time.bid();
    }

    function testBidFailsAfterEndTime() public {
        vm.warp(block.timestamp + 31 days);
        vm.expectRevert(Time.InvalidTimeForBid.selector);
        time.bid();
    }

    function testBid() public {
        vm.warp(block.timestamp + 1 days);
        time.bid();

        skip(30 days);
        rewind(1 days);
        time.bid();
    }

    function testEndFails() public {
        skip(29 days);
        vm.expectRevert(abi.encodeWithSignature("CannotEnd(uint256)", block.timestamp));
        time.end();
    }

    function testEnd() public {
        skip(31 days);
        time.end();
    }
}
