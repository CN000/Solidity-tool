pragma solidity ^0.5.7;


/**
 * @title SafeMath for uint256
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath256 {
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



interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}


contract Burn  {
    using SafeMath256 for uint256;

    mapping (address => uint256) private _balances;

    IERC20 public TOKEN;

    string  public  _black_hole = "0x0000000000000000000000000000000000000001";


    constructor() public {
        TOKEN = IERC20(0xf30c75D2b1eA645DB2E07B7507dCB0CC3c300156);
    }

    function () external payable {
        _burn(msg.sender, msg.value);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(amount != 0);
        require(amount <= TOKEN.balanceOf(account));


        _balances[account] = TOEKN.balanceOf(account).sub(amount);


        emit Transfer(account, _black_hole, amount);
    }

    function burnFrom(address account, uint256 amount) external {
        require(amount <= _allowed[account][msg.sender]);

        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
        _burn(account, amount);
    }
}
