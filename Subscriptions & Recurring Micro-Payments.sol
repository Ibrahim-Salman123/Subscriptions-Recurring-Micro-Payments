// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SubscriptionManager {
    struct Plan {
        address merchant;
        uint256 cost;
        uint256 billingInterval;
    }

    struct Subscription {
        uint256 planId;
        uint256 nextPaymentDate;
    }

    uint256 public planCount;
    mapping(uint256 => Plan) public plans;
    mapping(address => mapping(uint256 => Subscription)) public userSubscriptions;

    event PlanCreated(uint256 indexed planId, address indexed merchant, uint256 cost);
    event Subscribed(address indexed subscriber, uint256 indexed planId);
    event SubscriptionPaid(address indexed subscriber, uint256 indexed planId, uint256 date);

    function createPlan(uint256 _cost, uint256 _interval) external {
        require(_cost > 0 && _interval > 0, "Invalid plan settings");
        planCount++;
        plans[planCount] = Plan({
            merchant: msg.sender,
            cost: _cost,
            billingInterval: _interval
        });
        emit PlanCreated(planCount, msg.sender, _cost);
    }

    function subscribe(uint256 _planId) external payable {
        Plan memory plan = plans[_planId];
        require(plan.merchant != address(0), "Plan not found");
        require(msg.value == plan.cost, "Incorrect payment amount");

        userSubscriptions[msg.sender][_planId] = Subscription({
            planId: _planId,
            nextPaymentDate: block.timestamp + plan.billingInterval
        });

        payable(plan.merchant).transfer(msg.value);
        emit Subscribed(msg.sender, _planId);
    }

    function processRenewal(address _subscriber, uint256 _planId) external payable {
        Subscription storage sub = userSubscriptions[_subscriber][_planId];
        Plan memory plan = plans[_planId];
        
        require(sub.nextPaymentDate > 0, "No active subscription");
        require(block.timestamp >= sub.nextPaymentDate, "Not due for renewal");
        require(msg.value == plan.cost, "Insufficient fee");

        sub.nextPaymentDate += plan.billingInterval;
        payable(plan.merchant).transfer(msg.value);
        emit SubscriptionPaid(_subscriber, _planId, block.timestamp);
    }
}
