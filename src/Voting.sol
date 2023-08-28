// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Voting {
    // voter => candidate
    mapping(address => address) public voters;

    // candidate => votes
    // NOTE: If more than 1 candidate has max. vote, then the preset winner is declared as the winner.
    // Suppose, out of alice, bob, charlie candidates, alice if is the current winner and bob also has same votes, then
    // the `alice` remains as the winner.
    mapping(address => uint256) public candidateVotes;

    // winner
    address private winningCandidate;

    /// Events
    event Voted(address indexed voter, address indexed candidate);

    error AlreadyVoted();
    error SelfVotingNotAllowed();

    /// @dev Anyone can vote for a candidate only once.
    function vote(address candidate) external {
        // check if voter already voted
        if (voters[msg.sender] != address(0)) {
            revert AlreadyVoted();
        }

        // No self-voting
        if (candidate == msg.sender) {
            revert SelfVotingNotAllowed();
        }

        voters[msg.sender] = candidate;
        ++candidateVotes[candidate];

        // get the winning candidate
        address _winner = winningCandidate;
        // get the votes of winning candidate
        uint256 _winnerVotes = candidateVotes[_winner];
        // get the votes of candidate voted for here
        uint256 _candidateVotes = candidateVotes[candidate];

        // set the winning candidate
        if (_winner == address(0)) {
            // if winner not set already
            winningCandidate = candidate;
        } else {
            if (_winner != candidate && _winnerVotes < _candidateVotes) {
                winningCandidate = candidate;
            }
        }

        // emit the event
        emit Voted(msg.sender, candidate);
    }

    function declareWinner() public view returns (address) {
        return winningCandidate;
    }
}
