// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IERC20 {
    function transfer(address, uint256) external;
}

contract Token {
    function transfer(address, uint256) external {}
}

contract AbiEncode {
    function test(address _contract, bytes calldata data) public {
        (bool ok,) = _contract.call(data);

        if (!ok) {
            revert();
        }
    }

    function encodeWithSignature(address to, uint256 amount) public pure returns (bytes memory) {
        return abi.encodeWithSignature("transfer(address,to)", to, amount);
    }

    function encodeWithSelector(address to, uint256 amount) public pure returns (bytes memory) {
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    function encodeCall(address to, uint256 amount) public pure returns (bytes memory) {
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}
