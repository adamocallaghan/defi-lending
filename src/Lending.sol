// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Lending {
    // === STATE VARIABLES ===
    mapping(address => uint256) public balances;
    mapping(address => uint256) public borrowed;
    uint256 public totalEthInContract;

    // === EVENTS ===
    event UserDepositedEther();
    event UserWithdrewEther();
    event UserHasBorrowedEth();
    event UserHasRepaidLoan();

    // Deposit Function: Implement a deposit function for users to add ETH.
    function deposit() public payable {
        // check deposit amount
        require(msg.value > 0, "No Ether transferred");

        // update balances
        balances[msg.sender] += msg.value;
        totalEthInContract += msg.value;

        // emit event
        emit UserDepositedEther();
    }

    // Withdraw Function: Add a withdraw function for users to retrieve their ETH.
    function withdraw(uint256 amount) public {
        // check withdraw amount
        require(amount > 0, "Specify amount to withdraw");

        // send Ether to user
        payable(msg.sender).transfer(amount);
        // decrement totalEthInContract
        totalEthInContract -= amount;
        // update balances
        balances[msg.sender] -= amount;

        // emit event
        emit UserWithdrewEther();
    }

    // Borrow Function: Create a borrow function for users to take out loans.
    function borrow(uint256 amount) public {
        // check that there's enough Eth available
        require(amount <= totalEthInContract, "You are trying to borrow more Eth than is available");

        // update balances
        borrowed[msg.sender] += amount;
        totalEthInContract -= amount;

        // send Ether to user
        payable(msg.sender).transfer(amount);

        // emit event
        emit UserHasBorrowedEth();
    }

    // Repay Function: Develop a repay function for users to return borrowed ETH.
    function repay() public payable {
        // check repay amount
        require(msg.value > 0, "No Ether sent to repay");

        // check that user has borrowings to repay
        require(borrowed[msg.sender] > 0, "You have not borrowed any Ether");

        // update balances
        borrowed[msg.sender] -= msg.value;
        totalEthInContract += msg.value;

        // emit event
        emit UserHasRepaidLoan();
    }
}
