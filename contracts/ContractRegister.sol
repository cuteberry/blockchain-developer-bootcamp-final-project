pragma solidity >=0.5 <0.9;

/// @title A contract register for middleman contract
/// @author Mei Lazell
contract ContractRegister {
    address public backendContract;
    address[] previousBackends;
    address public owner;

    /// @notice Set the contract owner as the creator of the contract
    constructor() public{
        owner = msg.sender;
    }
    /// @notice Ensure the funciton using this modifier can only called by the oner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    /// @notice Get the owner of the smart contract
    /// @return address the address of the owner for ContractRegister
    function getOwner() public view returns (address){
        return owner;
    }
    /// @notice Change backend contract to a new one by the owner
    /// @param newBackend The address of the new backend contract
    /// @return bool boolean value whether the backend contract has been updated
    function changeBackend(address newBackend) public onlyOwner returns (bool)
    {
        if(newBackend != address(0) && newBackend != backendContract) {
            previousBackends.push(backendContract);
            backendContract = newBackend;
            return true;
        }
        return false;
    }
}