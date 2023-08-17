// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract MyNFTTest is Test {
    MyNFT public myNFT;

    address public constant ALICE = address(0x1);

    event Minted(address indexed caller, address indexed to, uint256 indexed tokenId);
    event Burned(address indexed holder, uint256 indexed tokenId);

    function setUp() public {
        myNFT = new MyNFT("Zomato", "ZOM");

        assertEq(myNFT.name(), "Zomato");
        assertEq(myNFT.symbol(), "ZOM");

        // for calling function
        deal(ALICE, 100);
        assertEq(ALICE.balance, 100);

        // mint some nfts
        myNFT.mint(ALICE, 1);
        assertEq(myNFT.ownerOf(1), ALICE);
    }

    // === tokenURI
    function testRevertTokenURIInvalidToken() public {
        vm.expectRevert("NOT_MINTED");
        myNFT.tokenURI(2);
    }

    function testTokenURIWorks() public {
        assertEq(myNFT.tokenURI(1), "https://awscloud/1");
    }

    // === mint

    function testRevertMintAlreadyMintedToken() public {
        vm.expectRevert("ALREADY_MINTED");
        myNFT.mint(ALICE, 1);
    }

    function testRevertMintByNonAdmin() public {
        vm.prank(ALICE);
        vm.expectRevert("UNAUTHORIZED");
        myNFT.mint(ALICE, 2);
    }

    function testMintWorks() public {
        vm.expectEmit(true, true, true, true);
        emit Minted(address(this), ALICE, 2);
        myNFT.mint(ALICE, 2);
        assertEq(myNFT.ownerOf(2), ALICE);
    }

    function testMintTwiceSuccessively() public {
        myNFT.mint(ALICE, 2);
        assertEq(myNFT.ownerOf(2), ALICE);

        myNFT.mint(ALICE, 3);
        assertEq(myNFT.ownerOf(3), ALICE);

        assertEq(myNFT.balanceOf(ALICE), 3);
    }

    function testMintTwiceSuccessivelyWithTimeGap() public {
        myNFT.mint(ALICE, 2);
        assertEq(myNFT.ownerOf(2), ALICE);
        assertEq(block.timestamp, 1);

        // set time to 4
        vm.warp(4);
        assertEq(block.timestamp, 4);
        myNFT.mint(ALICE, 3);
        assertEq(myNFT.ownerOf(3), ALICE);

        // forwarded time by 10s from last tstamp
        skip(10);
        myNFT.mint(ALICE, 4);
        assertEq(myNFT.ownerOf(4), ALICE);

        assertEq(myNFT.balanceOf(ALICE), 4);
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
        emit Burned(ALICE, 1);
        vm.prank(ALICE);
        myNFT.burn(1);
        assertEq(myNFT.balanceOf(ALICE), 0);
    }
}
