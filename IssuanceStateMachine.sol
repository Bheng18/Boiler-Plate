pragma solidity ^0.4.24;
contract IssuanceStateMachine {
    
    address owner;
    //State Machine (Stages)
    enum Stages { Buy, Issues, Gets }
    Stages stage = Stages.Buy;
    
    mapping (address => string) applicant;
    mapping (address => uint256) balance;
    constructor () public payable {
        owner = msg.sender;
    }
    modifier onlyIssuer(){
      assert(owner == msg.sender);
      _;
    }
    function buyIssuanceRight() payable public {
        require (stage == Stages.Buy && msg.value == 1 ether); //Requires the user to input 1 Eth in the Value field while also reading which stage it's in
        balance[msg.sender] = msg.value; //Balance held here
        stage = Stages.Issues; //Sets the next stage to "Issues" for the next function
    }
    function issueCertificate(string _cert, address issued_to_address) onlyIssuer public payable {
        //Checks Effect Interaction
        //Used to reduce the risk of re-entrancy attacks after external calls.
        uint amountPaid = balance[msg.sender]; //Paid Ether goes through here
        require(stage == Stages.Issues && amountPaid == 1 ether); //Requires the stage to be "Issues" and the Amount Paid to be 1 Eth before it goes through
        balance[msg.sender] -= msg.value; //Ether is taken out of issuer balance
        applicant[issued_to_address] = _cert; //Certificate is sent to issued address
        stage = Stages.Buy; //Returns stage back to default to prevent loops
    }
    function getIssuerHash() public onlyIssuer view returns(address){
        if (stage != Stages.Gets) {
            stage = Stages.Gets;
        } //Automatically sets stage to "Get" if it's not set already
        require (stage == Stages.Gets); //Requires the stage to be set to "Gets"
        return msg.sender; //Returns the hash of the issuer
    }
}


