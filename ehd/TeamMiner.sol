pragma solidity 0.4.8;


contract TeamMiner {

    address public mortgageAddress = 0x0000000000000000000000000000000000000081;

    // Miner Address List
    mapping(address => bool) private minerList;

    // 最低质押EHD数目
    uint256 private minMortgagedAmount = 100;

    // Support to Receive EHD
    constructor() public payable{}

    // register address to miner list
    function register(address account) public returns (bool) {
        // 检查质押额度  达到  10？？？EHD , 才可以加入合作挖矿队列
        if(!_isAllowedToRegister(account)) {
            minerList[account] = true;
        }

        // TODO
        return true;
    }

    //remove address from miner list
    //  https://ethereum.stackexchange.com/questions/56281/how-to-check-if-an-array-key-exists
    function unregister(address coinbase) public returns (bool) {
        if(1){
            
        }


        return true;
    }

    function upload(address coinbase, string ip, uint256 totalDiskSpace, uint256 totalPlotedDiskSpace, uint256 blockNumber, uint256 mortgageAmount) public returns(bool) {

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
}