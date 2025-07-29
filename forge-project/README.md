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
