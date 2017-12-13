pragma solidity ^0.4.10;

//
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
//
contract ERC20Interface {

    /// total amount of tokens
    function totalSupply() public constant returns (uint256);

    /// @param owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address owner) public constant returns (uint256);

    /// @param owner The address of the account owning tokens
    /// @param spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address owner, address spender) public constant returns (uint256);

    /// @notice send `value` token to `to` from `msg.sender`
    /// @param to The address of the recipient
    /// @param value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address to, uint256 value) public returns (bool);

    /// @notice send `value` token to `to` from `from` on the condition it is approved by `from`
    /// @param from The address of the sender
    /// @param to The address of the recipient
    /// @param value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address from, address to, uint256 value) public returns (bool);

    /// @notice `msg.sender` approves `spender` to spend `value` tokens
    /// @param spender The address of the account able to transfer the tokens
    /// @param value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address spender, uint256 value) public returns (bool);


    /// Events
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
}
