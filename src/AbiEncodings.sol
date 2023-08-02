// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

contract AbiEncodings {
    function encode(string memory s1, string memory s2) external pure returns (string memory s3, bytes memory b1) {
        b1 = abi.encode(s1, s2);
        s3 = string(b1);
    }

    function encodePacked(string memory s1, string memory s2)
        external
        pure
        returns (string memory s3, bytes memory b1)
    {
        b1 = abi.encodePacked(s1, s2);
        s3 = string(b1);
    }
}
