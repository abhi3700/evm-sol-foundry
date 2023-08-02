// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// SOURCE: https://solidity-by-example.org/hacks/self-destruct/
// The goal of this game is to be the 7th player to deposit 1 Ether.
// Players can deposit only 1 Ether at a time.
// Winner will be able to withdraw all Ether.

/*
1. Deploy EtherGame
2. Players (say Alice and Bob) decides to play, deposits 1 Ether each.
2. Deploy Attack with address of EtherGame
3. Call Attack.attack sending 5 ether. This will break the game
   No one can become the winner.

What happened?
Attack forced the balance of EtherGame to equal 7 ether.
Now no one can deposit and the winner cannot be set.
*/

import {console2} from "forge-std/Test.sol";

/// Unsafe SC
// contract EtherGame {
//     uint256 public targetAmount = 7 ether;
//     address public winner;

//     function deposit() public payable {
//         require(msg.value == 1 ether, "You can only send 1 Ether");

//         uint256 balance = address(this).balance;
//         require(balance <= targetAmount, "Game is over");

//         if (balance == targetAmount) {
//             winner = msg.sender;
//             console2.log("winner in deposit: ", msg.sender);
//         }

//     }

//     function claimReward() public {
//         require(msg.sender == winner, "Not winner");

//         console2.log("called by: ", msg.sender);

//         (bool sent,) = msg.sender.call{value: address(this).balance}("");
//         require(sent, "Failed to send Ether");
//     }
// }

/// Safe SC
contract EtherGame {
    uint256 public targetAmount = 3 ether;
    uint256 public balance;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        balance += msg.value;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
            console2.log("winner: ", msg.sender);
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent,) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    EtherGame etherGame;

    constructor(EtherGame _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        // You can simply break the game by sending ether so that
        // the game balance >= 7 ether

        // cast address to payable
        address payable addr = payable(address(etherGame));
        selfdestruct(addr);
        console2.log("ethergame SC address: ", address(etherGame));
    }
}
