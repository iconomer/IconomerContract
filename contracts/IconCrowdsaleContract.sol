pragma solidity ^0.4.18;


import './IconToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';


contract IconCrowdsaleContract is CappedCrowdsale, RefundableCrowdsale, Pausable {

    function IconCrowdsaleContract(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet) public
        CappedCrowdsale(_cap)
        FinalizableCrowdsale()
        RefundableCrowdsale(_goal)
        Crowdsale(_startTime, _endTime, _rate, _wallet){

        require(_goal <= _cap);
    }

    function createTokenContract() internal returns (MintableToken) {
        return new IconToken();
    }

    // low level token purchase function
    function buyTokens(address beneficiary) public payable whenNotPaused {
        require(beneficiary != address(0));
        require(validPurchase());

        uint256 weiAmount = msg.value;

        // calculate token amount to be created
        uint256 tokens = calculateTokens(weiAmount);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        token.mint(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

        forwardFunds();
    }

    /// @dev Calculating tokens amount
    /// @param value Eth value
    /// @return tokens calculated tokens
    function calculateTokens(uint256 value) internal returns (uint256 tokens) {
        tokens = value.mul(rate);

        // 25% bonus on Presale
        tokens += (tokens / 100) * 25;

        return tokens;
    }
}
