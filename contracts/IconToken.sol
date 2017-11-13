pragma solidity ^0.4.10;

import './StandardToken.sol';
import './SafeMath.sol';

contract IconToken is StandardToken{
    /*
     * Token name
     */
    string public constant name = "ICON Token";

    /*
     * Token symbol
     */
    string public constant symbol = "ICON";

    /*
     * Decimal​ ​Places​ ​per​ ​Token
     */
    uint public constant decimals = 18;

    /*
     * Owner contract address
     */
    address public ownerContract;

    // 2 000 000 000 Icon tokens
    uint public constant TOTAL_SUPPLY = 1000000000000000000000000000;


    /*
     * Modifier for owner Contract which regulates tokens emission
     */
    modifier onlyOwnerContract() {
        // only ICO contract is allowed to proceed
        require(msg.sender == ownerContract);
        _;
    }

    /*
     * Constructor
     */
    function IconToken(address _ownerContract) {
        assert(_ownerContract != 0x0);
        ownerContract = _ownerContract;
        totalSupply = TOTAL_SUPPLY;
    }

    /// @dev Burns tokens from address. Can only be applied by ownerContract
    /// @param _from Address of account, from which will be burned tokens
    /// @param _value Amount of tokens, that will be burned
    function burn(address _from, uint _value) onlyOwnerContract {
        assert(_from != 0x0);
        require(_value > 0);

        balances[_from] = SafeMath.sub(balances[_from], _value);
    }

    /// @dev Adds tokens to address. Can only be applied by ownerContract
    /// @param _to Address of account to which the tokens will pass
    /// @param _value Amount of tokens
    function emit(address _to, uint _value) onlyOwnerContract {
        assert(_to != 0x0);
        require(_value > 0);

        balances[_to] = SafeMath.add(balances[_to], _value);

        if(!ownerAppended[_to]) {
            ownerAppended[_to] = true;
            owners.push(_to);
        }
    }

    /// @dev Change owner Contract. Can only be applied by ownerContract
        /// @param _newOwnerContract Address of a new Owner Contract
    function changeOwnerContract(address _newOwnerContract) onlyOwnerContract{
        ownerContract = _newOwnerContract;
    }

}
