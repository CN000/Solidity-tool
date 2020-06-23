pragma solidity 0.4.8;

contract TeamMiner {
    address public mortgageAddress = 0x0000000000000000000000000000000000000081;

    uint maxReward = 167;

    // 最低质押EHD数目
    uint256 private minMortgagedAmount = 100;

    struct Block {
        uint256   blockNumber;
        address   miner;
        uint256   minerMortgagedAmount;
        address[] minerList;
        bool      isRewardProcessed;
    }

    // Index of a person is its ID.
    Block[] blocks;

    // Miner Address List
    mapping(address => bool) private minerList;

    // Support to Receive EHD
    constructor() public payable {
        // 自动检查规范的矿工列表 minerList 决定移除列表
    }

    // register address to miner list
    function register(address miner) public returns (bool) {
        // 检查质押额度  达到  10？？？EHD , 才可以加入合作挖矿队列
        if(!_isAllowedToRegister(account)) {
            minerList[account] = true;
        }

        // TODO
        return true;
    }

    //remove address from miner list
    //  https://ethereum.stackexchange.com/questions/56281/how-to-check-if-an-array-key-exists
    function unregister(address miner) public returns (bool) {
        if(1){ }
        return true;
    }

    // 上传矿机的相关信息
    function upload(uint256 blockNumber, address miner, string ip, uint256 totalDiskSpace, uint256 totalPlotedDiskSpace, uint256 mortgageAmount) public returns(bool) {
        // TODO
        return true;
    }

    //  检查是否允许注册为矿机商
    function _isAllowedToRegister(address account) payable public returns (bool) {
        // TODO
        return true;
    }

    // Total Mortgage Amount in System
    function getTotalMortgageAmount() public returns (uint256) {
        // TODO
        return 1415;
    }

    function getMortgageAmount(address account) public returns (uint256) {
        // TODO
        return 1314;
    }

    // https://ethereum.stackexchange.com/questions/17312/solidity-can-you-return-dynamic-arrays-in-a-function
    function getMinerList() public returns () {
        return minerList;
    }

    function processReward()
    {
        for(uint256 i =0; i <= blocks.length; i++) {
            if(blocks.)

        }
    }
}