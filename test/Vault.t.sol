// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";
import {Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    MyToken public token;
    Vault public vault;

    address public constant USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
    address public constant ZERO_ADDR = address(0x00);

    address public constant ALICE = address(0xA111CE);
    address public constant BOB = address(0xB0B);

    address public eoa;

    function setUp() public {
        token = new MyToken("DAI", "DAI", 18);
        vault = new Vault(token, "Vault token", "VAULT");

        // mint some DAI tokens
        token.mint(ALICE, 100);
        token.mint(BOB, 100);

        eoa = vm.addr(123);
    }

    function testSetTokenFailByNonOwner() public {
        vm.prank(ALICE);
        vm.expectRevert(bytes("UNAUTHORIZED"));
        vault.setToken(USDC);
    }

    function testSetTokenFailWhenZeroAddress() public {
        vm.expectRevert(abi.encodeWithSignature("InvalidTokenAddress(address)", ZERO_ADDR));
        vault.setToken(ZERO_ADDR);
    }

    function testSetTokenFailWhenEOAAddress() public {
        vm.expectRevert(abi.encodeWithSignature("InvalidTokenAddress(address)", eoa));
        vault.setToken(eoa);
    }

    // function testSetTokenPass() public {
    //     vault.setToken(USDC);
    // }

    function testDepositFailsWoApproval() public {
        vm.prank(ALICE);
        vm.expectRevert();
        vault.deposit(address(token), 10);
    }

    function testDepositFailsWZeroAmt() public {
        vm.prank(ALICE);
        vm.expectRevert(Vault.ZeroDepositAmount.selector);
        vault.deposit(address(token), 0);
    }

    function testDepositFailsWInsufficientAmt() public {
        vm.prank(ALICE);
        vm.expectRevert(abi.encodeWithSignature("InsufficientDepositAmount(uint256)", 101));
        vault.deposit(address(token), 101);
    }

    function testDeposit() public {
        vm.startPrank(ALICE);
        token.approve(address(vault), 10);
        uint256 shares = vault.deposit(address(token), 10);
        vm.stopPrank();
        assertEq(token.balanceOf(ALICE), 90);
        assertEq(token.balanceOf(address(vault)), 10);
        assertEq(vault.balanceOf(ALICE), shares);
    }

    function testWithdraw() public {
        vm.startPrank(ALICE);
        token.approve(address(vault), 10);
        uint256 shares = vault.deposit(address(token), 10);

        uint256 amount = vault.withdraw(shares);
        assertEq(amount, 10, "withdrawal amount mismatch");

        vm.stopPrank();
    }

    function testWithdrawWLessShares() public {
        vm.startPrank(ALICE);
        token.approve(address(vault), 10);
        uint256 shares = vault.deposit(address(token), 10);

        uint256 amount = vault.withdraw(shares - 1);
        assertEq(amount, 9, "withdrawal amount mismatch");

        vm.stopPrank();
    }

    function testAliceWithdrawWLessSharesWhen2Deposited() public {
        vm.startPrank(ALICE);
        token.approve(address(vault), 10);
        uint256 sharesAfterAliceDeposited = vault.deposit(address(token), 10);
        vm.stopPrank();

        vm.startPrank(BOB);
        token.approve(address(vault), 20);
        uint256 sharesAfterBobDeposited = vault.deposit(address(token), 20);
        vm.stopPrank();

        vm.prank(ALICE);
        uint256 amountAliceWithdrawAfter2Deposited = vault.withdraw(sharesAfterAliceDeposited - 1);
        assertEq(amountAliceWithdrawAfter2Deposited, 9, "withdrawal amount mismatch");

        vm.prank(BOB);
        uint256 amountBobWithdrawAfter2Deposited = vault.withdraw(sharesAfterBobDeposited - 1);
        assertEq(amountBobWithdrawAfter2Deposited, 19, "withdrawal amount mismatch");

        // assert that the vault has remaining 1 (ALICE) + 1 (BOB) DAI
        assertEq(vault.totalDepositBalances(), 2);

        assertEq(vault.totalSupply(), 2);
    }
}
