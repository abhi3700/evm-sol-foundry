// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Owned} from "solmate/auth/Owned.sol";
import {LibString} from "solmate/utils/LibString.sol";
import {console2} from "forge-std/Test.sol";

contract MyNFT is ERC721, Owned {
    // required for setting during deployment
    string public baseURI;

    event Minted(address indexed caller, address indexed to, uint256 indexed tokenId);
    event Burned(address indexed holder, uint256 indexed tokenId);

    error EmptyBaseURI();
    error NotOwner(address);
    error InvalidToken(uint256); // Invalid Token ID

    /// _uri common base URI for the entire collection set during deployment
    constructor(string memory _n, string memory _s, bytes memory _uri) ERC721(_n, _s) Owned(msg.sender) {
        require(keccak256(_uri) != keccak256(bytes("")), EmptyBaseURI());
        baseURI = string(_uri);
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        ownerOf(id); // it checks for existence/valid token, ensuring there is some owner. Takes gas: 2625 ✅ [RECOMMENDED]
        // require(ownerOf(id) != address(0), "NOT_MINTED"); // alternative approach. Takes gas: 2649 ☑️
        return string(abi.encodePacked(baseURI, LibString.toString(id)));
    }

    /// NOTE: We can also place individual base URI for each token in `mint` function
    /// Or we select individual tokenURI altogether.
    function mint(address to, uint256 id) external onlyOwner {
        _mint(to, id);
        emit Minted(msg.sender, to, id);
    }

    function burn(uint256 id) external {
        require(msg.sender == ownerOf(id), NotOwner(msg.sender));
        _burn(id);

        emit Burned(msg.sender, id);
    }
}
