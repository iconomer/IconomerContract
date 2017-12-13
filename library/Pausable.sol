pragma solidity ^0.4.10;


import "./Ownable.sol";


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {

    bool public paused = false;

    event Pause();
    event Unpause();

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier isNotPaused() {
        require(!paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier isPaused() {
        require(paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() onlyOwner isNotPaused {
        paused = true;
        Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() onlyOwner isPaused{
        paused = false;
        Unpause();
    }
}
