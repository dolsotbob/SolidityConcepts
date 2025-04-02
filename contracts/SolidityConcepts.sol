// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolidityConcepts {
    uint256 public constant FIXED_VALUE = 100;
    uint256 public value = 50;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function checkValue(uint256 _value) public pure returns (string memory) {
        if (_value > 100) {
            return "Value is greater than 100";
        } else if (_value == 100) {
            return "Value is exactly 100";
        } else {
            return "Value is less than 100";
        }
    }

    function sumUpTo(uint256 _number) public pure returns (uint256) {
        uint256 sum = 0;

        for (uint256 i = 1; i <= _number; i++) {
            unchecked {
                sum += i;
            }
        }
        return sum;
    }

    event ValueChanged(uint256 oldValue, uint256 newValue);

    function updateValue(uint256 newValue) public onlyOwner {
        uint256 oldValue = value; //oldValue는 function 안에 있는 로컬 변수이고 로컬에 저장됨
        value = newValue;
        emit ValueChanged(oldValue, newValue);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _; // onlyOwner가 들어간 함수의 실제 코드 실행(여기선 아래 함수)
    }

    function ownerFunction() public view onlyOwner returns (string memory) {
        return "Hello, Owner!";
    }

    receive() external payable {}

    function sendEther(address payable _to) public payable {
        require(msg.value > 0, "Must send ether");
        (bool success, ) = _to.call{value: msg.value}("");
        require(success, "Failed to send ether");
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 실무에서는 정말로 받아지는지 반드시 확인 하고 넘어갸야 함(테스크 많이 해볼수록 좋음)
    //call 쓰면 require 쓴다
    function withDraw() public onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Failed to withdraw");
        // require(address(this).balance > 0, "No funds to withdraw");
        // payable(owner).transfer(address(this).balance);
    }
}
