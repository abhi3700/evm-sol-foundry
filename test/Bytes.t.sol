// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

contract BytesTest is Test {
    function setUp() public {}

    // Here, the array length is 5, but can have empty element
    function testbytes8ArrEmpty() public {
        bytes8[5] memory x;
        x[0] = bytes8("abcd");
        x[1] = bytes8("");
        x[2] = bytes8("");
        x[3] = bytes8("");

        console2.log("", x.length); // here size would be always as declared i.e. 5 here
    }
}
