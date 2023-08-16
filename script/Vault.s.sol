// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
import {MyToken} from "../src/MyToken.sol";

/**
 * MyToken Contract on GOERLI testnet: https://goerli.etherscan.io/address/0x1ef5c2a2dc002a999455058929a97ebcd5529379
 * Vault Contract on GOERLI testnet: https://goerli.etherscan.io/address/0x5c911b42114e347058cf300d661346bbdbbb59cd
 */

contract VaultScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        MyToken token = new MyToken("DAI", "DAI", 18);
        Vault vault = new Vault(token, "Vault token", "VAULT");
        console2.log("Vault contract: ", address(vault));
        vm.stopBroadcast();
    }
}
