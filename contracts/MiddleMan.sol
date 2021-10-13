pragma solidity >=0.4.22 <0.9.0;

contract MiddleMan{
    
    // <owner>
    address public owner; 

    uint private balance; 

    mapping(address => mapping (address => uint)) private records ;
    
    // modifier enoughValue(uint value) 
    modifier enoughValue(uint value) { 
        require(msg.value >= value); 
        _;
    }

    //addr_from to request this only
    //deposit value to contract from addr_from
    //mark it's from addr_from and wait to be send to addr_to
    function withhold (address addr_to) public payable {
        records[msg.sender][addr_to] = msg.value;
    }

    //addr_from to request this only
    //deposit value from contract to address_to if the request is from  addr_from 
    function distribute (address addr_to) public returns (bool){
        uint value = records[msg.sender][addr_to];
        if (value >= 0 && balance >= value) {
            (bool sent, bytes memory data) = addr_to.call{value: value}("");
            require(sent, "Failed to distribute");
            records[msg.sender][addr_to] = 0;
            return true;
        } 
        return false;
    }

    //addr_from to request this only
    //deposit value from contract to address_from for the value withheld for addr_to 
    function refund (address addr_to) public returns (bool){
        uint value = records[msg.sender][addr_to];
        if (value >= 0 && balance >= value) {
            //refund the value to addr_from
            (bool sent, bytes memory data) = msg.sender.call{value: value}("");
            require(sent, "Failed to refund");
            records[msg.sender][addr_to] = 0;
            return true;
        } 
        return false;
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }


    constructor() public {
        // Set the owner to the transaction sender
        owner = payable(msg.sender);
    }

}