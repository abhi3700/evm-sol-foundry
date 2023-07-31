// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Maths {
    function max(uint256 a, uint256 b) external pure returns (uint256) {
        // in assembly
        // assembly {
        //     switch gt(a, b)
        //     case true {
        //         mstore(0x0, a)
        //         return(0x0, 32)
        //     }
        //     case false {
        //         mstore(0x0, b)
        //         return(0x0, 32)
        //     }
        // }

        // in solidity

        if (a > b) {
            return a;
        } else {
            return b;
        }
    }
}
