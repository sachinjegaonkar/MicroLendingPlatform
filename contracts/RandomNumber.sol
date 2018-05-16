pragma solidity ^0.4.22;

contract RandomNumber {

    uint public total_members_allowed;
    uint public installment_amount;
    uint public loan_amount;
    uint public total_fund_collected = 0;
    uint public current_installment_cycle = 0;         // number of installment cycles completed till date
    uint public total_interest_amount_collected = 0;
    uint public members_added_in_network = 0;
    uint public random_number;

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

    constructor(uint _total_members) public {
        total_members_allowed = _total_members;
        installment_amount = 10000;
        loan_amount = installment_amount * total_members_allowed;
    }

    function add_member(address _new_member, uint _aadhaar) public {

        require(_new_member != 0x0, "Invalid borrower address!");
        require(_aadhaar != 0, "Invalid aadhaar number!");
        //require(map_address_to_borrower[msg.sender].borrower_address == 0x0, "Borrower already added into the network!");

        require(members_added_in_network < total_members_allowed, "New member in the network is not allowed");

        map_aadhar_to_address[_aadhaar] = _new_member;
        map_address_to_borrower[_new_member] = borrower({aadhaar: _aadhaar, borrower_address: _new_member, loan_availed: false, bidding_interest_rate: 0, number_of_instalments_paid: 0, interest_amount_gained: 0});
        members_added_in_network += 1;
        // start adding address in array
        addressIndices.push(_new_member);
    }

    function make_monthly_payment(uint _interest_amount) payable public returns(bool success){
        require(msg.value == 10000, "Installment amount is fixed. You should only pay that amount.");
        require(msg.sender != 0x0, "To address is not a valid address to pay to.");
        require(_interest_amount == 200, "Interest amount is fixed. You should only pay that amount.");

        map_address_to_borrower[msg.sender].number_of_instalments_paid += 1;

        // ToDo: ensure the pay installment only be called once per month...
        map_address_to_borrower[msg.sender].interest_amount_gained = 0;
        total_fund_collected += msg.value;
        total_interest_amount_collected += _interest_amount;

        return true;
    }

    function disburse_loan() public {
        require(total_fund_collected == members_added_in_network*installment_amount, "Fund has not yet collected from everyone for this month.");

        current_installment_cycle += 1;

        // pre-deduct the interest amount from the loan amount
        uint userCount = 0;
        for (uint i=0; i<addressIndices.length; i++) {
            if (!map_address_to_borrower[addressIndices[i]].loan_availed)
                userCount++;
        }

        random_number = uint(blockhash(block.number-1))%userCount + 1;

        uint counter = 0;
        for (uint j=0; j<addressIndices.length; j++) {
            if (map_address_to_borrower[addressIndices[j]].loan_availed) {
                continue;
            }
            else {
                counter++;
                if (counter == random_number) {
                    // disburse loan to address with indices j.
                    map_address_to_borrower[addressIndices[j]].borrower_address.transfer(total_fund_collected);
                    map_address_to_borrower[addressIndices[j]].loan_availed = true;
                    redestribute_interest_amount();
                    break;
                }
            }
        }
        random_number = 0;
        total_fund_collected = 0;
    }

    function redestribute_interest_amount() private {
        // The collected interest amount will then be redistributed to the people in the network who has not yet got the chance to take the loan in current cycle.
        uint userCount = 0;
        for (uint i=0; i<addressIndices.length; i++) {
            if (!map_address_to_borrower[addressIndices[i]].loan_availed)
                userCount++;
        }
        if (userCount != 0 && total_interest_amount_collected != 0) {
            total_interest_amount_collected = 0;
            uint interest_share = total_interest_amount_collected / userCount;
            for (uint j=0; j<addressIndices.length; j++) {
                if (!map_address_to_borrower[addressIndices[j]].loan_availed) {
                    addressIndices[j].send(interest_share);
                    map_address_to_borrower[addressIndices[j]].interest_amount_gained = interest_share;
                }
            }
        }
    }
}