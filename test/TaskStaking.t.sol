// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {TaskStaking} from "../src/TaskStaking.sol";

contract TaskStakingTest is Test {
    TaskStaking public taskStaking;
    address public owner = address(0x1); // Represents the backend/admin
    address public user = address(0x2); // Represents the task creator
    address public platformWallet = address(0x3);

    // Initial setup runs before each test
    function setUp() public {
        // Start pranking as the owner to deploy the contract
        vm.startPrank(owner);
        taskStaking = new TaskStaking(platformWallet, 0.05 ether);
        vm.stopPrank();

        // Give the user some ETH to create tasks
        vm.deal(user, 10 ether);
    }

    // A helper function to create a task for testing
    function _createTask() internal returns (uint256 taskId) {
        vm.startPrank(user);
        uint256 deadline = block.timestamp + 1 days;
        taskId = taskStaking.createTask{value: 0.1 ether}(deadline);
        vm.stopPrank();
    }

    // === TEST SCENARIOS ===

    // Test Case 1: Admin successfully approves a task
    function test_AdminApprovesTask() public {
        uint256 taskId = _createTask();
        uint256 userInitialBalance = user.balance;

        // 1. Backend/Admin calls submitProof
        vm.startPrank(owner);
        taskStaking.submitProof(taskId);

        // 2. Admin approves the task
        // We expect a TaskCompleted event to be emitted
        vm.expectEmit(true, true, true, true);
        emit TaskStaking.TaskCompleted(taskId, user, 0.1 ether);
        taskStaking.approveTask(taskId);
        vm.stopPrank();

        // 3. Assertions
        assertEq(user.balance, userInitialBalance + 0.1 ether, "User should get full stake back");
        (,,, TaskStaking.TaskStatus status,,) = taskStaking.getTask(taskId);
        assertEq(uint256(status), uint256(TaskStaking.TaskStatus.Completed), "Task status should be Completed");
    }

    // Test Case 2: Admin partially approves (35% refund)
    function test_AdminRejectsTaskPartial() public {
        uint256 taskId = _createTask();
        uint256 userInitialBalance = user.balance;
        uint256 platformInitialBalance = platformWallet.balance;

        uint256 userRefund = (0.1 ether * 35) / 100; // 0.035 ETH
        uint256 platformCut = 0.1 ether - userRefund; // 0.065 ETH

        // 1. Admin submits proof and then rejects with partial refund
        vm.startPrank(owner);
        taskStaking.submitProof(taskId);

        // We expect a TaskFailed event
        vm.expectEmit(true, true, true, true);
        emit TaskStaking.TaskFailed(taskId, user, platformCut);
        taskStaking.rejectTaskPartial(taskId, 35); // 35% refund
        vm.stopPrank();

        // 3. Assertions
        assertEq(user.balance, userInitialBalance + userRefund, "User should get 35% stake back");
        assertEq(platformWallet.balance, platformInitialBalance + platformCut, "Platform should get 65% of stake");
        (,,, TaskStaking.TaskStatus status,,) = taskStaking.getTask(taskId);
        assertEq(uint256(status), uint256(TaskStaking.TaskStatus.Failed), "Task status should be Failed");
    }

    // Test Case 3: Admin fully rejects (0% refund)
    function test_AdminRejectsTaskFull() public {
        uint256 taskId = _createTask();
        uint256 userInitialBalance = user.balance;
        uint256 platformInitialBalance = platformWallet.balance;

        // 1. Admin submits proof and then fully rejects
        vm.startPrank(owner);
        taskStaking.submitProof(taskId);

        // We expect a TaskFailed event
        vm.expectEmit(true, true, true, true);
        emit TaskStaking.TaskFailed(taskId, user, 0.1 ether);
        taskStaking.rejectTaskFull(taskId);
        vm.stopPrank();

        // 3. Assertions
        assertEq(user.balance, userInitialBalance, "User should get no refund");
        assertEq(platformWallet.balance, platformInitialBalance + 0.1 ether, "Platform should get full stake");
        (,,, TaskStaking.TaskStatus status,,) = taskStaking.getTask(taskId);
        assertEq(uint256(status), uint256(TaskStaking.TaskStatus.Failed), "Task status should be Failed");
    }
}
