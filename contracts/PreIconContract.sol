pragma solidity ^0.4.10;


import './IconToken.sol';
import './SafeMath.sol';


contract PreIconContract {

    // ICO start date
    uint public startDate;

    // ICO end date
    uint public endDate;

    // Address of account to which Ethers will be tranfered in case of successful ICO
    address public escrow;

    // Address of manager
    address public manager;

    // 62 500 000 PreSale​ ​allocated​ Icon ​Tokens
    uint public constant PRE_ICON_SUPPLY_LIMIT = 62500000000000000000000000;

    // Sold tokens counter
    uint public soldTokens;

    // Ether raised counter
    uint public etherRaised;

    // Soft goal of ICO
    uint public softCap;

    // Hard goal of ICO
    uint public hardCap;

    // Hard goal of ICO
    uint public tokenPrice;

    // Stopped flag
    bool public stopped;

    // Icon Token address
    IconToken public iconToken;


    event TokenPurchase(address from, uint date, uint value);

    /*
     * Modifiers
     */

    modifier onlyManager() {
        require(msg.sender == manager);
        _;
    }

    modifier isRunning() {
        require(now >= startDate && now <= endDate && !stopped && etherRaised < hardCap);
        _;
    }

    modifier softCapReached() {
        require(softCap <= etherRaised);
        _;
    }

    /*
     * Constructor
     */

    function PreIconContract(address _manager, address _escrow, uint _startDate, uint _endDate, uint _softCap, uint _hardCap, uint _tokenPrice) {
        assert(_manager != 0x0);
        assert(_escrow != 0x0);
        assert(_startDate != 0);
        assert(_endDate != 0);
        assert(_softCap > 0);
        assert(_hardCap > 0);
        assert(_hardCap > 0);
        assert(_tokenPrice > 0);

        manager = _manager;
        escrow = _escrow;
        startDate = _startDate;
        endDate = _endDate;
        softCap = _softCap;
        hardCap = _hardCap;
        tokenPrice = _tokenPrice;
        iconToken = new IconToken(this);
    }

    function buyTokens(address _buyer, uint _value) private {
        assert(_buyer != 0x0);
        require(_value > 0);

        uint tokensToEmit = _value * tokenPrice;

        // 25% bonus on pre-sale
        tokensToEmit += (tokensToEmit / 100) * 25;

        require(SafeMath.add(soldTokens, tokensToEmit) <= PRE_ICON_SUPPLY_LIMIT);

        soldTokens = SafeMath.add(soldTokens, tokensToEmit);

        iconToken.emit(_buyer, tokensToEmit);

        etherRaised = SafeMath.add(etherRaised, _value);

        TokenPurchase(_buyer, now, _value);
    }

    /// @dev Buy tokens on Pre sale
    function() payable isRunning {
        buyTokens(msg.sender, msg.value);
    }

    /// @dev Partial withdraw. Only manager can do it only after soft cap reached
    /// @param _value ether amount to be withdrawn
    function withdrawEther(uint _value) onlyManager softCapReached{
        require(_value > 0);
        assert(_value <= this.balance);
        escrow.transfer(_value);
    }

    /// @dev All ether withdraw. Only manager can do it only after soft cap reached
    function withdrawAllEther() onlyManager softCapReached{
        if (this.balance > 0) {
            escrow.transfer(this.balance);
        }
    }

    /// @dev Sets new ICO manager. Only manager can do it
    /// @param _newManager Address of new ICO manager
    function setNewManager(address _newManager) onlyManager {
        assert(_newManager != 0x0);
        manager = _newManager;
    }

    /// @dev Stop selling tokens
    function stopSellingTokens() onlyManager {
        stopped = true;
    }

    /// @dev Resume selling tokens
    function resumeSellingTokens() onlyManager {
        stopped = false;
    }
}
