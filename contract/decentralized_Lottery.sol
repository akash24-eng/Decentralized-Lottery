// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedLottery {
    address public manager;
    address[] public participants;
    address public recentWinner;

    constructor() {
        manager = msg.sender;
    }

    function enterLottery() public payable {
        require(msg.value == 0.01 ether, "Entry fee is exactly 0.01 ETH");
        participants.push(msg.sender);
    }

    function getParticipants() public view returns (address[] memory) {
        return participants;
    }

    function getLotteryBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getWinner() public view returns (address) {
        return recentWinner;
    }

    function pickWinner() public onlyManager {
        require(participants.length > 0, "No participants to pick from");
        uint index = random() % participants.length;
        recentWinner = participants[index];

        (bool success, ) = payable(recentWinner).call{value: address(this).balance}("");
        require(success, "Transfer failed.");

        delete participants;
    }

    function random() private view returns (uint) {
    return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants)));
}


    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    receive() external payable {
        enterLottery();
    }
}

