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
    }
}
