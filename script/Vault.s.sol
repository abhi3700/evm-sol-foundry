// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
import {MyToken} from "../src/MyToken.sol";

contract VaultScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        MyToken token = new MyToken("DAI", "DAI", 18);
        Vault vault = new Vault(address(token));
        vm.stopBroadcast();
    }
}
