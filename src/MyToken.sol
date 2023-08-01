// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {ERC20} from "solmate/tokens/ERC20.sol";

// With Gaslesstokentransfer functionality
contract MyToken is ERC20 {
    constructor(string memory n, string memory s, uint8 _decimals) ERC20(n, s, _decimals) {
        _mint(msg.sender, 10_000_000 * 10 ** _decimals);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
