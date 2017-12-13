pragma solidity ^0.4.10;

import './StandardToken.sol';
import "../library/utils/SafeMath.sol";


contract IconToken is StandardToken, Ownable{

    // Token name
    string public constant name = "ICON Token";

    // Token symbol
    string public constant symbol = "ICON";

    // Decimal​ ​Places​ ​per​ ​Token
    uint public constant DECIMALS = 18;

    // Total supply = 1 000 000 000 Icon tokens
    uint public constant INITIAL_TOTAL_SUPPLY = 1000000000 * DECIMALS;

    /*
     * Constructor
     */
    function IconToken() {
        totalSupply = INITIAL_TOTAL_SUPPLY;
    }

    /// @dev Create new tokens and allocate them to an address. Can only be applied by current owner
    /// @param _to Address of receiver
    /// @param _value  Number of tokens to issue.
    function mint(address _to, uint _value) onlyOwner {
        assert(_to != 0x0);
        require(_value > 0);

        balances[_to] = SafeMath.add(balances[_to], _value);

        if(!ownerAppended[_to]) {
            ownerAppended[_to] = true;
            owners.push(_to);
        }

        Transfer(0, _to, _value);
    }

    /// @dev Burn tokens from given address. Can only be applied by current owner
    /// @param _from Address from which tokens must be burned
    /// @param _value  Number of tokens to issue.
    function burn(address _from, uint _value) onlyOwner {
        assert(_from != 0x0);
        require(_value > 0);

        balances[_from] = SafeMath.sub(balances[_from], _value);

        Transfer(_from, 0, _value);
    }
}
