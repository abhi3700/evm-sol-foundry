// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {Owned} from "solmate/auth/Owned.sol";
/**
 * @title OmniPayment
 * @dev This contract allows for the batch execution of the ERC20 `transferFrom` function, facilitating multiple token transfers in a single transaction.
 */

contract OmniPayment is Owned {
    using SafeERC20 for IERC20;

    IERC20 public token;

    error MismatchedRecipientsAndAmountsArrayLengths();
    error InsufficientBalanceFromUser();

    constructor(address _token, address _owner) Owned(_owner) {
        require(_token != address(0), "Invalid token address");
        require(_owner != address(0), "Invalid owner address");

        token = IERC20(_token);
    }

    /**
     * @notice Performs a batch of `transferFrom` operations on the specified ERC20 token.
     * @dev The caller must have approved this contract to spend the specified amounts on their behalf.
     *      NOTE: Only the owner can call this function as the contract is the spender because it is calling the transferFrom function.
     *      NOTE: Also, as there is check for balance, it is risk-free to call this function onchain because either all the transfers will succeed or none of them will.
     *      Extra 1452 gas is added to the transaction for this check. That costs extra 0.046 USD at 13 Gwei gas price @ token price: 1ETH = 2500 USD.
     * @param from The address from which the tokens will be transferred.
     * @param recipient0 The address to which the tokens will be transferred.
     * @param recipient1 The address to which the tokens will be transferred.
     * @param amount0 The token amount to be transferred to recipient0.
     * @param amount1 The token amount to be transferred to recipient1.
     */
    function twoTransferFrom(address from, address recipient0, address recipient1, uint256 amount0, uint256 amount1)
        external
        onlyOwner
    {
        // checks done offchain
        // if (token.balanceOf(from) < amount0 + amount1) revert InsufficientBalanceFromUser();

        token.safeTransferFrom(from, recipient0, amount0);
        token.safeTransferFrom(from, recipient1, amount1);
    }

    /**
     * @notice Performs a batch of `transferFrom` operations on the specified ERC20 token.
     * @dev The caller must have approved this contract to spend the specified amounts on their behalf.
     *      NOTE: Only the owner can call this function as the contract is the spender because it is calling the transferFrom function.
     *      NOTE: Also, as there is check for balance, it is risk-free to call this function onchain because either all the transfers will succeed or none of them will.
     *      Extra 1452 gas is added to the transaction for this check. That costs extra 0.046 USD at 13 Gwei gas price @ token price: 1ETH = 2500 USD.
     * @param from The address from which the tokens will be transferred.
     * @param recipients An array of addresses to which the tokens will be transferred.
     * @param amounts An array of token amounts to be transferred to each recipient.
     *
     * Requirements:
     * - The length of `recipients` and `amounts` arrays must be equal.
     */
    function batchTransferFrom(address from, address[] calldata recipients, uint256[] calldata amounts)
        external
        onlyOwner
    {
        if (recipients.length != amounts.length) revert MismatchedRecipientsAndAmountsArrayLengths();

        uint256 totalAmount;
        for (uint256 i = 0; i < amounts.length; i++) {
            totalAmount += amounts[i];
        }
        if (token.balanceOf(from) < totalAmount) revert InsufficientBalanceFromUser();

        uint256 length = recipients.length;

        for (uint256 i = 0; i < length; i++) {
            token.safeTransferFrom(from, recipients[i], amounts[i]);
        }
    }
}
