# TaskStaking dApp: Verification & Simulation

This repository contains the smart contract and simulation setup for a decentralized task-staking platform. The system implements a full verification loop where an admin approves or rejects task completions, triggering automatic ETH payouts. All interactions are tested locally using the Foundry framework.

---

## 🧩 Core Features

- **🔒 On-Chain Staking:**  
  Users stake ETH when creating tasks. The funds are locked in the contract until resolution.

- **🧾 Admin Verification Flow:**  
  An off-chain backend (admin) calls the smart contract to approve, partially approve, or reject task completions.

- **💸 Automated Payout Logic:**
  - ✅ **Approved:** 100% of the stake is refunded to the user.
  - 🟡 **Partially Approved:** A configurable portion goes to the user; the rest to the platform.
  - ❌ **Rejected:** The full stake is transferred to the platform.

- **📡 Event Emission:**  
  Emits `TaskCompleted` and `TaskFailed` events for backend monitoring and notifications.

---

## 🛠️ Technology Stack

- **Smart Contract:** Solidity `^0.8.19`
- **Testing & Deployment:** Foundry (Anvil, Forge, Cast)
- **Backend Simulation:** Node.js + Ethers.js

---

## 🧪 Local Setup & Installation

### Prerequisites

- [Foundry](https://getfoundry.sh/)
- [Node.js](https://nodejs.org/)

---

### Installation

```bash
git clone <YOUR_REPOSITORY_URL>
cd task-staking-dapp
npm install

## 🚀 Running the Simulation (3-Terminal Setup)

You'll need three terminals for a full local simulation: blockchain node, contract deployment, and backend interaction.

---

### 🖥️ Terminal 1: Start Anvil (Local Blockchain)

```bash
anvil
