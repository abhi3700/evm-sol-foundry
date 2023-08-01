// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/**
 * In this example, the intent was to see if we could directly connect with the library function.
 * But, it seems we can't. [TESTED with `cast` after deployment]
 * Moreover, we have to deploy the library with contract and make it available for the users
 * to use the function. Hence, library is a part of contract.
 *
 * For instance, if we want to use `sqrt()` of a number, we have to rather use `foo()` to do that
 * as we can't interact with the `sqrt()` directly.
 */

library Math {
    function sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
        // else z = 0 (default value)
    }
}

contract A {
    using Math for uint256;

    uint256 public value;

    function foo(uint256 x) public returns (uint256) {
        value = x.sqrt();
        return value;
    }
}
