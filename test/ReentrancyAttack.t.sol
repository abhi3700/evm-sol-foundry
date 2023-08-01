// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EtherStore, Attack} from "../src/hacks/ReentrancyAttack.sol";

contract ReentrancyAttackTest is Test {
    EtherStore public etherStore;
    Attack public attackContract;

    address public constant ALICE = address(0xA11CE);
    address public constant BOB = address(0xB0B);
    address public constant EVE = address(0xEFE);

    function setUp() public {
        // console2.log("owner balance before attack: ", address(this).balance / 1e18);
    }

    /// Works with the unsafe contracts
    // function testAttack() public {
    //     // 1. Deploy EtherStore
    //     etherStore = new EtherStore();

    //     // 2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
    //     hoax(ALICE, 1 ether);
    //     etherStore.deposit{value: 1 ether}();
    //     assertEq(address(ALICE).balance, 0);

    //     hoax(BOB, 1 ether);
    //     etherStore.deposit{value: 1 ether}();
    //     assertEq(address(BOB).balance, 0);

    //     // 3. Deploy Attack with address of EtherStore
    //     attackContract = new Attack(address(etherStore));

    //     // 4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
    //     //     You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
    //     //     plus 1 Ether sent from this contract).
    //     hoax(EVE, 1 ether);
    //     attackContract.attack{value: 1 ether}();
    //     assertEq(address(EVE).balance, 0);
    //     assertEq(address(etherStore).balance, 0);
    //     assertEq(address(attackContract).balance, 3 ether);
    // }

    /// Works with the safe contracts
    function testAttackFails() public {
        // 1. Deploy EtherStore
        etherStore = new EtherStore();

        // 2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
        hoax(ALICE, 1 ether);
        etherStore.deposit{value: 1 ether}();
        assertEq(address(ALICE).balance, 0);

        hoax(BOB, 1 ether);
        etherStore.deposit{value: 1 ether}();
        assertEq(address(BOB).balance, 0);

        // 3. Deploy Attack with address of EtherStore
        attackContract = new Attack(address(etherStore));

        // 4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
        //     You will not get 3 Ethers back (2 Ether stolen from Alice and Bob,
        //     plus 1 Ether sent from this contract). Instead the `withdraw` function
        //     would fail on second attempt & hence, the entire `attack` function would roll back although
        //     `deposit` works.
        hoax(EVE, 1 ether);
        vm.expectRevert();
        attackContract.attack{value: 1 ether}();
        console2.log("EVE balance", address(EVE).balance);
        console2.log("etherStore balance", address(etherStore).balance);
        console2.log("attack SC balance", address(attackContract).balance);
        // assertEq(address(EVE).balance, 1 ether);
        // assertEq(address(etherStore).balance, 2 ether);
        // assertEq(address(attackContract).balance, 0);
    }
}
