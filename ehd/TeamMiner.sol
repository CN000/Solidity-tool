pragma solidity ^0.4.24;

contract TeamMiner
{
    address public mortgageAddress = 0x0000000000000000000000000000000000000081;

    // Miner Address List
    mapping(address => bool) public minerList;

    // Support to Receive EHD
    constructor() public payable{}

    //register address to miner list
    function register(address coinbase) returns(uint) return(bool) {
        // TODO
    }

    //remove address from miner list
    function unregister(address coinbase) returns(uint) {
        // Todo
    }

    function upload(address coinbase, string ip, uint256 totalDiskSpace, uint256 totalPlotedDiskSpace, uint256 blockNumber, uint256 mortgageAmount) returns(bool) {
        // TODO
    }

    function _isAllowedToRegister(address coinbase) returns(bool) {
        // TODO
    }

    // Total Mortgage Amount in System
    function getTotalMortgageAmount() return(uint256){
        // TODO
    }

    function getMortgageAmount(address account) return(uint256){
        // TODO

    }
}