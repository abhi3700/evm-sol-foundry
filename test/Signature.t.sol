// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

contract SignatureTest is Test {
    function setUp() public {}

    function testSignature() public {
        uint256 privateKey = 123;

        address pubKey = vm.addr(privateKey);

        bytes32 messageHash = keccak256("Secret Message");

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);

        address signer = ecrecover(messageHash, v, r, s);

        assertEq(signer, pubKey);
    }

    function testInvalidSignature() public {
        uint256 privateKey = 123;

        address pubKey = vm.addr(privateKey);

        bytes32 messageHash = keccak256("Secret Message");

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);

        bytes32 invalidMessageHash = keccak256("Secret Message");

        address signer = ecrecover(invalidMessageHash, v, r, s);
        assertEq(signer != pubKey, false);
    }
}
