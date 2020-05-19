pragma solidity ^0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}




/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}


contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}



/**
 * @title Multi Sender, support ETH and ERC20 Tokens
*/

contract Ownable {
    address public owner;

    function Ownable() public{
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public{
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

/**
 * @title Multi Sender, support ETH and ERC20 Tokens
*/
contract MultiSender is Ownable {

    using SafeMath for uint;


    event LogGetToken(address token, address receiver, uint256 balance);
    event Multisended(uint256 total, address tokenAddress);

    address public receiverAddress;

    uint public txFee; // in wei


    // This contract keeps all Ether sent to it with no way
    // to get it back.
    constructor() public payable{
        txFee = 0.001 ether ;
    }

    function() public payable {}

    /**
     *  get balance
     */
    function getBalance(address _tokenAddress) onlyOwner public {
       address _receiverAddress = getReceiverAddress();
       if(_tokenAddress == address(0)) {
           require(_receiverAddress.send(address(this).balance));
           return;
       }

        ERC20 token = ERC20(_tokenAddress);
       uint256 balance = token.balanceOf(this);
       token.transfer(_receiverAddress, balance);
       emit LogGetToken(_tokenAddress,_receiverAddress,balance);
    }

    /*
        set receiver address
    */
    function setReceiverAddress(address _addr) onlyOwner public {
        require(_addr != address(0));
        receiverAddress = _addr;
    }


    /*
        get receiver address
    */
    function getReceiverAddress() public view returns  (address){
        if(receiverAddress == address(0)){
            return owner;
        }

        return receiverAddress;
    }

    function ethSendSameValue(address[] _to, uint _value) internal {

        uint sendAmount = _to.length.sub(1).mul(_value);
        uint remainingValue = msg.value;

        for (uint8 i = 0; i < _to.length; i++) {
            remainingValue = remainingValue.sub(_value);
            _to[i].transfer(_value);
        }
    }

    function ethSendDifferentValue(address[] _to, uint[] _value) internal {

        uint sendAmount = _value[0];
        uint remainingValue = msg.value;

        for (uint8 i = 0; i < _to.length; i++) {
            remainingValue = remainingValue.sub(_value[i]);
            _to[i].transfer(_value[i]);
        }
    }

    function coinSendSameValue(address _tokenAddress, address[] _to, uint _value)  internal {

        uint sendValue = msg.value;
        require(sendValue >= txFee);
        require(_to.length <= 255);

        address from = msg.sender;
        uint256 sendAmount = _to.length.sub(1).mul(_value);

        ERC20 token = ERC20(_tokenAddress);
        for (uint8 i = 0; i < _to.length; i++) {
            token.transferFrom(msg.sender, _to[i], _value);
        }

    }

    function coinSendDifferentValue(address _tokenAddress, address[] _to, uint[] _value)  internal  {
        uint sendValue = msg.value;

        require(sendValue >= txFee, "sendValue >= txFee");
        require(_to.length == _value.length, "_to.length == _value.length");
        require(_to.length <= 256, "_to.length <= 256");

        uint256 total = 0;
        ERC20 token = ERC20(_tokenAddress);
        for (uint8 i = 0; i < _to.length; i++) { // 2^8 = 256
            token.transferFrom(msg.sender, _to[i], _value[i]);
            total += _value[i];
        }
        Multisended(total, token);
    }

    /*
        Send ether with the same value by a explicit call method
    */

    function sendEth(address[] _to, uint _value) payable public {
        ethSendSameValue(_to,_value);
    }

    /*
        Send ether with the different value by a explicit call method
    */
    function multisend(address[] _to, uint[] _value) payable public {
        ethSendDifferentValue(_to,_value);
    }

    /*
        Send ether with the different value by a implicit call method
    */
    function mutiSendETHWithDifferentValue(address[] _to, uint[] _value) payable public {
        ethSendDifferentValue(_to,_value);
    }

    /*
        Send ether with the same value by a implicit call method
    */
    function mutiSendETHWithSameValue(address[] _to, uint _value) payable public {
        ethSendSameValue(_to,_value);
    }


    /*
        Send coin with the same value by a implicit call method
    */
    function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint _value) payable public {
        coinSendSameValue(_tokenAddress, _to, _value);
    }

    /*
       Send coin with the different value by a implicit call method, this method can save some fee.
    */
    function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint[] _value) payable public {
        coinSendDifferentValue(_tokenAddress, _to, _value);
    }

    /*
        Send coin with the different value by a explicit call method
    */
    function multisendToken(address _tokenAddress, address[] _to, uint[] _value) payable public {
        coinSendDifferentValue(_tokenAddress, _to, _value);
    }
}