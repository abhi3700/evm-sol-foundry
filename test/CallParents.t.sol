// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {A, B} from "../src/CallParents.sol";

contract CallParentsTest is Test {
    A public a;
    B public b;
    // C public c;
    // D public d;
    // E public e;

    event Log(string);

    function setUp() public {
        a = new A();
        b = new B();
        // c = new C();
        // d = new D();
        // e = new E();
    }

    function testAFoo() public {
        vm.expectEmit(false, false, false, true);
        emit Log("A foo emitted");
        a.foo();
    }

    function testABar() public {
        vm.expectEmit(false, false, false, true);
        emit Log("A bar emitted");
        a.bar();
    }

    function testBFoo() public {
        vm.expectEmit(false, false, false, true);
        emit Log("B foo emitted");
        vm.expectEmit(false, false, false, true);
        emit Log("A foo emitted");
        b.foo();
    }

    function testBBar() public {
        vm.expectEmit(false, false, false, true);
        emit Log("B bar emitted");
        vm.expectEmit(false, false, false, true);
        emit Log("A bar emitted");
        b.bar();
    }
}
