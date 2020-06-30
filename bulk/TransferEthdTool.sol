pragma solidity ^0.4.24;

contract TransferEhdTool {
    address owner = 0x0;

    // contract support receiving EHD
    function () payable public {}

    // 添加payable, 支持在创建合约的时候, value往合约里面传EHD
    function TransferTool() public payable {
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    // Transfer different EHD values TO different users
    function bulkTransferEHD(address[] _to, uint256[] _value) public payable {
        for(uint256 i=0; i<_to.length; i++) {
              _to[i].transfer(_value[i]);
//            require(_to[i].call.value(_value[i])());
        }
    }

    // Transfer EHD Directly
    function transferEHD(address _to, uint256 _value) public payable {
        require(_to != address(0));
        require(msg.sender == owner, "msg.sender != owner");
        // _to.transfer(msg.value);
        require(_to.call.value(_value)());
    }

    function checkBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function destroy() public {
        require(msg.sender == owner);
        selfdestruct(msg.sender);
    }
}