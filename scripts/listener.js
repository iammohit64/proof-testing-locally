const { ethers } = require("ethers");

// 1. Define connection details and contract info
const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545"); // Anvil RPC URL
const contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Default Anvil deployment address

// 2. Get Contract ABI (Application Binary Interface)
// After compiling with `forge build`, Foundry places the ABI here:
const abi = require("../out/TaskStaking.sol/TaskStaking.json").abi;

// 3. Create a contract instance
const contract = new ethers.Contract(contractAddress, abi, provider);

async function main() {
    console.log("🤖 Fake backend listener started...");
    console.log(`Listening for events on contract: ${contractAddress}\n`);

    // Listen for the TaskCompleted event
    contract.on("TaskCompleted", (taskId, creator, returnedAmount, event) => {
        console.log("✅ Event Received: TaskCompleted");
        console.log(`   - Task ID: ${taskId}`);
        console.log(`   - Creator: ${creator}`);
        console.log(`   - Amount Returned: ${ethers.formatEther(returnedAmount)} ETH`);
        console.log("-------------------------------------");
    });

    // Listen for the TaskFailed event
    contract.on("TaskFailed", (taskId, creator, penaltyAmount, event) => {
        console.log("❌ Event Received: TaskFailed");
        console.log(`   - Task ID: ${taskId}`);
        console.log(`   - Creator: ${creator}`);
        console.log(`   - Penalty Amount: ${ethers.formatEther(penaltyAmount)} ETH`);
        console.log("-------------------------------------");
    });
}

main().catch((error) => {
    console.error("Error starting listener:", error);
    process.exit(1);
});