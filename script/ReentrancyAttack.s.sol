// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EtherStore, Attack} from "../src/hacks/ReentrancyAttack.sol";

contract ReentrancyAttackScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        EtherStore etherStore = new EtherStore();
        console2.log("EtherStore contract: ", address(etherStore));

        Attack attack = new Attack(address(etherStore));
        console2.log("Attack contract: ", address(attack));

        vm.stopBroadcast();
    }
}
