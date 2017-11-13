pragma solidity ^0.4.10;

//
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
//
contract ERC20Interface {

    function totalSupply() public constant returns (uint256);

    function balanceOf(address owner) public constant returns (uint256);

    function allowance(address owner, address spender) public constant returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event Transfer(address indexed from, address indexed to, uint256 value);
}
