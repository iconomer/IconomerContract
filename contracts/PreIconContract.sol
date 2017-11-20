pragma solidity ^0.4.10;


import './IconToken.sol';
import "../library/lifecycle/Pausable.sol";
import "../library/utils/SafeMath.sol";


contract PreIconContract is Pausable {

    // ICO start date
    uint public startDate;

    // ICO end date
    uint public endDate;

    // Address to which Ethers will be transfered in case of successful ICO
    address public wallet;

    uint public constant DECIMALS = 18;

    // 50 000 000 PreSale​ ​allocated​ Icon ​Tokens
    uint public constant PRE_ICON_SUPPLY_LIMIT = 50000000 * DECIMALS;

    // Token price on Presale ( 1ICON = 0.00014 ETH )
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

    // Presale finalized
    bool public finished;

    /*
     * Events
     */
    event TokensPurchased(address indexed from, uint indexed date, uint etherSpent, uint tokensPurchased);

    event PresaleFinished(uint date);

    /// Refund was processed for a contributor
    event Refund(address indexed to, uint indexed date, uint value);

    /*
     * Modifiers
     */
    modifier isRunning() {
        require(now >= startDate && now <= endDate && !finished);
        _;
    }

    modifier softCapReached() {
        require(softCap <= etherRaised);
        _;
    }

    modifier hardCapNotReached() {
        require(hardCap > etherRaised);
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
        assert(_hardCap > _softCap);

        wallet = _wallet;
        startDate = _startDate;
        endDate = _endDate;
        softCap = _softCap;
        hardCap = _hardCap;
        iconToken = new IconToken(this);
    }

    /// @dev Buy tokens on Pre sale
    function() payable isRunning isNotPaused hardCapNotReached{
        assert(msg.sender != 0x0);
        require(msg.value > 0);

        address _buyer = msg.sender;
        uint _value = msg.value;

        uint tokens = calculateTokens(_value);

        assert(tokens > 0);

        iconToken.mint(_buyer, tokens);

        soldTokens = SafeMath.add(soldTokens, tokens);

        etherRaised = SafeMath.add(etherRaised, _value);

        TokensPurchased(_buyer, now, _value, soldTokens);
    }

    /// @dev Finalize Tokens presale
    function finalizePresale() onlyOwner softCapReached {
        if (this.balance > 0) {
            wallet.transfer(this.balance);
        }
        finished = true;
        PresaleFinished(now);
    }

    /// @dev Calculating tokens count
    /// @param value Eth value
    /// @return tokens calculated tokens
    function calculateTokens(uint value) internal returns (uint tokens) {
        tokens = value * TOKEN_PRICE;

        // 25% bonus on pre-sale
        tokens += (tokens / 100) * 25;

        require(SafeMath.add(soldTokens, tokens) <= PRE_ICON_SUPPLY_LIMIT);
        return tokens;
    }
}
