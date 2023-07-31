// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/**
 * This is a GaslessTokenTransfer Contract that allows this:
 * - sender (without any ETH)
 * - spender (with ETH)
 * - receiver (without any ETH)
 *
 * to get their transfer done.
 *
 * For learning the concept, watch this: https://www.youtube.com/watch?v=rucZrL1nOO8
 *
 * For the code illustration, watch this: https://www.youtube.com/watch?v=jYNnatXRsBs
 *
 * For the foundry test illustration, watch this: https://www.youtube.com/watch?v=YJN7MMllK8M
 *
 * For image, refer the diagram in "evm.drawio" ERCs tab.
 */

import {IERC20Permit} from "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract GaslessTokenTransfer {
    // Alice --wants to trasfer 10 DAI--> Bob
    // Both Alice, Bob doesn't have ETH
    //
    // Now, Charlie --helps transfer 10 DAI--> GaslessTokenTransfer::send()
    // As Charlie has ETH, so participates in helping this. Instead gets
    // fee as reward for doing this
    function send(
        address token,
        address sender,
        // address spender,
        address receiver,
        uint256 amount,
        uint256 fee,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // permit the spender (contract here) to pay the gas
        // NO `approve()` function needed here.
        IERC20Permit(token).permit(sender, address(this), amount + fee, deadline, v, r, s);

        // transfer amount
        IERC20(token).transferFrom(sender, receiver, amount);

        // transfer fee to the caller
        IERC20(token).transferFrom(sender, msg.sender, fee);
    }
}
