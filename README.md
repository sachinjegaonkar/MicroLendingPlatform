# MicroLendingPlatform

⚙️ Decentralized, Democratized, Transparent Micro-Lending platform based on Block chain

Problem Statement
==================

The problem statement was a part of [TECHGIG's coding contest - Code Gladiators 2018](https://www.techgig.com/codegladiators) held from 20th March to 15th May. The problem statement as below was for Blockchain technology.

Develop a truly Decentralized, Democratized, Transparent Micro-Lending platform based on Block chain. This platform would have to do the following:

1. Free market decision of interest rates which increases competition amongst lenders.
2. All Transactions should be visible transparently to everyone.
3. No middleman should be required just the borrower and lender.
4. Anyone having access to this platform should be able to borrow from remotest of village.
5. Platform should not provide limits on finance and duration of finance.
6. Based on past transactions it should build the reputations of borrowers and visible to lenders.

Abstract
==================

Let us think about financial inclusion and digital inclusion and to provide financial lending services to people from low income groups who may be dire need of financial support for their livelihood. A typical example is that of a short-term repeat borrower in a city such as a trader who borrows money from a lender, buys vegetables from one or more farmers in the morning, sells the vegetables for a higher margin profit, and then returns the money to the lender at the end of the day. Borrowers could also borrow for longer durations such as a farmer that needs money to buy seeds and fertilizers to grow crops in a village.

Platform Description
=====================

1. The solution built upon Ethereum Smart Contracts
2. This Peer-To-Peer model – no need of any middleman to operate the system
3. Provides the financial lending services to the small group of borrowers
4. Provides ability to use existing networks to help build and verify borrower identities
5. Loans are facilitated through two models - one can be used at a time:
6. Model #1: Open Auction Model
7. Model #2: Random Number Model – With flat interest rate (not more than 2%)
8. Flexibility of choosing suitable model makes this platform unique

Problem Being Solved
=====================

1. Eliminates the lack of Trust and Transparency
2. Eliminates the existence of middleman between borrowers and lenders
3. Decision making freedom resides with borrowers and lenders
4. No mortgage/collaterals required while giving out loans to borrowers
5. Decentralised System
6. Security - The system allows borrowers to conduct deals directly which avoids the risk
7. Provides flexibility of choosing suitable solution model as per need/convenience
8. Enables crowd-sourcing anti-corruption measures

Technology/Tool/Cloud Stack
=====================

* Ethereum smart contracts – Solidity
* Ropsten TestNet
* Truffle framework
* MetaMask
* Remix IDE

Steps to Compile
=====================

* truffle init
* truffle.cmd compile
* truffle.cmd test
* npm install truffle-hdwallet-provider
* truffle.cmd migrate --network ropsten
* Use 'remix-ide' command to test the contracts


Platform Architecture – Open Auction
=====================

The Open Auction Approach - Trust And Transparency

![alt text](https://github.com/sachinjegaonkar/MicroLendingPlatform/blob/master/Platform%20Architecture%20-%20Open%20Auction.jpg)

* This is the process where certain people (e.g. from village) forms a group, we call it as a network.
* Everyone decides a certain amount which is to be paid by everyone in the number of installments which is equal to the member count in the network.
* The installment amount is fixed which is predetermined by the group.
* The group hosts the series of open auction process on each month with a pre-scheduled date. Each group member has to deposit their installments monthly.
* This open auction process continues for the number of consecutive months which is equal to the total number of members minus one (n-1) in the group/network.
* In the auction process, each member can request for the loan from the network.
* If the loan request is from only the single person, then the loan amount is to be disbursed by the system without any interest rate.
* But, if the loan request is from more than one member of the group/network, then the one of them can take the loan by bidding the maximum interest rate amount.
* The loan amount is fixed which is equal to the sum of all individual installments in one complete cycle of this process.
* Once the loan is disbursed, the borrower is not allowed to take the loan again from the network in that cycle.
* The system processes the loan to the winner who has put the bid with the maximum interest rate or to the eligible person who only has requested the loan amount.
* The amount of interest will be pre-deducted from the loan amount itself and it will get equally distributed to each member of the network in that month itself.
* The loan borrowers benefits from plenty of time to make profit from their funded business to arrange any dues and/or the installments to be paid in the complete cycle.
* To avoid the people who are seeking this as an investment opportunity, the interest amount from the further installments(n-x) will not get distributed to the last x members of the network who are yet to take the loan from the system.
* Instead, the interest amount will only get distributed to the remaining members of the group/network. This way, everyone in the network will get benefited equally during the cycle of installments.
* The x factor is pre-determined by network and every member should agree to this decision.
* The new member is allowed to join/leave the group only after completion of the current cycle.

e.g. 
    12 people come to form their own network.
    everyone decides to deposit 10000/- as a monthly installments for 12 months. so, everyone is contributing their own amount equal to 120000/- in one complete cycle.
    everybody is eligible to get 120000/- as a loan from the network once in the complete cycle starting from the first open auction.
    everyone decides 4 as a x factor in the system.
    that means, in the last 4 installment cycles, whatever the interest rate that network earns from the auction process, it will only get distributed to the remaining people in the network those have already taken the loan.
    suppose there are 3 eligible people who are requesting for the loan. then they have to win the loan amount by bidding it with maximum interest rate that they can afford.
    consider a case where one has requested a loan by bidding the maximum interest rate equal to 5%.
    the system will disburse the loan amount (e.g. 120000 - 5% of interest) to the borrower who has won the loan request.
    the system will distribute the earned interest amount from this auction process depending upon the x factor and the number of current installments in the cycle completed.

Platform Architecture – Random Number
=====================

The Random Number Approach - Trust And Transparency

![alt text](https://github.com/sachinjegaonkar/MicroLendingPlatform/blob/master/Platform%20Architecture%20-%20Random%20Number.jpg)

* This approach is similar to the Open Auction Approach but with following differences.
* Instead of requesting for the loan, it gets distributed to one of the random member in the network.
* On every months scheduled date, the system generates the random number out of the number from the number = (total members in the network - # of people got the loan earlier in current cycle).
* Additional to installment amount, everyone has to pay a pre-defined flat interest amount (e.g. 2%) to the network.
* The collected interest amount will then be redistributed to the people in the network who has not yet got the chance to take the loan in current cycle.
* This way, it will benefit to all in the network.
* In case, if the person who has got the change to take the loan, but he/she doesn't want the loan to be taken at that time, he/she can offer the loan to the member in the network who has not yet got the chance to take it.

Advantages
=====================

* Increases competition
* Eliminates collusion risks almost completely
* More secure
* Increases transparency significantly
* Enables crowd-sourcing anti-corruption measures
* Increases trust among all the stakeholders

Disadvantages
=====================

* One can't leave the network in-between
* There is no provision of restructuring the installment amount/period if one wants to join/leave the network in-between.


Demonstration Video/Prototype Demo
=====================


Challenges Faced
=====================

* Deciding the solution model which fits the requirements


Possible Improvements
=====================

* Maintain Borrower’s/Lender’s Identity - e.g. linking Aadhar card to their digital identity
* A simple User Interface is required
* Improve Scalability – Can be scaled by allowing it to reach the greatest number of people around the world
* Extra features can be added e.g. allow one to join/leave the network in-between the cycle
* Provisioning reconstruction of instalment amount/period if one wants to join/leave the network in-between
