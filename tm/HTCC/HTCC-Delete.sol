pragma solidity ^0.5.7;


library SafeMath {
    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

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

    /**
     * @dev Integer division of two unsigned integers truncating the quotient,
     * reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return a / b;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

interface IERC20{
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function totalSupply() external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Burn {
    using SafeMath for uint256;

    IERC20 public TOKEN;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Donate(address indexed account, uint256 amount);
    event Burn(address indexed from, uint256 value);

    constructor() public {
        TOKEN = IERC20(0xf30c75D2b1eA645DB2E07B7507dCB0CC3c300156);
    }

    function () external payable {
        //  sender's balance >= msg.value
        require(TOKEN.balanceOf(msg.sender) >= msg.value);

        // TotalSupply >= msg.value
        require(TOKEN.totalSupply() >= msg.value);

        //emit Transfer(msg.sender, address(0), msg.value);
        //emit Donate(msg.sender, msg.value);
        //emit Burn(msg.sender, msg.value);

        Token.transferFrom(msg.sender, address(0), msg.value);

        return true;
    }
}