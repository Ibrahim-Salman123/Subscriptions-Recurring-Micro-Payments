# SubscriptionManager Smart Contract

A decentralized subscription management system built on Ethereum using Solidity. This contract allows merchants to create subscription plans and users to subscribe and renew services using native Ether.

---

## 📌 Overview

The **SubscriptionManager** smart contract provides a transparent, intermediary-free ecosystem for recurring digital payments. Merchants can define billing costs and time intervals (billing cycles). Users can subscribe to these plans, and renewals can be triggered securely on-chain once the next payment date is reached.

---

## 🛠 Features

* **Merchant Autonomy:** Anyone can become a merchant and register customized business subscription plans.
* **Automated Due Date Tracking:** Calculates precise next payment deadlines dynamically using block timestamps.
* **On-Chain Renewals:** Supports conditional renewal processing to ensure users only pay the predefined plan fee when their cycle is due.
* **Direct Value Routing:** Safely transfers native Ether subscription fees directly to the merchant's wallet instantly.

---

## 📄 Smart Contract Architecture

### Data Structures

#### 1. `Plan` (Struct)
Tracks the configuration of individual subscription offers:
* `merchant`: The wallet address of the service provider who receives the funds.
* `cost`: The required fee (in Wei) for each billing cycle.
* `billingInterval`: The duration of one billing cycle (in seconds).

#### 2. `Subscription` (Struct)
Tracks the status of a specific user's subscription:
* `planId`: The unique ID of the plan the user is tied to.
* `nextPaymentDate`: The exact timestamp indicating when the next payment becomes due.

### State Variables
* `planCount`: A public counter tracking the total number of plans created.
* `plans`: A public mapping linking unique numerical IDs to their respective `Plan` configurations.
* `userSubscriptions`: A nested public tracking mapping (`subscriberAddress => planId => Subscription`) logging active user enrollments.

---

## ⚙️ Core Functions

#### 1. `createPlan(uint256 _cost, uint256 _interval)`
* **Permission:** Public (Anyone can create a plan)
* **Description:** Registers a new subscription plan with a custom recurring cost and interval duration, ensuring both parameters are greater than zero.

#### 2. `subscribe(uint256 _planId)`
* **Permission:** Public (Requires Ether deposit)
* **Description:** Enroll a user into a target plan. It initializes their billing timeline, locks their subscription record, and pushes the initial payment directly to the merchant.

#### 3. `processRenewal(address _subscriber, uint256 _planId)`
* **Permission:** Public (Can be called by anyone with proper Ether funding)
* **Description:** Renews a due subscription. It validates that the subscription is active, verifies that the current timestamp is past the due date, charges the appropriate fee, and extends the `nextPaymentDate` by another interval.

---

## 🔔 Events

* `PlanCreated(uint256 indexed planId, address indexed merchant, uint256 cost)`: Emitted when a new plan is published.
* `Subscribed(address indexed subscriber, uint256 indexed planId)`: Emitted upon a successful initial subscription setup.
* `SubscriptionPaid(address indexed subscriber, uint256 indexed planId, uint256 date)`: Emitted whenever a subscription renewal fee is processed.

---

## 🚀 Tech Stack & Setup

* **Language:** Solidity `^0.8.20`
* **Tools:** Remix IDE / Hardhat / Foundry

### Standard Deploy Instructions

1. Load your workspace in **Remix IDE**.
2. Create a file named `SubscriptionManager.sol` and paste the code.
3. Set the compiler target to `0.8.20` or higher and compile.
4. Execute deployment to your preferred EVM environment.

---

## ⚖️ License

This project is licensed under the **MIT License**.
