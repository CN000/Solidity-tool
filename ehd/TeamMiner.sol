pragma solidity 0.4.8;

contract MortageSystem {
    function totalMortgage() public constant returns (uint256) {}
    function mortgageOf(address owner) public constant returns (uint256) {}
}

// 0x0000000000000000000000000000000000000082
contract TeamMiner {
    MortageSystem mortageContract;

    // 质押合约地址
    address public mortgageAddress     = 0x0000000000000000000000000000000000000081;

    // 基金会地址
    address public fundAddress         = 0x246229BF5719c05133d5f52De39817BceB829a06;

    // 最大区块奖励
    uint256 public maxBlockReward      = 168*(10**18);

    // 最少质押数目
    uint256 private minMortgagedAmount = 1000;

    // Miner Address List
    address[] public minerList;

    struct Block {
       uint256   blockNumber;
       address   miner;
       uint256   minerMortgagedAmount;
       address[] minerList;
       bool      isRewardProcessed;
    }

    // Index of a person is its ID.
    Block[] blocks;

    // constructor () public {}

    function () external payable{ }

    function clean() public returns(bool) {
        // Automatic Remove Miner
        for(uint256 i=0; i<minerList.length; i++) {
            if( getMortgageAmount(minerList[i]) < minMortgagedAmount) {
                delete minerList[i];
            }
        }

        return true;
    }

    // register address to miner list
    function register(address account) public returns (bool) {
        minerList.push(account);
        return true;
    }

    // remove address from miner list
    // https://ethereum.stackexchange.com/questions/56281/how-to-check-if-an-array-key-exists
    function unregister(address account) public returns (bool) {
       for(uint256 i=0; i < minerList.length; i++) {
           if( minerList[i] == account ) {
               delete minerList[i];
           }
       }

       return true;
    }

    // 获取质押合约总数
    function getTotalMortgageAmount() public returns (uint256) {
        mortageContract = MortageSystem(mortgageAddress);
        return mortageContract.totalMortgage();
        // return mortgageAddress.call(bytes4(keccak256("totalMortgage()")));
    }

    // 获取质押数量
    function getMortgageAmount(address account) public returns (uint256) {
        mortageContract = MortageSystem(mortgageAddress);
        return mortageContract.mortgageOf(account);

        // return mortgageAddress.call(bytes4(keccak256("mortgageOf(address)")), account);
    }

    // 处理每个区块奖励
    function processReward() public returns (bool) {
        address[] memory _minerList;
        address   miner;
        uint256   _fundReward;
        uint256   _avgRewardPerMiner;


        for(uint256 i=0; i<=blocks.length; i++) {
            if( blocks[i].isRewardProcessed == true ) {
               continue;
            }

            _fundReward = maxBlockReward/5;  // 基金会 20%

            miner       = blocks[i].miner;

            // 合作挖矿平分奖励
            _minerList         = blocks[i].minerList;
            _avgRewardPerMiner = ((maxBlockReward*2/5)/_minerList.length); // 平均合作挖矿奖励   40%
            for(uint256 j=0; j<_minerList.length; j++) {
               _minerList[j].send(_avgRewardPerMiner);
            }

            // 基金会地址
            //require(fundAddress.send(_fundReward), "Send FundReward");
            if (!fundAddress.send(_fundReward)){
                throw;
            }

            // 这个区块奖励已经处理结束
            blocks[i].isRewardProcessed = true;
        }

        return true;
    }

    // 获取矿工列表
    function getMinerList()  public returns (address[] memory){
        return minerList;
    }
}