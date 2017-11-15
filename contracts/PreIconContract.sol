pragma solidity ^0.4.10;


import './IconToken.sol';
import "../library/lifecycle/Pausable.sol";
import "../library/utils/SafeMath.sol";


contract PreIconContract is Pausable {

    // ICO start date
    uint public startDate;

    // ICO end date
    uint public endDate;

    // Address of account to which Ethers will be tranfered in case of successful ICO
    address public wallet;

    uint public constant DECIMALS = 18;

    // 50 000 000 PreSale​ ​allocated​ Icon ​Tokens
    uint public constant PRE_ICON_SUPPLY_LIMIT = 50000000 * DECIMALS;

    // Token price on Presale ( 0.00014 ETH )
    uint public constant TOKEN_PRICE = 7000;

    // Sold tokens counter
    uint public soldTokens;

    // Ether raised counter
    uint public etherRaised;

    // ICO Soft goal
    uint public softCap;

    // ICO Hard goal
    uint public hardCap;

    // Icon Token address
    IconToken public iconToken;


    event TokensPurchased(address indexed from, uint indexed date, uint etherSpent, uint tokensPurchased);

    event PreSaleFinished(uint date);

    /*
     * Modifiers
     */

    modifier isRunning() {
        require(now >= startDate && now <= endDate && etherRaised < hardCap);
        _;
    }

    modifier softCapReached() {
        require(softCap <= etherRaised);
        _;
    }

    /*
     * Constructor
     */

    function PreIconContract(address _wallet, uint _startDate, uint _endDate, uint _softCap, uint _hardCap) {
        assert(_wallet != 0x0);
        assert(_startDate != 0);
        assert(_endDate != 0);
        assert(_endDate > _startDate);
        assert(_softCap > 0);
        assert(_hardCap > 0);

        wallet = _wallet;
        startDate = _startDate;
        endDate = _endDate;
        softCap = _softCap;
        hardCap = _hardCap;
        iconToken = new IconToken(this);
    }

    /// @dev Buy tokens on Pre sale
    function() payable isRunning isNotPaused {
        assert(msg.sender != 0x0);
        require(msg.value > 0);

        address _buyer = msg.sender;
        uint _value = msg.value;

        uint tokensToEmit = _value * TOKEN_PRICE;

        // 25% bonus on pre-sale
        tokensToEmit += (tokensToEmit / 100) * 25;

        require(SafeMath.add(soldTokens, tokensToEmit) <= PRE_ICON_SUPPLY_LIMIT);

        iconToken.emit(_buyer, tokensToEmit);

        soldTokens = SafeMath.add(soldTokens, tokensToEmit);

        etherRaised = SafeMath.add(etherRaised, _value);

        TokensPurchased(_buyer, now, _value, soldTokens);
    }


    /// @dev Finalize Tokens preSale
    function finalizePresale() onlyOwner softCapReached {
        if (this.balance > 0) {
            wallet.transfer(this.balance);
            pause();
        }
        PreSaleFinished(now);
    }
}
