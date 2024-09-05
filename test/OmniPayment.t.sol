// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {OmniPayment} from "../src/OmniPayment.sol";
import {Usdt} from "../src/Usdt.sol";

contract OmniPaymentTest is Test {
    OmniPayment public omniPayment;
    Usdt public usdt;

    address public admin = makeAddr("admin");
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public charlie = makeAddr("charlie");

    function setUp() public {
        usdt = new Usdt("USDT", "USDT", 6);
        omniPayment = new OmniPayment(address(usdt), admin);

        vm.deal(admin, 100 ether);

        // min 10_000 USDT to alice
        usdt.mint(alice, 10_000 * 10 ** 6);
    }

    function testBatchTransferSuccess() public {
        vm.prank(alice);
        usdt.approve(address(omniPayment), type(uint256).max);

        uint256 amount0 = 50 * 10 ** 6; // 10000 USDT
        uint256 amount1 = 2 * 10 ** 6; // 2 USDT

        vm.prank(admin);
        omniPayment.twoTransferFrom(alice, bob, admin, amount0, amount1);

        assertEq(usdt.balanceOf(bob), amount0);
        assertEq(usdt.balanceOf(admin), amount1);
    }

    // NOTE: This test will fail because the balance is not checked in the contract to save gas.
    // So, from SDK level, make sure the balance is enough & hence this situation won't happen.
    //      Otherwise, it would cost 39313 gas.
    function testFailBatchTransferRevertIfInsufficientBalance() public {
        vm.prank(alice);
        usdt.approve(address(omniPayment), type(uint256).max);

        uint256 amount0 = 10_000 * 10 ** 6; // 10000 USDT
        uint256 amount1 = 2 * 10 ** 6; // 2 USDT

        vm.prank(admin);
        omniPayment.twoTransferFrom(alice, bob, admin, amount0, amount1);
    }

    // TODO: Add test for batchTransferFrom
}
