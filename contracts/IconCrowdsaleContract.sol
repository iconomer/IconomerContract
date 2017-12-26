pragma solidity ^0.4.18;


import './IconToken.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';
import 'zeppelin-solidity/contracts/crowdsale/RefundableCrowdsale.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';


contract IconCrowdsaleContract is CappedCrowdsale, RefundableCrowdsale, Pausable {

    function IconCrowdsaleContract(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _goal, uint256 _cap, address _wallet)
        CappedCrowdsale(_cap)
        FinalizableCrowdsale()
        RefundableCrowdsale(_goal)
        Crowdsale(_startTime, _endTime, _rate, _wallet) public{

        require(_goal <= _cap);
    }

    /**
     * event for Bounty Reward logging
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param timestamp when reward was issued
     */
    event BountyRewardIssued(address indexed beneficiary, uint256 value, uint256 timestamp);

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
    function calculateTokens(uint256 value) internal view returns (uint256 tokens) {
        tokens = value.mul(rate);

        // 25% bonus on Presale
        tokens += (tokens / 100) * 25;

        return tokens;
    }

    /// @dev Grants a reward for Bounty program
    /// @param beneficiary who gets the reward
    /// @param value Token reward
    function bountyReward(address beneficiary, uint256 value) public onlyOwner {
        require(beneficiary != address(0));
        require(value > 0);
        require(!hasEnded());

        token.mint(beneficiary, value);
        BountyRewardIssued(beneficiary, value, now);
    }

    /// @dev Transfers Token ownership to new contract when presale is finished
    /// @param newICOOwner address of a new contract which will own the token
    function transferTokenICOOwnership(address newICOOwner) public onlyOwner {
        require(newICOOwner != address(0));
        require(isFinalized && goalReached());

        token.transferOwnership(newICOOwner);
    }
}
