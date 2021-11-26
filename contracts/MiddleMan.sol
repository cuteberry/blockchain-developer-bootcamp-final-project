pragma solidity >=0.5 <0.9;

contract MiddleMan{
    
    // <owner>
    // Let's make sure everyone knows who owns the middleman, yes, fill in the
    // appropriate visilibility keyword
    address public owner = msg.sender;

    uint private balance; 

    // Add an argument for this event, an accountAddress
    event LogEnrolled(address accountAddress);

    // Fill in the visibility keyword
    // Hint: We want to create a getter function and allow contracts to be able
    //       to see if a user is enrolled.
    mapping (address => bool) public enrolled;

    mapping(address => mapping (address => uint)) private records ;
    
    // modifier enoughValue(uint value) 
    modifier enoughValue(uint value) { 
        require(msg.value >= value); 
        _;
    }

    /// @notice Enroll a customer with the middleman
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      // 1. enroll of the sender of this transaction
      enrolled[msg.sender] = true;
      emit LogEnrolled(msg.sender);
      return enrolled[msg.sender];
    }
    //addr_from to request this only
    //deposit value to contract from addr_from
    //mark it's from addr_from and wait to be send to addr_to
    function withhold (address addr_to) public payable {
        require(enrolled[msg.sender]);
        records[msg.sender][addr_to] = msg.value;
        balance += msg.value;
    }

    //addr_from to request this only
    //deposit value from contract to address_from for the value withheld for addr_to 
    function refundSender (address receiver) public returns (bool){
        require(enrolled[msg.sender]);
        uint value = records[msg.sender][receiver];
        if (value >= 0 && balance >= value) {
            //refund the value to addr_from
            (bool sent,) = msg.sender.call.value(value)("");
            require(sent, "Failed to refund");
            records[msg.sender][receiver] = 0;
            balance -= value;
            return true;
        } 
        return false;
    }

    //addr_from to request this only
    //deposit value from contract to address_to if the request is from  addr_from 
    function distributeToReceiver (address payable receiver) public returns (bool){
        require(enrolled[msg.sender]);
        uint value = records[msg.sender][receiver];
        if (value >= 0 && balance >= value) {
            (bool sent,) = msg.sender.call.value(value)("");
            require(sent, "Failed to distribute");
            records[msg.sender][receiver] = 0;
            balance -= value;
            return true;
        } 
        return false;
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getBalanceForReceiver(address receiver) public view returns (uint) {
        require(enrolled[msg.sender]);
        return records[msg.sender][receiver];
    }

    constructor() public {
        // Set the owner to the transaction sender
        //owner = payable(msg.sender);
        //owner = msg.sender;
    }

}