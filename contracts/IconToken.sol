pragma solidity ^0.4.18;


import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract IconToken is MintableToken{

    // Token name
    string public name = "ICON Token";

    // Token symbol
    string public symbol = "ICON";

    // Decimal​ ​Places​ ​per​ ​Token
    uint public decimals = 18;
}
