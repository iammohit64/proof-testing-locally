# TaskStaking dApp: Verification & Simulation

This repository contains the smart contract and testing environment for a decentralized task-staking platform. The project focuses on a robust verification flow where an admin can approve or reject task completions, triggering automated ETH payouts. The entire interaction loop is tested and simulated locally using the Foundry framework.

## Core Features

-   **On-Chain Staking:** Users stake ETH when creating a task, which is locked in the smart contract.
-   **Backend-Driven Verification:** The system is designed for an off-chain backend (played by an admin) to call the contract to manage task statuses.
-   **Automated Payout Logic:** The smart contract handles all financial resolutions automatically based on the admin's decision:
    -   **Approval:** 100% of the stake is returned to the user.
    -   **Partial Approval:** A configurable percentage is returned to the user, and the rest is sent to the platform.
    -   **Rejection:** The entire stake is sent to the platform.
-   **Event-Driven Architecture:** The contract emits events (`TaskCompleted`, `TaskFailed`) that a backend can listen to for updating its database and notifying users.

## Technology Stack

-   **Smart Contract:** Solidity `^0.8.19`
-   **Testing & Deployment:** Foundry (Anvil, Forge, Cast)
-   **Backend Simulation:** Node.js + Ethers.js

---

## Local Setup & Installation

### Prerequisites

-   [Foundry](https://getfoundry.sh/)
-   [Node.js](https://nodejs.org/)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <YOUR_REPOSITORY_URL>
    cd task-staking-dapp
    ```

2.  **Install Node.js dependencies:**
    ```bash
    npm install
    ```

---

## Running the Simulation

This process requires three separate terminal windows to simulate the blockchain, the backend listener, and user/admin actions.

### 1. Terminal 1: Start the Local Blockchain

Start Anvil, the local testnet node. This will also provide a list of funded accounts and their private keys.

```bash
anvil
```

### Terminal 2: Deploy the Smart Contract

Use the deployment script to compile and deploy the TaskStaking contract to your local Anvil node.

```bash
# Replace with the private key for Account 0 from the Anvil output
forge script script/DeployTaskStaking.s.sol:DeployTaskStaking \
    --rpc-url [http://127.0.0.1:8545](http://127.0.0.1:8545) \
    --private-key <YOUR_ANVIL_ACCOUNT_0_PRIVATE_KEY> \
    --broadcast
```


### 3. Terminal 3: Run the Listener & Interact

First, start the backend listener script. It will wait for events from the contract.

```bash
node scripts/listen.js
```

Now, in the same terminal, use cast to send transactions to the contract.

```bash
# Example: Create a task as User (Anvil Account 1)
# Replace <CONTRACT_ADDRESS> with the address from deployment
cast send <CONTRACT_ADDRESS> "createTask(uint256)" $(( $(date +%s) + 86400 )) \
    --rpc-url [http://127.0.0.1:8545](http://127.0.0.1:8545) \
    --private-key <ANVIL_ACCOUNT_1_PRIVATE_KEY> \
    --value 0.1ether

# Example: Approve the task as Admin (Anvil Account 0)
cast send <CONTRACT_ADDRESS> "approveTask(uint256)" 1 \
    --rpc-url [http://127.0.0.1:8545](http://127.0.0.1:8545) \
    --private-key <ANVIL_ACCOUNT_0_PRIVATE_KEY>
```

You will see the TaskCompleted event logged in the listener's output.

### Running Contract Tests

To run the internal logic tests written in Solidity, use Forge:

```bash
forge test -vv
```


