// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {AbiEncodings} from "../src/AbiEncodings.sol";

contract AbiEncodingsTest is Test {
    AbiEncodings public abiEncodings;

    function setUp() public {
        abiEncodings = new AbiEncodings();
    }

    function testAbiEncode() public {
        (string memory s1, bytes memory b1) = abiEncodings.encode("Hello ", "Abhi ");
        // assertEq(s1, "Hello Abhi");
        // console2.log("b1: ", b1);
    }

    function testAbiEncodePacked() public {
        (string memory s1, bytes memory b1) = abiEncodings.encodePacked("Hello ", "Abhi ");
        assertEq(s1, "Hello Abhi ");
        // console2.log("b1: ", b1);
    }
}
