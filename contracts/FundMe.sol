//SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) AddressToAmountFunded;
    address[] funders;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    function fund() public payable {
        uint256 minimumUSD = 50; //* 10**18;
        require(getConversionRate(msg.value) >= minimumUSD, "No sea tacano");
        AddressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer / 100000000);
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 price = getPrice();
        uint256 ethAmountInUsd = ((price * ethAmount) / 1) * 10**18;
        return ethAmountInUsd;
    }

    function getEntranceFee() public view returns (uint256) {
        //minimum usd
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        //uint256 precision = 1 * 10**18;
        return ((minimumUSD) / price);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            AddressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }

    function getAddressToAmountFunded(address _address)
        public
        view
        returns (uint256)
    {
        return AddressToAmountFunded[_address];
    }
}
