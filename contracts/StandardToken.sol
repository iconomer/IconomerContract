pragma solidity ^0.4.10;


import './ERC20Interface.sol';


contract StandardToken is ERC20Interface {
    /*
     *  Data structures
     */
    mapping (address => uint256) balances;

    mapping (address => bool) ownerAppended;

    mapping (address => mapping (address => uint256)) allowed;

    uint256 public totalSupply;

    address[] public owners;


    /// @dev Returns number of total supply tokens.
    function totalSupply() public constant returns (uint256 supply){
        return totalSupply;
    }

    /// @dev Returns number of tokens owned by given address.
    /// @param owner Address of token owner.
    function balanceOf(address owner) public constant returns (uint256 balance) {
        return balances[owner];
    }

    /*
     * Read storage functions
     */
    /// @dev Returns number of allowed tokens for given address.
    /// @param owner Address of token owner.
    /// @param spender Address of token spender.
    function allowance(address owner, address spender) public constant returns (uint256 remaining) {
        return allowed[owner][spender];
    }

    /*
     *  Read and write storage functions
     */
    /// @dev Transfers sender's tokens to a given address. Returns success.
    /// @param to Address of token receiver.
    /// @param value Number of tokens to transfer.
    function transfer(address to, uint256 value) public returns (bool success) {
        if (balances[msg.sender] >= value && balances[to] + value > balances[to]) {
            balances[msg.sender] -= value;
            balances[to] += value;
            if (!ownerAppended[to]) {
                ownerAppended[to] = true;
                owners.push(to);
            }
            Transfer(msg.sender, to, value);
            return true;
        }
        else {
            return false;
        }
    }

    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
    /// @param from Address from where tokens are withdrawn.
    /// @param to Address to where tokens are sent.
    /// @param value Number of tokens to transfer.
    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        if (balances[from] >= value && allowed[from][msg.sender] >= value && balances[to] + value > balances[to]) {
            balances[to] += value;
            balances[from] -= value;
            allowed[from][msg.sender] -= value;
            if (!ownerAppended[to]) {
                ownerAppended[to] = true;
                owners.push(to);
            }
            Transfer(from, to, value);
            return true;
        }
        else {
            return false;
        }
    }

    /// @dev Sets approved amount of tokens for spender. Returns success.
    /// @param spender Address of allowed account.
    /// @param value Number of approved tokens.
    function approve(address spender, uint256 value) public returns (bool success) {
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }
}
