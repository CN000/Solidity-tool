pragma solidity 0.4.24;


contract Proxy {

  function implementation() public view returns (address);

  function version() public view returns (string);

  function () payable public {
    address _impl = implementation();
    require(_impl != address(0));

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
}

pragma solidity 0.4.24;


contract UpgradeabilityProxy is Proxy {

  event Upgraded(address indexed implementation, string version);


  bytes32 private constant implementationPosition = keccak256("bulksender.app.proxy.implementation");


  string internal _version;

  /**
   * @dev Constructor function
   */
  constructor() public {}


  /**
    * @dev Tells the version name of the current implementation
    * @return string representing the name of the current version
    */
    function version() public view returns (string) {
        return _version;
    }

  /**
   * @dev Tells the address of the current implementation
   * @return address of the current implementation
   */
  function implementation() public view returns (address impl) {
    bytes32 position = implementationPosition;
    assembly {
      impl := sload(position)
    }
  }

  /**
   * @dev Sets the address of the current implementation
   * @param _newImplementation address representing the new implementation to be set
   */
  function _setImplementation(address _newImplementation) internal {
    bytes32 position = implementationPosition;
    assembly {
      sstore(position, _newImplementation)
    }
  }

  /**
   * @dev Upgrades the implementation address
   * @param _newImplementation representing the address of the new implementation to be set
   */
  function _upgradeTo(address _newImplementation, string _newVersion) internal {
    address currentImplementation = implementation();
    require(currentImplementation != _newImplementation);
    _setImplementation(_newImplementation);
    _version = _newVersion;
    emit Upgraded( _newImplementation, _newVersion);
  }
}


pragma solidity 0.4.24;
/**
 * @title BulksenderProxy
 * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
 */
contract BulksenderProxy is UpgradeabilityProxy {
  /**
  * @dev Event to show ownership has been transferred
  * @param previousOwner representing the address of the previous owner
  * @param newOwner representing the address of the new owner
  */
  event ProxyOwnershipTransferred(address previousOwner, address newOwner);

  // Storage position of the owner of the contract
  bytes32 private constant proxyOwnerPosition = keccak256("bulksender.app.proxy.owner");

  /**
  * @dev the constructor sets the original owner of the contract to the sender account.
  */
  constructor(address _implementation, string _version) public {
    _setUpgradeabilityOwner(msg.sender);
    _upgradeTo(_implementation, _version);
  }

  /**
  * @dev Throws if called by any account other than the owner.
  */
  modifier onlyProxyOwner() {
    require(msg.sender == proxyOwner());
    _;
  }

  /**
   * @dev Tells the address of the owner
   * @return the address of the owner
   */
  function proxyOwner() public view returns (address owner) {
    bytes32 position = proxyOwnerPosition;
    assembly {
      owner := sload(position)
    }
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferProxyOwnership(address _newOwner) public onlyProxyOwner {
    require(_newOwner != address(0));
    _setUpgradeabilityOwner(_newOwner);
    emit ProxyOwnershipTransferred(proxyOwner(), _newOwner);
  }

  /**
   * @dev Allows the proxy owner to upgrade the current version of the proxy.
   * @param _implementation representing the address of the new implementation to be set.
   */
  function upgradeTo(address _implementation, string _newVersion) public onlyProxyOwner {
    _upgradeTo(_implementation, _newVersion);
  }

  /**
   * @dev Allows the proxy owner to upgrade the current version of the proxy and call the new implementation
   * to initialize whatever is needed through a low level call.
   * @param _implementation representing the address of the new implementation to be set.
   * @param _data represents the msg.data to bet sent in the low level call. This parameter may include the function
   * signature of the implementation to be called with the needed payload
   */
  function upgradeToAndCall(address _implementation, string _newVersion, bytes _data) payable public onlyProxyOwner {
    _upgradeTo(_implementation, _newVersion);
    require(address(this).call.value(msg.value)(_data));
  }

  /*
   * @dev Sets the address of the owner
   */
  function _setUpgradeabilityOwner(address _newProxyOwner) internal {
    bytes32 position = proxyOwnerPosition;
    assembly {
      sstore(position, _newProxyOwner)
    }
  }
}