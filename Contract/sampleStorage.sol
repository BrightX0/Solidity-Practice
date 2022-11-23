// SPDX-License-Identifier: GPL 3.0
pragma solidity >= 0.8.17;

contract sampleStorage {
    uint storeData;

    function set (uint x) public {
        storeData = x;
    }

    function get() public view returns (uint) {
        returns storeData;
    }
}