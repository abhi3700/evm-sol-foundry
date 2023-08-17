// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {console2} from "forge-std/Test.sol";

contract MyNFT is ERC721, Owned {
    event Minted(address indexed caller, address indexed to, uint256 indexed tokenId);
    event Burned(address indexed holder, uint256 indexed tokenId);

    error NotOwner(address);

    constructor(string memory _n, string memory _s) ERC721(_n, _s) Owned(msg.sender) {}

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        // return "";
    }

    function mint(address to, uint256 id) external onlyOwner {
        _mint(to, id);
        emit Minted(msg.sender, to, id);
    }

    function burn(uint256 id) external {
        if (msg.sender != ownerOf(id)) {
            revert NotOwner(msg.sender);
        }
        _burn(id);

        emit Burned(msg.sender, id);
    }
}
