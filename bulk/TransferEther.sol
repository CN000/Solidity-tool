/*
  refer-by: https://ethereum.stackexchange.com/questions/15953/send-ethers-from-one-contract-to-another
*/
pragma solidity ^0.4.24;

contract TransferEtherTo {
    function getBalance() returns(uint){
        return address(this).balance;
    }

    //Empty payable fallback method just to receive some
    function() payable{}
}


pragma solidity ^0.4.24;

contract TransferEtherFrom{
    //Declaring an instance of TransferEtherTo contract
    TransferEtherTo instance;

    constructor(){
        //Initializing TransferEtherTo contract
        instance = new TransferEtherTo();
    }

    //Returns balance of TransferEtherFrom contract
    function getBalance() returns(uint){
        return address(this).balance;
    }

    //Returns balance of TransferEtherTo contract
    function getBalanceInstance() returns(uint){
        return instance.getBalance();
    }

    //Transfers ether to other contract
    function transfer() payable{
        address(instance).send(msg.value);
    }

    //Fallback function to receive and transfer Ether
    function() payable{
        address(instance).send(msg.value);
    }
}