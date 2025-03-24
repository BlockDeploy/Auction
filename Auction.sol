// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

contract Auction {
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public startPrice;      // Auction starting price
    uint256 public startTime;       // Auction start time
    uint256 public duration;        // Auction duration (in seconds)
    uint256 public priceDecrement;  // Price decrease per second
    bool public ended;              // Whether the auction has ended

    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address winner, uint256 finalPrice);
    event AuctionStarted(uint256 startPrice, uint256 duration);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier auctionActive() {
        require(!ended, "Auction has ended");
        require(block.timestamp < startTime + duration, "Auction time expired");
        _;
    }

    constructor(uint256 _startPrice, uint256 _duration, uint256 _priceDecrement) {
        require(_startPrice > 0, "Start price must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");
        require(_priceDecrement > 0, "Price decrement must be greater than 0");

        owner = msg.sender;
        startPrice = _startPrice;
        duration = _duration;
        priceDecrement = _priceDecrement;
        startTime = block.timestamp;
        ended = false;

        emit AuctionStarted(_startPrice, _duration);
    }

    // Current price based on time
    function currentPrice() public view returns (uint256) {
        if (block.timestamp >= startTime + duration || ended) {
            return 0;
        }
        uint256 timeElapsed = block.timestamp - startTime;
        uint256 priceReduction = timeElapsed * priceDecrement;
        if (priceReduction >= startPrice) {
            return 0;
        }
        return startPrice - priceReduction;
    }

    // Place a bid
    function bid() external payable auctionActive {
        uint256 current = currentPrice();
        require(msg.value >= current, "Bid too low");
        require(msg.sender != owner, "Owner cannot bid");

        if (highestBidder != address(0)) {
            // Refund the previous bid
            payable(highestBidder).transfer(highestBid);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        ended = true; // Auction ends with the first successful bid (Dutch auction style)

        emit BidPlaced(msg.sender, msg.value);
        emit AuctionEnded(msg.sender, msg.value);
    }

    // End the auction manually by the owner (if no bids)
    function endAuction() external onlyOwner {
        require(!ended, "Auction already ended");
        require(block.timestamp >= startTime + duration, "Auction still active");

        ended = true;
        if (highestBidder == address(0)) {
            // If no bids, the owner takes the contract balance (if any)
            if (address(this).balance > 0) {
                payable(owner).transfer(address(this).balance);
            }
        } else {
            // If there was a bid, the owner receives the winning amount
            payable(owner).transfer(highestBid);
        }

        emit AuctionEnded(highestBidder, highestBid);
    }

    // Get auction information
    function getAuctionInfo() external view returns (
        address currentHighestBidder,
        uint256 currentHighestBid,
        uint256 currentAuctionPrice,
        uint256 auctionEndTime,
        bool isEnded
    ) {
        return (
            highestBidder,
            highestBid,
            currentPrice(),
            startTime + duration,
            ended
        );
    }

    receive() external payable {}
}