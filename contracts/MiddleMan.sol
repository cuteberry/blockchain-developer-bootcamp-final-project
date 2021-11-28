pragma solidity >=0.5 <0.9;

/// @title A middle man smart contract so that trasaction can be reverted later
/// @author Mei Lazell
import "./MiddleContract.sol";
contract MiddleMan is MiddleContract{
    
    address private owner;
    uint private balance; 
    /// Add an argument for this event, an accountAddress
    event LogEnrolled(address accountAddress);
    /// Fill in the visibility keyword
    /// Hint: We want to create a getter function and allow contracts to be able
    ///       to see if a user is enrolled.
    mapping (address => bool) public enrolled;
    mapping(address => mapping (address => uint)) private records ;
    /// @notice Get the owner of the smart contract
    /// @return address The address of the owner for ContractRegister
    function getOwner() external override view returns (address){
        return owner;
    }
    /// @notice Ensure the funciton using this modifier can only called by the oner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    /// @notice Enroll a customer with the middleman when it's requested by owner
    /// @return bool The users enrolled status
    // Emit the appropriate event
    // allow for project verification purpose, remove onlyOwner modifier temprally
    function enroll() public returns (bool){
      // 1. enroll of the sender of this transaction
      enrolled[msg.sender] = true;
      emit LogEnrolled(msg.sender);
      return enrolled[msg.sender];
    }

    /// @notice Withhold the value for reciever from sender when the sender is enrolled
    /// @param receiver the address of the receiver
    function withhold (address receiver) public payable {
        if (!enrolled[msg.sender]) {
            enroll();
        }
        records[msg.sender][receiver] = msg.value;
        balance += msg.value;
    }

    /// @notice Refund the value to the sender for the reciever when the sender is enrolled
    /// @param receiver the address of the receiver
    /// @return bool the bool value whether the refund has been successful
    function refundSender (address receiver) public returns (bool){
        require(enrolled[msg.sender]);
        uint value = records[msg.sender][receiver];
        if (value >= 0 && balance >= value) {
            //refund the value to addr_from
            (bool sent,) = msg.sender.call{value: value}("");
            require(sent, "Failed to refund");
            records[msg.sender][receiver] = 0;
            balance -= value;
            return true;
        } 
        return false;
    }

    /// @notice Distribute the value to the reciever when the sender is enrolled
    /// @param receiver the address of the receiver
    /// @return bool The bool value whether the distribution has been successful
    function distributeToReceiver (address payable receiver) public returns (bool){
        require(enrolled[msg.sender]);
        uint value = records[msg.sender][receiver];
        if (value >= 0 && balance >= value) {
            (bool sent,) = receiver.call{value: value}("");
            require(sent, "Failed to distribute");
            records[msg.sender][receiver] = 0;
            balance -= value;
            return true;
        } 
        return false;
    }
    /// @notice Get the balance of the MiddleMan contract
    /// @return uint The balance of the contract
    function getContractBalance() external override view returns (uint) {
        return address(this).balance;
    }
    /// @notice Get the balance for the receiver from sender 
    /// @param receiver the address of the reciever
    /// @return uint The balance for the receiver from sender 
    function getBalanceForReceiver(address receiver) public view returns (uint) {
        require(enrolled[msg.sender]);
        return records[msg.sender][receiver];
    }
    /// @notice Get the balance for an address
    /// @param addr the address of an account
    /// @return uint The balance for the address
    function balanceOf(address addr) public view returns(uint)
    {
        return addr.balance;
    }

    constructor() public {
        owner = msg.sender;
    }
    
    // This contract keeps all Ether sent to it with no way
    // to get it back.
    fallback() external payable {}

    receive() external payable {
        // custom function code
    }
}