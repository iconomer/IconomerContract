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

    /// @dev Change owner. Can only be applied by current owner
    /// @param _newOwner Address of a new Owner
    function changeOwner(address _newOwner) onlyOwner{
        owner = _newOwner;
    }

}
