//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Wallet {

    address payable public owner;
    mapping(address => uint256) public contributions;
    error insufficientFunds();

    event depositEther(string _message);
    event sentEther(string _message);

    constructor() {
        owner = payable(msg.sender);
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function sendEther(address payable _to, uint256 _amount) public onlyOwner payable{
       if(_amount <= 0) {
           revert insufficientFunds();
       }
        contributions[_to] += _amount;

        emit sentEther("Successful");
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = payable(msg.sender);

        emit depositEther("Successful");
    }

}