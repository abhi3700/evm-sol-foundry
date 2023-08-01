// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EtherStore, Attack} from "../src/hacks/ReentrancyAttack.sol";

contract ReentrancyAttackScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        EtherStore etherStore = new EtherStore();

        Attack attack = new Attack(address(etherStore));

        vm.stopBroadcast();
    }
}
