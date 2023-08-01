// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Math, A} from "../src/MathLib.sol";

contract MathLibScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        // solhint-disable-next-line
        A contractA = new A();
        vm.stopBroadcast();
    }
}
