// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract AbiDecode {
    struct MyStruct {
        string name;
        uint256[2] nums;
    }

    function encode(uint256 x, address addr, uint256[] calldata arr, MyStruct calldata mystruct)
        public
        pure
        returns (bytes memory)
    {
        return abi.encode(x, addr, arr, mystruct);
    }

    function decode(bytes calldata data)
        public
        pure
        returns (uint256 x, address addr, uint256[] memory arr, MyStruct memory mystruct)
    {
        (x, addr, arr, mystruct) = abi.decode(data, (uint256, address, uint256[], MyStruct));
    }
}
