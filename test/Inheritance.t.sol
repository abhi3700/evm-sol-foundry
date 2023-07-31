// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {A, B, C, D, E} from "../src/Inheritance.sol";

contract InheritanceTest is Test {
    A public a;
    B public b;
    C public c;
    D public d;
    E public e;

    function setUp() public {
        a = new A();
        b = new B();
        c = new C();
        d = new D();
        e = new E();
    }

    function testA() public {
        string memory val = a.foo();
        assertEq(val, "A");
    }

    function testB() public {
        string memory val = b.foo();
        assertEq(val, "B");
    }

    function testC() public {
        string memory val = c.foo();
        assertEq(val, "C");
    }

    function testD() public {
        string memory val = d.foo();
        assertEq(val, "C");
    }

    function testE() public {
        string memory val = e.foo();
        assertEq(val, "B");
    }
}
