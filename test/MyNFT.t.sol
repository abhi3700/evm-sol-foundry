// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract MyNFTTest is Test {
    MyNFT public myNFT;

    address public constant alice = address(0x1);

    event Minted(address indexed caller, address indexed to, uint256 indexed tokenId);
    event Burned(address indexed holder, uint256 indexed tokenId);

    function setUp() public {
        myNFT = new MyNFT("Zomato", "ZOM");

        assertEq(myNFT.name(), "Zomato");
        assertEq(myNFT.symbol(), "ZOM");

        // for calling function
        deal(alice, 100);
        assertEq(alice.balance, 100);

        // mint some nfts
        myNFT.mint(alice, 1);
        assertEq(myNFT.ownerOf(1), alice);
    }

    // === mint

    function testRevertMintAlreadyMintedToken() public {
        vm.expectRevert("ALREADY_MINTED");
        myNFT.mint(alice, 1);
    }

    function testRevertMintByNonAdmin() public {
        vm.prank(alice);
        vm.expectRevert("UNAUTHORIZED");
        myNFT.mint(alice, 2);
    }

    function testMintWorks() public {
        vm.expectEmit(true, true, true, true);
        emit Minted(address(this), alice, 2);
        myNFT.mint(alice, 2);
        assertEq(myNFT.ownerOf(2), alice);
    }

    function testMintTwiceSuccessively() public {
        myNFT.mint(alice, 2);
        assertEq(myNFT.ownerOf(2), alice);

        myNFT.mint(alice, 3);
        assertEq(myNFT.ownerOf(3), alice);

        assertEq(myNFT.balanceOf(alice), 3);
    }

    function testMintTwiceSuccessivelyWithTimeGap() public {
        myNFT.mint(alice, 2);
        assertEq(myNFT.ownerOf(2), alice);
        assertEq(block.timestamp, 1);

        // set time to 4
        vm.warp(4);
        assertEq(block.timestamp, 4);
        myNFT.mint(alice, 3);
        assertEq(myNFT.ownerOf(3), alice);

        // forwarded time by 10s from last tstamp
        skip(10);
        myNFT.mint(alice, 4);
        assertEq(myNFT.ownerOf(4), alice);

        assertEq(myNFT.balanceOf(alice), 4);
    }

    // === burn

    /// address who doesn't own the nft token id, can't burn
    function testBurnFailsByNonOwner() public {
        vm.expectRevert(abi.encodeWithSignature("NotOwner(address)", address(this)));
        myNFT.burn(1);
    }

    /// address who owns the nft token id, can only burn
    function testBurnWorks() public {
        vm.expectEmit(true, true, true, true);
        emit Burned(alice, 1);
        vm.prank(alice);
        myNFT.burn(1);
        assertEq(myNFT.balanceOf(alice), 0);
    }
}
