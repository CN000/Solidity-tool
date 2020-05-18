pragma solidity ^0.5.7;


library SafeMath256 {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }
}

interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract BatchTransferEtherAndToken {
    using SafeMath256 for uint256;

    IERC20 TOKEN = IERC20(0x0eACD9F66941D7d1885d5854F5b92575CE9eD5fd);

    address[] public MemberAddresses = [0xC579645b795776ed6F516D782F0c6fF7F480Aca0, 0x5958C4b224deF7641d287a861af3a95D618E3598, 0x62941a3CE45f72A3Df740A4d167A3Dcd54769360, 0xfeB79997Ac8fa9587B2D89e4a03fFFbE7B74d0Df, 0x54269B80eDA95C0144dB00b30AE5fdFC2BeD135C, 0x3bf4C6De05Fe750b2Ff3fe197562531b9F504438, 0x7c02dcC3cd3692965eb1661F753cBa73c3a97c45];


    function start() public {
//        for (uint256 i = 0; i < MemberAddresses.length; i++) {
//            TOKEN.transferFrom(msg.sender, MemberAddresses[i], 1361400);
//        }
    }
}

["0xC579645b795776ed6F516D782F0c6fF7F480Aca0", "0x5958C4b224deF7641d287a861af3a95D618E3598", "0x62941a3CE45f72A3Df740A4d167A3Dcd54769360", "0xfeB79997Ac8fa9587B2D89e4a03fFFbE7B74d0Df", "0x54269B80eDA95C0144dB00b30AE5fdFC2BeD135C", "0x3bf4C6De05Fe750b2Ff3fe197562531b9F504438", "0x7c02dcC3cd3692965eb1661F753cBa73c3a97c45"]
