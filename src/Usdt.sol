// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Usdt is ERC20 {
    constructor(string memory n, string memory s, uint8 _decimals) ERC20(n, s) {
        _mint(msg.sender, 10_000_000 * 10 ** _decimals);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
