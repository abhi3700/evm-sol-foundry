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

    function compute(uint256 _v) public pure returns (uint256) {
        // put some big maths function here.
        return _v * 2;
    }
}

contract B {
    uint256 public value;

    /// Errors
    error DelegateCallFailed();

    /// @dev delegatecall to setNum() in contract A on behalf of some caller.
    function dcall(address sc) external {
        (bool success, bytes memory data) = sc.delegatecall(abi.encodeWithSignature("setNum(uint256)", 20));
    }

    /// @dev shifted the code logic to another contract to prevent Contract-B from touching code-size limit.
    function double(address sc, uint256 num) external returns (uint256) {
        (bool success, bytes memory data) = sc.delegatecall(abi.encodeWithSignature("compute(uint256)", num));
        if (!success) revert DelegateCallFailed();
        uint256 result = abi.decode(data, (uint256));
        value = result;
        return value;
    }
}
