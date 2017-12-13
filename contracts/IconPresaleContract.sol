pragma solidity ^0.4.10;


import './IconToken.sol';
import "../library/Pausable.sol";
import "../library/utils/SafeMath.sol";


contract IconPresaleContract is Pausable {

    // UNIX timestamp start date of ICON Presale
    uint public startsAt;

    // UNIX timestamp end date of ICON Presale
    uint public endsAt;

    // Address to which Ethers will be transfered in case of successful ICO
    address public wallet;

    // Decimal value
    uint public constant DECIMALS = 18;

    // 50 000 000 PreSale​ ​allocated​ Icon ​Tokens
    uint public constant PRE_ICON_SUPPLY_LIMIT = 50000000 * DECIMALS;

    // Token price on Presale ( 1ICON = 0.00014 ETH )
    uint public constant TOKEN_PRICE = 7000;

    // Sold tokens counter
    uint public soldTokens = 0;

    // Ether raised counter
    uint public etherRaised = 0;

    // Presale Soft goal = 2500 ETH
    uint public softCap = 2500;

    // Presale Hard goal = 5000 ETH
    uint public hardCap = softCap * 2;

    // Investors map
    mapping (address => uint256) investors;

    // Icon Token address
    IconToken public iconToken;

    // Presale finalized
    bool public finished;

    // Presale was successfull
    bool public success;

    /*
     * Events
     */
    event TokensPurchased(address indexed from, uint indexed date, uint etherSpent, uint tokensPurchased);

    event PresaleCompleted(uint indexed date, uint totalTokensSold, uint etherRaised);

    /// Refund was processed for a contributor
    event Refund(address indexed to, uint indexed date, uint value);

    event TokenOwnerChanged(address indexed token, address owner, uint date);

    /*
     * Modifiers
     */
    modifier isPresaleRunning() {
        require(now >= startsAt && now <= endsAt && !finished);
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

    modifier isPresaleFinished(){
        require(finished);
        _;
    }

    /*
     * Constructor
     */
    function IconPresaleContract(address _wallet, uint _startsAt, uint _endsAt) {
        assert(_wallet != 0x0);
        assert(_startsAt != 0);
        assert(_endsAt != 0);
        assert(_endsAt > _startsAt);

        wallet = _wallet;
        startsAt = _startsAt;
        endsAt = _endsAt;
        iconToken = new IconToken(this);
    }

    /// @dev Token purchase is allowed on following conditions:
    /// - Purchase date is between Presale start and end date
    /// - Hardcap is not reached
    /// - Presale is not paused
    /// - Presale is not finalized
    function() payable isRunning isNotPaused hardCapNotReached {
        assert(msg.sender != 0x0);
        require(msg.value > 0);

        address _buyer = msg.sender;
        uint _value = msg.value;

        uint tokens = calculateTokens(_value);

        assert(tokens > 0);

        iconToken.mint(_buyer, tokens);

        soldTokens = SafeMath.add(soldTokens, tokens);
        etherRaised = SafeMath.add(etherRaised, _value);

        investors[msg.sender] += _value;

        TokensPurchased(_buyer, now, _value, soldTokens);
    }

    /// @dev Finalize Tokens Presale. Can be executed by owner and only if softCap is reached
    function finalizePresale() public onlyOwner softCapReached {
        if (this.balance > 0) {
            wallet.transfer(this.balance);
        }
        finished = true;
        PresaleCompleted(now, soldTokens, etherRaised);
    }

    /// @dev Change Token owned contract when Presale is finished. Can be executed by owner
    /// @param value Eth value
    /// @return tokens calculated tokens
    function changeTokenOwnership(address newOwner) public onlyOwner isPresaleFinished{
        assert(newOwner != 0x0);
        iconToken.transferOwnership(newOwner);
        TokenOwnerChanged(iconToken, tokenOwner, now);
    }

    /// @dev In case Presale was not successful - return all funds to investors
    function refund() internal {
        for (uint i = 0; i < investors.length; i++) {


            if (!investors[1].send(weiValue)) throw;
            iconToken.burn();
        }
        uint256 weiValue = investedAmountOf[msg.sender];
        if (weiValue == 0) throw;
        investedAmountOf[msg.sender] = 0;
        weiRefunded = weiRefunded.plus(weiValue);
        Refund(msg.sender, weiValue);
        if (!msg.sender.send(weiValue)) throw;
    }

    /// @dev Calculating tokens amount
    /// @param value Eth value
    /// @return tokens calculated tokens
    function calculateTokens(uint value) internal returns (uint tokens) {
        tokens = value * TOKEN_PRICE;

        // 25% bonus on Presale
        tokens += (tokens / 100) * 25;

        // check transaction hasn't collect all available tokens
        require(SafeMath.add(soldTokens, tokens) <= PRE_ICON_SUPPLY_LIMIT);
        return tokens;
    }
}
