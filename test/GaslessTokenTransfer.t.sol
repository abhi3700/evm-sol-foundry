// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {MyToken} from "../src/MyToken.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC20Permit} from "openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {GaslessTokenTransfer} from "../src/GaslessTokenTransfer.sol";

contract GaslessTokenTransferTest is Test {
    // define a token
    MyToken private token;

    // attach a gaslesstoken transfer functionality
    GaslessTokenTransfer private gasless;

    address public sender;
    address public receiver;
    address public spenderCharlie;

    uint256 public constant AMOUNT = 1000;
    // TODO: There is a scope of building a platform which can suggest the FEE to be as close to
    // network fee. And if possible, we can attach an additional incentive to prioritize the task.
    // So, in total FEE = network_fee + priority_fee
    uint256 public constant FEE = 10;

    uint256 public constant SENDER_PRIVATE_KEY = 123;

    function setUp() public {
        // deploy the contracts
        token = new MyToken("DAI", "DAI", 18);
        gasless = new GaslessTokenTransfer();

        // Here, both sender and receiver don't have ETH so as to ensure this transfer.
        sender = vm.addr(SENDER_PRIVATE_KEY);
        assertEq(address(sender).balance, 0);
        receiver = address(456);
        assertEq(address(receiver).balance, 0);

        spenderCharlie = address(789);
        deal(spenderCharlie, 100);
        assertEq(address(spenderCharlie).balance, 100);

        // DAI token minter & minting
        assertEq(IERC20(address(token)).balanceOf(address(this)), 10_000_000 * 1e18); // 10 M minted to minter
        IERC20(address(token)).transfer(sender, AMOUNT + FEE);
        assertEq(IERC20(address(token)).balanceOf(sender), AMOUNT + FEE);
    }

    function testGasless() public {
        uint256 deadline = block.timestamp + 60; // now + 60s

        bytes32 permitmessageHash = gasless.getPermitHash(
            token.DOMAIN_SEPARATOR(), sender, address(gasless), AMOUNT + FEE, token.nonces(sender), deadline
        );
        // Alice signs the message with her private key
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(SENDER_PRIVATE_KEY, permitmessageHash);

        // Charlie pays the gas fee for the message
        vm.prank(spenderCharlie);
        gasless.send(address(token), sender, receiver, AMOUNT, FEE, deadline, v, r, s);

        // assert the token balance of sender resets to zero as the sender was funded by AMOUNT + FEE.
        assertEq(IERC20(address(token)).balanceOf(sender), 0);

        // assert the token balance of receiver increased by AMOUNT
        assertEq(IERC20(address(token)).balanceOf(receiver), AMOUNT);

        // assert the token balance of spender increased by FEE
        assertEq(IERC20(address(token)).balanceOf(spenderCharlie), FEE);
        console2.log("charlie DAI balance", IERC20(address(token)).balanceOf(spenderCharlie));

        assertEq(token.nonces(sender), 1);
    }
}
