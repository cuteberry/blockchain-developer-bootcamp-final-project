pragma solidity >=0.5 <0.9;


/// @title A smart contract interface to get contract balance and owner
/// @author Mei Lazell
interface MiddleContract {
    /// @notice Get the balance of the MiddleMan contract
    /// @return uint The balance of the contract
   function getContractBalance() external view returns (uint);
    /// @notice Get the owner of the smart contract
    /// @return address the address of the owner for ContractRegister
   function getOwner() external view returns (address);
}