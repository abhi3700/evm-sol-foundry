// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Maths} from "../src/Maths.sol";

contract MathsTest is Test {
    Maths public maths;

    function setUp() public {
        maths = new Maths();
    }

    function testMax() public {
        uint256 m = maths.max(32, 43);
        assertEq(m, 43);
        console2.log(type(uint32).max);
    }
}
