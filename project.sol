// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CoTeachingReward {
    mapping(address => uint256) public balances; // Store participant token balances
    address public organizer;                   // Contract organizer
    uint256 public totalRewardsDistributed;     // Track total rewards given

    event RewardDistributed(address indexed participant, uint256 amount);
    event TokensWithdrawn(address indexed participant, uint256 amount);

    constructor() {
        organizer = msg.sender; // Set the deployer as the organizer
    }

    // Reward a participant
    function rewardParticipant(address participant, uint256 amount) external {
        require(msg.sender == organizer, "Only the organizer can reward");
        require(participant != address(0), "Invalid participant address");
        require(amount > 0, "Reward amount must be greater than 0");

        balances[participant] += amount;
        totalRewardsDistributed += amount;

        emit RewardDistributed(participant, amount);
    }

    // Check participant balance
    function checkBalance(address participant) external view returns (uint256) {
        return balances[participant];
    }

    // Allow participants to withdraw their rewards
    function withdrawTokens() external {
        uint256 reward = balances[msg.sender];
        require(reward > 0, "No rewards to withdraw");

        balances[msg.sender] = 0; // Reset balance before transferring

        payable(msg.sender).transfer(reward);

        emit TokensWithdrawn(msg.sender, reward);
    }

    // Organizer can fund the contract with Ether for rewards
    function fundRewards() external payable {
        require(msg.value > 0, "Must send Ether to fund rewards");
    }

    // Check the contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
