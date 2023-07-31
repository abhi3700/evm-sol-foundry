// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Payable} from "../src/Payable.sol";

contract PayableTest is Test {
    Payable public p;

    address public owner;
    address public alice;
    address public bob;
    address public charlie;

    event Withdraw(address, uint256);

    function setUp() public {
        p = new Payable();
        owner = address(this);
        assertEq(owner, p.owner());
        alice = address(123);
        bob = address(124);
        charlie = address(125);

        // give some ethers
        // console2.log(address(owner).balance /*  / 1e18 */ ); // owner's balance in ethers
        deal(alice, 100);
        assertEq(address(alice).balance, 100);
        // console2.log(address(owner).balance /*  / 1e18 */ ); // owner's balance in ethers
    }

    function testDepositFails() public {
        vm.prank(bob);
        assert(address(bob).balance == 0); // bob doesn't have any ETH balance
        p.deposit();
    }

    function testDeposit() public {
        hoax(alice, 100); // it sets (not adds) the balance & the caller.
        p.deposit{value: 20}();
        assertEq(address(p).balance, 20);
        assertEq(address(alice).balance, 80); // hence, the remaining balance is 80, not 180.
    }

    receive() external payable {}

    function testWithdrawFailsWhenCalledByNonOwner() public {
        vm.startPrank(alice);
        p.deposit{value: 20}();

        vm.expectRevert(abi.encodeWithSignature("InvalidCaller(address)", alice));
        p.withdraw();
        vm.stopPrank();
    }

    function testWithdrawFailsWhenZeroETHBalance() public {
        vm.expectRevert(Payable.ZeroETHBalance.selector);
        p.withdraw();
    }

    function testWithdraw() public {
        vm.prank(alice);
        p.deposit{value: 20}();
        // assertEq(address(p).balance, 20);
        // assertEq(address(alice).balance, 80);

        uint256 ownerBalancePre = address(owner).balance;
        vm.expectEmit(false, false, false, true);
        emit Withdraw(owner, 20);
        vm.prank(owner);
        p.withdraw();
        assertEq(address(p).balance, 0);
        uint256 ownerBalancePost = address(owner).balance;

        assertEq(ownerBalancePost - ownerBalancePre, 20);
    }
}
