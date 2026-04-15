// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GPAContract {
    struct Record {
        uint256 totalCredits;
        uint256 gpaTimes100; // e.g., 3.75 -> 375
        uint256 timestamp;
        string memo;
    }

    mapping(address => Record) public lastRecord;

    event GPARecorded(address indexed student, uint256 totalCredits, uint256 gpaTimes100, string memo, uint256 timestamp);

    function recordGPA(uint256 totalCredits, uint256 gpaTimes100, string calldata memo) external {
        require(totalCredits > 0, "totalCredits must be > 0");
        require(gpaTimes100 <= 400, "GPA max 4.00");

        lastRecord[msg.sender] = Record({
            totalCredits: totalCredits,
            gpaTimes100: gpaTimes100,
            timestamp: block.timestamp,
            memo: memo
        });

        emit GPARecorded(msg.sender, totalCredits, gpaTimes100, memo, block.timestamp);
    }
}
