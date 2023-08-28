// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {AbiEncodings} from "../src/AbiEncodings.sol";

contract AbiEncodingsTest is Test {
    AbiEncodings public abiEncodings;

    function setUp() public {
        abiEncodings = new AbiEncodings();
    }

    function testAbiEncode() public view {
        (string memory s1, bytes memory b1) = abiEncodings.encode("Hello ", "Abhi ");
        // assertEq(s1, "Hello Abhi");
        // console2.log("b1: ", b1);
    }

    function testAbiEncodePacked() public view {
        (string memory s1, bytes memory b1) = abiEncodings.encodePacked("Hello ", "Abhi ");
        // assertEq(s1, "Hello Abhi ");
        // console2.log("b1: ", b1);
    }

    function testAbiEncodePacked2() public {
        string memory num = "5";
        string memory x = string(abi.encodePacked("Hello", "Abhi", num));
        assertEq(x, "HelloAbhi5");
    }

    function testAbiEncodePacked3() public {
        string memory color = "#e53238";
        string memory x = string(abi.encodePacked("<svg viewBox=\"0 0 58 58\"", color));
        assertEq(x, "<svg viewBox=\"0 0 58 58\"#e53238");
        console2.logBytes(bytes("nft 1"));
    }
}
