// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {BitMath} from "../src/BitMath.sol";

contract FuzzyTest is Test {
    BitMath public bit;

    function setUp() public {
        bit = new BitMath();
    }

    function msb(uint256 x) private pure returns (uint256) {
        uint256 i = 0;

        while ((x >>= 1) > 0) {
            ++i;
        }
        return i;
    }

    function testMSBManual() public {
        assertEq(bit.mostSignificantBit(10), 3); // 1010 => 3
        assertEq(bit.mostSignificantBit(100), 6); // 1100100 => 6
        assertEq(bit.mostSignificantBit(1000), 9); // 1111101000 => 9
    }

    function testMSBFuzzAll(uint256 x) public {
        vm.assume(x > 0);
        assertEq(bit.mostSignificantBit(x), msb(x));
    }

    function testMSBFuzzBound(uint256 x) public {
        x = bound(x, 1, 100);
        assertEq(bit.mostSignificantBit(x), msb(x));
    }
}
