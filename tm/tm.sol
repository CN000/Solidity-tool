pragma solidity ^0.5.7;


library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;

        assert(c >= a);

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);

        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;

        assert(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);

        uint256 c = a / b;

        assert(a == b * c + a % b);

        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);

        return a % b;
    }
}


interface IERC20{
    function name()                                                       external view returns (string memory);
    function symbol()                                                     external view returns (string memory);
    function decimals()                                                   external view returns (uint8);
    function totalSupply()                                                external view returns (uint256);
    function balanceOf(    address holder)                                external view returns (uint256);
    function transfer(     address to,      uint256 value)                external returns (bool);
    function transferFrom( address from,    address to,    uint256 value) external returns (bool);
    function approve(      address spender, uint256 value)                external returns (bool);
    function allowance(    address holder,  address spender)              external view returns (uint256);

    event Transfer(address indexed from,   address indexed to,      uint256 value);
    event Approval(address indexed holder, address indexed spender, uint256 value);
}


contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0));

        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
    }

    function rescueTokens(address tokenAddress, address receiver, uint256 amount) external onlyOwner {
        IERC20 tokenObj = IERC20(tokenAddress);

        require(receiver != address(0));

        uint256 balance = tokenObj.balanceOf(address(this));

        require(balance >= amount);

        assert(tokenObj.transfer(receiver, amount));
    }

    function withdrawEther(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0));

        uint256 balance = address(this).balance;

        require(balance >= amount);

        to.transfer(amount);
    }
}

