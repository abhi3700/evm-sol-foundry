// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Enum} from "../src/Enum.sol";

contract EnumsTest is Test {
    Enum public e;

    function setUp() public {
        e = new Enum();
    }

    /// view `get()` function via `-vvvv` flag
    function testGet() public view {
        e.get(); // 0
    }

    function testSet() public {
        e.set(Enum.Status.Shipped);
        e.get(); // 1
    }

    function testCancel() public {
        e.cancel();
        e.get(); // 4
    }

    function testReset() public {
        e.reset();
        e.get(); // 0
    }
}
