// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {A, B} from "../src/Call.sol";

contract CallTest is Test {
    A public contractA;
    B public contractB;

    function setUp() public {
        contractA = new A();
        contractB = new B();
    }

    function testCall() public {
        contractB.scall(contractA.getAddress());
        assertEq(contractA.value(), 20);
        assertEq(contractB.value(), 0);
    }
}
