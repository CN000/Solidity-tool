pragma solidity ^0.4.23;

contract BurnToken is HtcToken {

    event Burn(address indexed burner, uint256 value);

    function burn(uint256 _value) public {
        _burn(msg.sender, _value);
    }

    function _burn(address _who, uint256 _value) internal {
        require(  _balances[_who] >= _value );
        _balances[_who] = _balances[_who].sub(_value);
        _totalSupply    = _totalSupply.sub(_value);

        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }
}