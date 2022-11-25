// SPDX-License-Identifier: GPL 3.0
pragma solidity 0.8.17;

contract Balot {
    struct Voter {
        uint256 weight;
        uint256 vote;
        bool voted;
        address delegate;
    }

    struct proposal {
        bytes32 name;
        uint256 voteCount;
    }

    address public chairPerson;

    mapping(address => Voter) public voters;

    proposal[] public proposals;

    constructor(bytes32[] memory proposalName) {
        chairPerson = msg.sender;
        voters[chairPerson].weight = 1;

        for (uint256 i = 0; i < proposalName.length; i++) {
            proposals.push(proposal({name: proposalName[i], voteCount: 0}));
        }

        require(
            msg.sender == chairPerson,
            "Only The ChairPerson has the Right To Vote"
        );
    }

    function givingRightToVote(address voter) external {
        require(
            msg.sender == chairPerson,
            "Only a ChairPerson can give Right to Vote"
        );

        require(!voters[voter].voted, "This Voter Already Voted");

        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function delegate(address to) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            require(to != msg.sender, "Found loop in delegation.");
        }

        Voter storage delegate_ = voters[to];

        require(delegate_.weight >= 1);

        sender.voted = true;
        sender.delegate = to;

        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint256 proposal_v) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal_v;
        proposals[proposal_v].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        for (uint256 p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
