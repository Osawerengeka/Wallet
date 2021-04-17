// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Wallet {

    string constant nameToken = "WalletToken";
    string constant symbolToken = "WT";
    uint8 constant decimalsToken = 2;
    uint totalSupplyToken;
    
    mapping (address => uint) balancesToken;
    
    mapping (address => mapping(address => uint)) allowedToken;

    address payable comisionAddress;
    mapping (address => uint) public balances;
    uint public comision = 5;

    event Deposit(address indexed _from, address person, uint _value) ;
    event Comision(address indexed _from, address person, uint _value);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _from, address indexed _to, uint _value);
    
    
    function sendEth(address payable recipient, address payable sender, uint256 num) public payable{
        // if (balances[sender] >= num) {
            balances[recipient] += num - comision;
            balances[sender] -= num;
            balances[comisionAddress] += comision;
            // comisionAddress.transfer(comision);
            // recipient.transfer(num - comision);
            emit Deposit(sender, recipient, msg.value);
            emit Comision(sender, recipient, comision);
        
    }
    
    function addEth(address payable owner) public payable {
        balances[owner] += 1;
        // owner.transfer(1); 
    }
    
    function balanceOf(address owner) public view returns(uint){
        return balances[owner];
    }
    
    function changeComision(uint num) public {
        comision = num;
    }
    
    function mintToken(address to, uint value) public{
        balances[to] += value;
        totalSupplyToken += value;
    }
    
    function balanceOfToken(address owner) public view returns(uint){
        return balances[owner];
    }
    
    function allowanceToken(address _owner, address _spender) public view returns(uint){
        return allowedToken[_owner][_spender];
    }
    
    function transferToken(address _from, address _to, uint _value) public {
        require(balances[msg.sender] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
    }
    function transferFromToken(address _from, address _to, uint _value) public {
        require(balances[_from] >= _value && allowedToken[_from][msg.sender] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        allowedToken[_from][_to] -=_value;
        emit Transfer(_from, _to, _value);
    }
    
    function approveToken(address _spender, uint _value) public{
        allowedToken[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }
}