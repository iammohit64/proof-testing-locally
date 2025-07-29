// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {TaskStaking} from "../src/TaskStaking.sol";

contract DeployTaskStaking is Script {
    function run() external returns (address) {
        // These are the constructor arguments for your contract
        address platformWallet = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // Anvil account 1
        uint256 minimumStake = 0.05 ether; // 50000000000000000 wei

        // Start broadcasting the transaction
        vm.startBroadcast();

        // Deploy the contract
        TaskStaking taskStaking = new TaskStaking(platformWallet, minimumStake);

        // Stop broadcasting
        vm.stopBroadcast();

        console.log(" TaskStaking contract deployed to:", address(taskStaking));

        return address(taskStaking);
    }
}
