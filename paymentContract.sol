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
    uint256 nonce;
    uint256 public payAmount;
    
    constructor() public {
        owner = msg.sender;
        payee = msg.sender;
        nonce = 0;
        payAmount = 10000000000000000; // 0.01 ETH per payment interval
        contractTime = uint64(block.timestamp) + 31556926; // 1 year contract time
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
    
    // Modified slightly from OpenZepplin SafeMath
    function safeAdd(
        uint64 a, 
        uint64 b
    ) 
        internal 
        pure 
        returns (uint64) 
    {
        uint64 c = a + b;
        require(c >= a);
        return c;
    }
    
    function safeSub(
        uint256 a, 
        uint256 b
    ) 
        internal 
        pure 
        returns (uint256) 
    {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }
    
    function safeMul(
        uint256 a, 
        uint256 b
    ) 
        internal 
        pure 
        returns (uint256) 
    {
        uint256 c = a * b;
        require(c > a);

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
        amountToPay = safeSub(pay * payAmount, safeMul(nonce , payAmount));
        payee.transfer(amountToPay);
        nonce += pay;
    }

    function updatePayAmount(
        uint256 pay
    ) 
        public 
        onlyOwner
    {
        payAmount = pay;
    }
    
    function extendContract(
        uint64 timeToAdd
    ) 
        public 
        onlyOwner
    {
        contractTime = safeAdd(contractTime, timeToAdd);
    }
    
    function returnToOwner() 
        public 
        payable 
        onlyOwner 
        expiredContract 
    {
        selfdestruct(owner);
    }
    
    function giveAllToPayee()
        public
        payable
        onlyOwner
        expiredContract
    {
        selfdestruct(payee);
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
        uint _base
    )
        internal
        pure
        returns (string memory) 
    {
        bytes memory _tmp = new bytes(32);
        uint i;
        for(i = 0;_base > 0;i++) {
            _tmp[i] = byte(uint8((_base % 10) + 48));
            _base /= 10;
        }
        bytes memory _real = new bytes(i--);
        for(uint j = 0; j < _real.length; j++) {
            _real[j] = _tmp[i--];
        }
        return string(_real);
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
        view
        returns (bool) 
    {
        if (owner == ecrecovery(hash_msg(uintToString(_msg)), sig)){
            return true;
        } else {
            return false;
        }
    }
    
}
