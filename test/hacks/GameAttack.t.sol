// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EtherGame, Attack} from "../../src/hacks/ETHGame.sol";

/**
 * SOURCE: https://solidity-by-example.org/hacks/self-destruct/
 *
 * In this example, the `testAttack()` function is able to
 * make the contract with no winner.
 *
 * So, it seems all the money remains with ETHGame.sol unless the winner calls
 * `claimReward`
 *
 * LESSON: Don't rely on `address(this).balance`, rather `msg.value` inside a SC function.
 */
contract GameAttack is Test {
    EtherGame public etherGame;
    Attack public attackContract;

    address public constant ALICE = address(0xA11CE);
    address public constant BOB = address(0xB0B);
    address public constant EVE = address(0xEFE);

    function setUp() public {}

    /// Unsafe SC
    function testAttack() public {
        // 1. deploy EtherGame SC
        etherGame = new EtherGame();

        // 2. Alice, Bob deposit 1 ether each.
        hoax(ALICE, 1 ether);
        etherGame.deposit{value: 1 ether}();
        assertEq(address(ALICE).balance, 0);

        hoax(BOB, 1 ether);
        etherGame.deposit{value: 1 ether}();
        assertEq(address(BOB).balance, 0);

        // 3. deploy Attack SC
        attackContract = new Attack(etherGame);

        // 4. call attack() function by EVE
        hoax(EVE, 5 ether);
        attackContract.attack{value: 5 ether}();
        assertEq(etherGame.winner(), address(0)); // the winner is 0
        console2.log("EVE balance: ", address(EVE).balance);
        console2.log("EtherGame SC balance: ", address(etherGame).balance);
        console2.log("Attack SC balance: ", address(attackContract).balance);

        // console2.log("Winner: ", etherGame.winner());
    }

    /// Safe SC
    function testAttackFails() public {
        // 1. deploy EtherGame SC
        etherGame = new EtherGame();

        // 2. Alice, Bob deposit 1 ether each.
        hoax(ALICE, 1 ether);
        etherGame.deposit{value: 1 ether}();
        assertEq(address(ALICE).balance, 0);

        hoax(BOB, 1 ether);
        etherGame.deposit{value: 1 ether}();
        assertEq(address(BOB).balance, 0);

        // 3. deploy Attack SC
        attackContract = new Attack(etherGame);

        // 4. call deposit() function by EVE
        hoax(EVE, 1 ether);
        etherGame.deposit{value: 1 ether}();
        // attackContract.attack{value: 1 ether}();
        assertEq(etherGame.winner(), EVE); // the winner is EVE now
    }
}
