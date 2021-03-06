// Bank contract
// Allows ________________________, ________________________, and balance checks

// Declare the source file ___________________ version
pragma solidity ^0.4.19;

// Start with ________________________ comment (the three slashes)
// used for documentation - and as descriptive data for UI elements/actions

/// @title SimpleBank
/// @author nemild

/* 'contract' has similarities to '________________________' in other languages. */
contract SimpleBank {
    // Declare ________________________ outside function, persist through life of contract

    // ________________________ that maps addresses to balances
    mapping (address => uint) private balances;

    // "________________________" means that other contracts can't directly query balances
    // but data is still viewable to other parties on blockchain

    address public owner;
    // '________________________' makes externally ________________________ (not writeable) by users or contracts

    // ________________________ - publicize actions to external listeners
    event LogDepositMade(address accountAddress, uint amount);

    // ________________________, can receive one or many variables here; only one allowed
    function SimpleBank() public {
        // msg provides details about the message that's sent to the contract
        // msg.sender is contract caller (address of contract creator)
        owner = msg.sender;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        // Use '________________________' to test user inputs, 'assert' for internal invariants
        // Here we are making sure that there isn't an ________________________ issue
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);

        balances[msg.sender] += msg.value;
        // no "this." or "self." required with state variable
        // all values set to data type's initial value by default

        LogDepositMade(msg.sender, msg.value); // ________________________________________________

        return balances[msg.sender];
    }

    /// @notice ________________________ ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        require(withdrawAmount <= balances[msg.sender]);

        // Note the way we deduct the balance right away, before sending
        // Every .transfer/.send from this contract can call an external function
        // This may allow the caller to request an amount greater
        // than their balance using a recursive call
        // Aim to commit state before calling external functions, including .transfer/.send
        balances[msg.sender] -= withdrawAmount;

        // this automatically throws on a failure, which means the updated balance is reverted
        msg.sender.transfer(withdrawAmount);

        return balances[msg.sender];
    }

    /// @notice ________________________________________________________________________
    /// @return The balance of the user
    // '________________________' (ex: constant) prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function balance() view public returns (uint) {
        return balances[msg.sender];
    }
}
