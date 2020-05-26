pragma solidity ^0.5.7;


/**
 * @title SafeMath for uint256
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath256 {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }
}


/**
 * @title Ownable
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract
     * to the sender account.
     */
    constructor () internal {
        _owner = msg.sender;
    }

    /**
     * @return The address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0));
        address __previousOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(__previousOwner, newOwner);
    }

    /**
     * @dev Rescue compatible ERC20 Token
     *
     * @param tokenAddr ERC20 The address of the ERC20 token contract
     * @param receiver The address of the receiver
     * @param amount uint256
     */
    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
        IERC20 __token = IERC20(tokenAddr);
        require(receiver != address(0));
        uint256 __balance = __token.balanceOf(address(this));

        require(__balance >= amount);
        assert(__token.transfer(receiver, amount));
    }
}


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20{
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}


/**
 * @title Batch Transfer Ether And Token
 */
contract BatchTransferEtherAndVoken is Ownable{
    using SafeMath256 for uint256;

    /**
     * @dev Batch transfer Voken.
     */
    function multisendToken(address tokenAddress, address[] accounts, uint256[] tokenValue) payable public {

        IERC20 TOKEN = IERC20(tokenAddress);

        //uint256 __tokenAllowance = TOKEN.allowance(msg.sender, address(this));
        //require(__tokenAllowance >= tokenValue.mul(accounts.length));

        require(TOKEN.transfer(accounts[0], tokenValue[0]), "transfer token 0!");
        require(TOKEN.transfer(accounts[1], tokenValue[1]), "transfer token 1!");

        for (uint256 i = 0; i < accounts.length; i++) {
            // assert(TOKEN.transfer(accounts[i], tokenValue[i]));
        }
    }
}