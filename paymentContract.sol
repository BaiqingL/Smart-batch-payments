pragma solidity ^0.6.2;

// Cryptographic features taken from OpenZepplin libraries and modified to fit contract
// The contract accepts multiple deposits from different accounts but there will only be
// one owner designated as the empolyer.
//
// The employer will need to sign a number n corresponding to how many payments needs to be done.

contract paymentChannel{

    address payable owner;
    address payable payee;
    uint64 public contractTime;
    uint256 amountToPay;
    uint256 amountPaid;
    uint256 public payAmount;
    
    constructor() public {
        owner = msg.sender;
        amountPaid = 0;
        payAmount = 10000000000000000; // 0.01 ETH per payment interval
        contractTime = uint64(block.timestamp) + 31556926;
    }
    
    receive() 
        external
        payable
    {}
    
    fallback() 
        external
        payable
    {}
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyPayee {
        require(msg.sender == payee);
        _;
    }
    
    modifier expiredContract {
        require(block.timestamp >= contractTime);
        _;
    }
    
    // OpenZepplin SafeMath.sol
    function safeAdd(uint64 a, uint64 b) internal pure returns (uint64) {
        uint64 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    
    function setPayee(
        address payable _payee
    ) 
        public
        onlyOwner
    {
        payee = _payee;
    }

    function payDay(
        uint32 pay,
        bytes memory sig
    ) 
        public
        payable
        onlyPayee
    {
        require (ecverify(pay, sig) == true);
        amountToPay = pay * payAmount - amountPaid;
        payee.transfer(amountToPay);
        amountPaid += amountToPay;
    }

    function updatePayAmount(uint256 pay) public onlyOwner {
        payAmount = pay;
    }
    
    function extendContract(uint64 timeToAdd) public onlyOwner {
        contractTime = safeAdd(contractTime, timeToAdd);
    }
    
    function returnToOwner() public payable onlyOwner expiredContract {
        selfdestruct(owner);
    }

    function ecrecovery(
        bytes32 hash,
        bytes memory sig
    ) 
        internal
        pure
        returns (address) 
    {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (sig.length != 65) {
        return address(0);
    }

    assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := and(mload(add(sig, 65)), 255)
    }

    if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
        return address(0);
    }

    if (v < 27) {
        v += 27;
    }

    if (v != 27 && v != 28) {
        return address(0);
    }
    
        return ecrecover(hash, v, r, s);
    }
    
    function uintToString(
        uint v
    )
        pure
        internal
        returns (string memory)
    {
        uint w = v;
        bytes32 x;
        if (v == 0) {
            x = "0";
        } else {
            while (w > 0) {
                x = bytes32(uint(x) / (2 ** 8));
                x |= bytes32(((w % 10) + 48) * 2 ** (8 * 31));
                w /= 10;
            }
        }

        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }

        bytes memory resultBytes = new bytes(charCount);
        uint j = 0;
        for (j = 0; j < charCount; j++) {
            resultBytes[j] = bytesString[j];
        }
        return string(resultBytes);
    }

    function hash_msg(
        string memory _msg
    ) 
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", uintToString(bytes(_msg).length), _msg));
    }

    function ecverify(
        uint32 _msg,
        bytes memory sig
    )
        internal
        returns (bool) 
    {
        if (owner == ecrecovery(hash_msg(uintToString(_msg)), sig)){
            amountPaid += _msg;
            return true;
        } else {
            return false;
        }
    }
    
}
