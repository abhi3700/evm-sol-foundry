// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {A, B} from "../src/DelegateCall.sol";

contract DelegateCallTest is Test {
    A public contractA;
    B public contractB;

    function setUp() public {
        contractA = new A();
        contractB = new B();
    }

    function testDelegateCall() public {
        contractB.dcall(contractA.getAddress());
        assertEq(contractA.value(), 0);
        assertEq(contractB.value(), 20);
    }
}
