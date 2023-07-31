// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract A {
    uint256 public value;

    function setNum(uint256 _v) external {
        value = _v;
    }

    function getAddress() public view returns (address) {
        return address(this);
    }
}

contract B {
    uint256 public value;

    function dcall(address sc) external {
        (bool success, bytes memory data) = sc.delegatecall(abi.encodeWithSignature("setNum(uint256)", 20));
    }
}
