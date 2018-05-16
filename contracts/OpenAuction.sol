pragma solidity ^0.4.22;

contract OpenAuction {

    uint public total_members_allowed;
    uint public installment_amount;
    uint public loan_amount;
    uint public x_factor;
    uint public total_fund_collected = 0;
    uint public current_installment_cycle = 0;         // number of installment cycles completed till date
    uint public total_interest_amount_collected = 0;
    uint public members_added_in_network = 0;
    bool public cycle_started = false;                // The new member is allowed to join/leave the group only after completion of the current cycle.
    uint public auctionEnd;

    //structure of borrower
    struct borrower {
        uint aadhaar;                       // aadhar id of the borrower
        address borrower_address;           // blockchain identifier of the borrower
        bool loan_availed;                  // eligible to avail the loan if not already availed
        uint bidding_interest_rate;         // with this interest rate, borrower has requested the loan
        uint number_of_instalments_paid;    // installments paid till date
        uint interest_amount_gained;
    }

    // address to borrower map
    mapping (address => borrower) public map_address_to_borrower;
    address[] public addressIndices;

    // aadhar to member's address map
    mapping (uint => address) public map_aadhar_to_address;

    // Current state of the auction.
    address public highestBidder;   // address of the highest bidder
    uint public highestBid;         // highest bid of interest rate

    // Events that will be fired on changes.
    // event HighestBidIncreased(address bidder, uint amount);
    event OnAuctionEnded(address winner, uint amount);

    constructor(uint _total_members) public {
        total_members_allowed = _total_members;
        installment_amount = 10000;
        loan_amount = installment_amount * total_members_allowed;
        x_factor = 3;
    }

    function add_member(address _new_member, uint _aadhaar) public {

        require(_new_member != 0x0, "Invalid borrower address!");
        require(_aadhaar != 0, "Invalid aadhaar number!");
        //require(map_address_to_borrower[msg.sender].borrower_address == 0x0, "Borrower already added into the network!");

        require(members_added_in_network < total_members_allowed, "New member in the network is not allowed");

        // The new member is allowed to join/leave the group only after completion of the current cycle.
        require(cycle_started == false, "New member is not allowed to be added in current running cycle.");

        map_aadhar_to_address[_aadhaar] = _new_member;
        map_address_to_borrower[_new_member] = borrower({aadhaar: _aadhaar, borrower_address: _new_member, loan_availed: false, bidding_interest_rate: 0, number_of_instalments_paid: 0, interest_amount_gained: 0});
        members_added_in_network += 1;
        // start adding address in array
        addressIndices.push(_new_member);
    }

    function start_auction(uint _biddingTime) public {
        require(total_fund_collected == members_added_in_network*installment_amount, "Fund has not yet collected from everyone for this month.");

        cycle_started = true;
        current_installment_cycle += 1;
        auctionEnd = now + _biddingTime;
    }

    function make_monthly_payment() payable public returns(bool success){
        require(msg.value == 10000, "Installment amount is fixed. You should only pay that amount.");
        require(msg.sender != 0x0, "To address is not a valid address to pay to.");
        
        map_address_to_borrower[msg.sender].number_of_instalments_paid += 1;

        // ToDo: ensure the pay installment only be called once per month...
        map_address_to_borrower[msg.sender].interest_amount_gained = 0;
        map_address_to_borrower[msg.sender].bidding_interest_rate = 0;
        total_fund_collected += msg.value;
        
        return true;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function request_loan(uint _bid_rate) public {
        // No arguments are necessary, all
        // information is already part of
        // the transaction. The keyword payable
        // is required for the function to
        // be able to receive Ether.
        // Revert the call if the bidding
        // period is over.
        require(now <= auctionEnd, "Auction already ended.");

        // If the bid is not higher, send the
        // money back.
        require(_bid_rate > highestBid, "There already is a higher bid.");

        require(!map_address_to_borrower[msg.sender].loan_availed, "Loan has already been availed in current cycle.");
        
        highestBidder = msg.sender;
        highestBid = _bid_rate;

        map_address_to_borrower[msg.sender].bidding_interest_rate = _bid_rate;
        //emit HighestBidIncreased(msg.sender, _bid_rate);
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function end_auction() public {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.
        // 1. Conditions
        require(now >= auctionEnd, "Auction not yet ended.");
        require(cycle_started, "auctionEnd has already been called.");
        // 2. Effects
        cycle_started = false;
        emit OnAuctionEnded(highestBidder, highestBid);
        // 3. Interaction
        disburse_loan();
        total_fund_collected = 0;
    }

    function disburse_loan() private {
        // pre-deduct the interest amount from the loan amount
        uint userCount = 0;
        for (uint i=0; i<addressIndices.length; i++) {
            if (!map_address_to_borrower[addressIndices[i]].loan_availed)
                userCount++;
        }

        if (userCount > x_factor) {
            uint interest_amount = (total_fund_collected * highestBid)/100;
            total_interest_amount_collected = interest_amount;
            highestBidder.transfer(total_fund_collected - interest_amount);
            
            map_address_to_borrower[highestBidder].loan_availed = true;
            // reset the bidding_interest_rate of every borrower on every loan disbursement
            
            redestribute_interest_amount();
        }
        else {
            //require(total_fund_collected == members_added_in_network*installment_amount, "Fund has not yet collected from everyone for this month.");
            highestBidder.transfer(total_fund_collected);
            total_fund_collected = 0;
            map_address_to_borrower[highestBidder].loan_availed = true;
        }

        highestBidder = 0x0;
        highestBid = 0;
    }

    function redestribute_interest_amount() private {
        // the interest amount from the further installments(n-x) will not get distributed to the last x members of the network who are yet to take the loan from the system.
        // redestribute the interest amount among the borrowers who has not yet availed the loan
        uint userCount = 0;
        for (uint i=0; i<addressIndices.length; i++) {
            if (!map_address_to_borrower[addressIndices[i]].loan_availed)
                userCount++;
        }
        if (userCount != 0) {
            uint interest_share = total_interest_amount_collected / userCount;
            for (uint j=0; j<addressIndices.length; j++) {
                if (!map_address_to_borrower[addressIndices[j]].loan_availed) {
                    // ToDo: handle redestribution of interest amount to the intended people.
                    addressIndices[j].send(interest_share);
                    map_address_to_borrower[addressIndices[j]].interest_amount_gained = interest_share;
                }
            }
        }
    }
}