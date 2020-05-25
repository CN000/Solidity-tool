pragma solidity ^0.4.24;

/**
    proxy
 */
contract MultiSender {
    function multisendToken(address, address[], uint[]) payable public returns(bool);
}

contract Proxy {

    // This contract keeps all Ether sent to it with no way
    // to get it back.
    constructor() public payable{}

    address public bulkSendAddress = 0x3f52D5704112cdC4D02B1a61E7Baf4034b3d80cB;

    MultiSender multiSendContract;

    uint256 public txFee = 0.01 ether; // in wei

    function setBulkSendAddress(address _bulkSendAddress) payable public returns(bool success){
        bulkSendAddress = _bulkSendAddress;
        return true;
    }

    /**
        set tax fee
      */
    function setTxFee(uint256 fee) payable public returns(bool success){
        txFee = fee;
        return true;
    }

    /**
        bulkSend
     */
    function bulkSend(address _tokenAddress, address[] _to, uint[] _value) payable public returns(bool success) {
        multiSendContract = MultiSender(bulkSendAddress);
        multiSendContract.multisendToken.value(txFee)(_tokenAddress, _to, _value);
        return true;
    }
}