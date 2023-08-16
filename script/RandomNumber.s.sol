// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {RandomNumber} from "../src/RandomNumber.sol";
import {console2} from "forge-std/Test.sol";

contract RandomNumberScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        // for sepalia testnet,
        // - id: 4562
        // - coordinator is deployed at 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625
        // TODO: read from env
        RandomNumber randomNumber = new RandomNumber(4562, 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625);
        console2.log("contract: ", address(randomNumber));
        vm.stopBroadcast();
    }
}
