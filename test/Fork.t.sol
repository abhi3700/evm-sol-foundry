// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

interface IWETH {
    function deposit() external payable;
    function balanceOf(address) external view returns (uint256);
}

contract ForkTest is Test {
    IWETH public weth;

    function setUp() public {
        weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testDeposit() public {
        uint256 balanceBefore = weth.balanceOf(address(this));
        console2.log("Balance before: ", balanceBefore);

        weth.deposit{value: 100}();

        uint256 balanceAfter = weth.balanceOf(address(this));
        console2.log("Balance after: ", balanceAfter);
    }
}
