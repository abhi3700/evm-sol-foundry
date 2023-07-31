// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract A {
    event Log(string);

    function foo() public virtual {
        emit Log("A foo emitted");
    }

    function bar() public virtual {
        emit Log("A bar emitted");
    }
}

contract B is A {
    function foo() public virtual override {
        emit Log("B foo emitted");
        A.foo();
    }

    function bar() public virtual override {
        emit Log("B bar emitted");
        super.bar();
    }
}
