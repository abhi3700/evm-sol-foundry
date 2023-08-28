// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test {
    Voting public voting;

    event Voted(address indexed voter, address indexed candidate);

    address public constant voter1 = address(0x01);
    address public constant voter2 = address(0x02);
    address public constant voter3 = address(0x03);
    address public constant voter4 = address(0x04);
    address public constant voter5 = address(0x05);
    address public constant voter6 = address(0x06);

    address public constant candidate1 = 0x52bc44d5378309EE2abF1539BF71dE1b7d7bE3b5;
    address public constant candidate2 = 0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8;
    address public constant candidate3 = 0xe0682Bd49ED05Ad020A4f270379Ef3cAc78284f4;
    address public constant candidate4 = 0xc9610bE2843F1618EdFeDd0860DC43551c727061;

    function setUp() public {
        voting = new Voting();
    }

    function testVoterAbleToVote(address candidate) public {
        vm.assume(voter1 != candidate);

        vm.expectEmit(true, true, false, true);
        emit Voted(voter1, candidate);
        vm.prank(voter1);
        voting.vote(candidate);

        assertEq(voting.candidateVotes(candidate), 1);
        assertEq(voting.voters(voter1), candidate);
        assertEq(voting.declareWinner(), candidate);
    }

    function testWinnerIsChangedDuringRealVoting() public {
        // voter1 votes candidate1
        vm.prank(voter1);
        voting.vote(candidate1);
        assertEq(voting.declareWinner(), candidate1);

        // voter2 votes candidate2
        vm.prank(voter2);
        voting.vote(candidate2);
        assertEq(voting.declareWinner(), candidate1);

        // voter3 votes candidate1
        vm.prank(voter3);
        voting.vote(candidate1);
        assertEq(voting.declareWinner(), candidate1);

        // voter4 votes candidate2
        vm.prank(voter4);
        voting.vote(candidate2);
        assertEq(voting.declareWinner(), candidate1);

        // voter5 votes candidate2
        vm.prank(voter5);
        voting.vote(candidate2);
        assertEq(voting.declareWinner(), candidate2);
    }
}
