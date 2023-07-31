// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// import {console2} from "forge-std/Test.sol";

contract Payable {
    address payable public immutable owner;

    error ZeroETHBalance();
    error TransferOnlyToOwnerFailed();
    error TransferOnlyToNonOwnerFailed();
    error InvalidCaller(address);

    event Withdraw(address, uint256);

    constructor() payable {
        owner = payable(msg.sender);
    }

    function deposit() external payable {}

    function withdraw() external {
        if (msg.sender != owner) {
            revert InvalidCaller(msg.sender);
        }

        uint256 _amount = address(this).balance;
        // console2.log("amount: ", _amount);

        if (_amount == 0) {
            revert ZeroETHBalance();
        }

        // transfer to owner
        (bool success,) = owner.call{value: _amount}("");

        if (!success) {
            revert TransferOnlyToOwnerFailed();
        }

        emit Withdraw(msg.sender, _amount);
    }

    function transfer() external {
        uint256 _amount = address(this).balance;
        (bool success,) = payable(msg.sender).call{value: _amount}("");

        if (!success) {
            revert TransferOnlyToNonOwnerFailed();
        }
    }
}
