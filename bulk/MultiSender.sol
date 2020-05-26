pragma solidity ^0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

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
    function totalSupply() public constant returns (uint);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) internal allowed;


    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));

        //require(_value <= balances[_from]);
        //require(_value <= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    /**
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}



/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() public {
        owner = msg.sender;
    }


    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}


/**
 * @title Multi Sender, support ETH and ERC20 Tokens
*/
contract MultiSender is Ownable {

    using SafeMath for uint256;


    event LogGetToken(address token, address receiver, uint256 balance);
    event Multisended(uint256 total, address tokenAddress);

    event TransferSuccessful(address indexed from, address indexed to, uint256 amount);
    event TransferFailed(address indexed from, address indexed to, uint256 amount);
    event Log(string message);

    address public receiverAddress;

    uint256 public txFee = 0.01 ether; // in wei

    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev allow contract to receive funds
     */
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

       StandardToken token = StandardToken(_tokenAddress);
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

    function ethSendSameValue(address[] _to, uint256 _value) internal {
        uint sendAmount = _to.length.sub(1).mul(_value);
        uint remainingValue = msg.value;

        for (uint8 i = 0; i < _to.length; i++) {
            remainingValue = remainingValue.sub(_value);
            _to[i].transfer(_value);
        }
    }

    function ethSendDifferentValue(address[] _to, uint256[] _value) internal {

        uint256 sendAmount = _value[0];
        uint256 remainingValue = msg.value;

        for (uint8 i = 0; i < _to.length; i++) {
            remainingValue = remainingValue.sub(_value[i]);
            _to[i].transfer(_value[i]);
        }
    }

    function coinSendSameValue(address _tokenAddress, address[] _to, uint256 _value)  internal {

        uint sendValue = msg.value;
        require(sendValue >= txFee,"sendValue >= txFee");
        require(_to.length <= 255, "_to.length <= 255");

        
        StandardToken token = StandardToken(_tokenAddress);
        for (uint8 i = 0; i < _to.length; i++) {
            require(token.transferFrom(msg.sender, _to[i], _value),"transferFrom failure!");
        }
    }

    function coinSendDifferentValue(address _tokenAddress, address[] _to, uint256[] _value)  internal  {
        uint sendValue = msg.value;

        require(sendValue >= txFee, "sendValue >= txFee");
        require(_to.length == _value.length, "_to.length == _value.length");
        require(_to.length <= 256, "_to.length <= 256");

        uint256 total = 0;
        for (uint16 j = 0; j < _to.length; j++) {
            total += _value[j];
        }

        StandardToken token = StandardToken(_tokenAddress);
        require(token.balanceOf(msg.sender) >= total, "Balance >= Total");
//      require(total <= token.allowance(msg.sender, msg.sender) ,"allowed value is not enough!");

        for (uint16 i = 0; i < _to.length; i++) {
            TransferSuccessful(msg.sender, _to[i], _value[i]);
            require(token.transferFrom(msg.sender, _to[i], _value[i]), "transferFrom failure!");
            //token.transfer(_to[i], _value[i]);
        }
    }

    /*
        Send ether with the same value by a explicit call method
    */
    function sendEth(address[] _to, uint256 _value) payable public {
        ethSendSameValue(_to,_value);
    }

    /*
        Send ether with the different value by a explicit call method
    */
    function multisend(address[] _to, uint256[] _value) payable public {
        ethSendDifferentValue(_to,_value);
    }

    /*
        Send ether with the different value by a implicit call method
    */
    function mutiSendETHWithDifferentValue(address[] _to, uint256[] _value) payable public {
        ethSendDifferentValue(_to,_value);
    }

    /*
        Send ether with the same value by a implicit call method
    */
    function mutiSendETHWithSameValue(address[] _to, uint256 _value) payable public {
        ethSendSameValue(_to,_value);
    }

    /*
        Send coin with the same value by a implicit call method
    */
    function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint256 _value) payable public {
        coinSendSameValue(_tokenAddress, _to, _value);
    }

    /*
       Send coin with the different value by a implicit call method, this method can save some fee.
    */
    function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint256[] _value) payable public {
        coinSendDifferentValue(_tokenAddress, _to, _value);
    }

    /*
        Send coin with the different value by a explicit call method
    */
    function multisendToken(address _tokenAddress, address[] _to, uint256[] _value) payable public {
        coinSendDifferentValue(_tokenAddress, _to, _value);
    }
}