contract Pausable is Ownable {
    bool private _paused;

    event Paused(address account);
    event Unpaused(address account);

    constructor () internal {
        _paused = false;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

    modifier whenPaused() {
        require(_paused);
        _;
    }

    function pause() external onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

/**
 *   Main Contract
 */
contract Tm is Ownable, Pausable, IERC20 {
    using SafeMath for uint256;

    string  private  _name        = "TM TOKEN";
    string  private  _symbol      = "TM";
    uint8   private  _decimals    = 3;
    uint256 private  _cap         = 10000000000000;// 10billion
    uint256 private  _totalSupply ;
    uint256 public constant INITIAL_SUPPLY = 10000000000000; // 10billion

    mapping (address => bool) private _minter;
    event Mint(address indexed to, uint256 value);
    event MinterChanged(address account, bool state);

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    bool private _allowWhitelistRegistration;

    mapping(address => address) private _referrer;
    mapping(address => uint256) private _refCount;

    event TmSaleWhitelistRegistered(address indexed account, address indexed refAccount);
    event TmSaleWhitelistTransferred(address indexed previousAccount, address indexed _newAccount);
    event TmSaleWhitelistRegistrationEnabled();
    event TmSaleWhitelistRegistrationDisabled();

    uint256     private _activeReward = 1001000; // 1001 Tm, 1001.000
    uint256[15] private _whitelistRefRewards = [               // 100% Reward
        301000,  // 301 Tm for Level.1
        200000,  // 200 Tm for Level.2
        100000,  // 100 Tm for Level.3
        100000,  // 100 Tm for Level.4
        100000,  // 100 Tm for Level.5
        50000,   //  50 Tm for Level.6
        40000,   //  40 Tm for Level.7
        30000,   //  30 Tm for Level.8
        20000,   //  20 Tm for Level.9
        10000,   //  10 Tm for Level.10
        10000,   //  10 Tm for Level.11
        10000,   //  10 Tm for Level.12
        10000,   //  10 Tm for Level.13
        10000,   //  10 Tm for Level.14
        10000    //  10 Tm for Level.15
    ];

    event Donate(address indexed account, uint256 amount);

    constructor() public {
        _minter[msg.sender]         = true;
        _allowWhitelistRegistration = true;

        _totalSupply          = INITIAL_SUPPLY;
        _balances[msg.sender] = INITIAL_SUPPLY;

        emit TmSaleWhitelistRegistrationEnabled();

        _referrer[msg.sender] = msg.sender;
        emit TmSaleWhitelistRegistered(msg.sender, msg.sender);
    }


    /**
     *  donate
     */
    function () external payable {
        emit Donate(msg.sender, msg.value);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function cap() public view returns (uint256) {
        return _cap;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address holder) public view returns (uint256) {
        return _balances[holder];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
        if (_allowWhitelistRegistration
                && value == _activeReward
                    && inWhitelist(to)
                        && !inWhitelist(msg.sender)
                            && isNotContract(msg.sender)) {
            _regWhitelist(msg.sender, to);
        } else {
            _transfer(msg.sender, to, value);
        }

        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));

        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));

        return true;
    }

    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
        require(_allowed[from][msg.sender] >= value);

        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));

        return true;
    }

    /**
     *  Transfer Token
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value); // _
        _balances[to]   = _balances[to].add(value);   // +
        emit Transfer(from, to, value);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0));

        require(spender != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    modifier onlyInWhitelist() {
        require(_referrer[msg.sender] != address(0));
        _;
    }

    function allowWhitelistRegistration() public view returns (bool) {
        return _allowWhitelistRegistration;
    }

    function inWhitelist(address account) public view returns (bool) {
        return _referrer[account] != address(0);
    }

    /**
     * 找到这个帐号的推荐人
     */
    function referrer(address account) public view returns (address) {
        return _referrer[account];
    }

    /**
         推荐了几个人
     */
    function refCount(address account) public view returns (uint256) {
        return _refCount[account];
    }

    function disableTmSaleWhitelistRegistration() external onlyOwner {
        _allowWhitelistRegistration = false;
        emit TmSaleWhitelistRegistrationDisabled();
    }

    function _regWhitelist(address account, address refAccount) internal {
        _refCount[refAccount] = _refCount[refAccount].add(1); //  推荐人的推荐会员数+1
        _referrer[account]    = refAccount;                   //  确定推荐人和被人推荐人的关系

        emit TmSaleWhitelistRegistered(account, refAccount);

        // Whitelist Registration Referral Reward
        _transfer(msg.sender, address(this), _activeReward);

        address cursor = account;
        uint256 remain = _activeReward;

        for(uint i = 0; i < _whitelistRefRewards.length; i++) {
            address receiver = _referrer[cursor];
            if (cursor != receiver) {
                if (_refCount[receiver] > i) {
                    _transfer(address(this), receiver, _whitelistRefRewards[i]);
                    remain = remain.sub(_whitelistRefRewards[i]);
                }
            } else {
                _transfer(address(this), refAccount, remain);
                break;
            }

            cursor = _referrer[cursor];
        }
    }

    function transferWhitelist(address account) external onlyInWhitelist {
         require(isNotContract(account));


        _refCount[account]    = _refCount[msg.sender];
        _refCount[msg.sender] = 0;
        _referrer[account]    = _referrer[msg.sender];
        _referrer[msg.sender] = address(0);

        emit TmSaleWhitelistTransferred(msg.sender, account);
    }

    function isNotContract(address account) internal view returns (bool) {
        uint size;

        assembly {
            size := extcodesize(account)
        }

        return size == 0;
    }

    function calculateTheRewardOfDirectWhitelistRegistration(address whitelistedAccount) external view returns (uint256 reward) {
        if ( !inWhitelist(whitelistedAccount) ) {
            return 0;
        }

        address cursor = whitelistedAccount;
        uint256 remain = _activeReward;
        for(uint i = 1; i < _whitelistRefRewards.length; i++) {
            address receiver = _referrer[cursor];

            if (cursor != receiver) {
                if (_refCount[receiver] > i) {
                    remain = remain.sub(_whitelistRefRewards[i]);
                }
            } else {
                reward = reward.add(remain);
                break;
            }

            cursor = _referrer[cursor];
        }

        return reward;
    }

    modifier onlyMinter() {
        require(_minter[msg.sender]);
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minter[account];
    }

    function setMinterState(address account, bool state) external onlyOwner {
        _minter[account] = state;
        emit MinterChanged(account, state);
    }

    function mint(address to, uint256 value) public onlyMinter returns (bool) {
        _mint(to, value);

        return true;
    }

    function _mint(address account, uint256 value) internal {
        require(_totalSupply.add(value) <= _cap);

        require(account != address(0));

        _totalSupply       = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);

        emit Mint(account, value);
        emit Transfer(address(0), account, value);
    }
}