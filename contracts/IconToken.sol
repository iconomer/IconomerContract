pragma solidity ^0.4.10;

import './StandardToken.sol';
import "../library/utils/SafeMath.sol";

contract IconToken is StandardToken{

    // Token name
    string public constant name = "ICON Token";

    // Token symbol
    string public constant symbol = "ICON";

    // Decimal​ ​Places​ ​per​ ​Token
    uint public constant DECIMALS = 18;

    // Total supply = 1 000 000 000 Icon tokens
    uint public constant INITIAL_TOTAL_SUPPLY = 1000000000 * DECIMALS;

    // Owner contract address
    address public owner;


    /*
     * Modifier for owner which regulates tokens emission
     */
    modifier onlyOwner() {
        // only ICO contract is allowed to proceed
        require(msg.sender == owner);
        _;
    }

    /*
     * Constructor
     */
    function IconToken(address _owner) {
        assert(_owner != 0x0);
        owner = _owner;
        totalSupply = INITIAL_TOTAL_SUPPLY;
    }

    /// @dev Burns tokens from address. Can only be applied by owner
    /// @param _from Address of account, from which tokens will be burned
    /// @param _value Amount of tokens, that will be burned
    function burn(address _from, uint _value) onlyOwner {
        assert(_from != 0x0);
        require(_value > 0);

        balances[_from] = SafeMath.sub(balances[_from], _value);
    }

    /// @dev Adds tokens to address. Can only be applied by owner
    /// @param _to Address of account to which the tokens will pass
    /// @param _value Amount of tokens
    function emit(address _to, uint _value) onlyOwner {
        assert(_to != 0x0);
        require(_value > 0);

        balances[_to] = SafeMath.add(balances[_to], _value);

        if(!ownerAppended[_to]) {
            ownerAppended[_to] = true;
            owners.push(_to);
        }
    }

    /// @dev Change owner. Can only be applied by current owner
    /// @param _newOwner Address of a new Owner
    function changeOwner(address _newOwner) onlyOwner{
        owner = _newOwner;
    }

}
