//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SplitRoyalty {
    event RoyaltyReceived(address indexed from, uint256 amount, uint256 indexed uid);
    event RoyaltyPaidNative(address indexed to, uint256 amount, uint256 indexed uid);
    event RoyaltyPaidERC20(address indexed token, address indexed to, uint256 amount, uint256 indexed uid);

    struct Royalty {
        address payable royaltyAddress;
        uint256 royalty;
    }

    Royalty[] public owners;

    constructor(address payable[] memory _publishers, uint256[] memory _royaltyPercentage) {
        uint totalPercentage = 0;
        for (uint i = 0; i < _publishers.length; i++) {
            Royalty memory newRoyalty = Royalty(_publishers[i], _royaltyPercentage[i]);
            totalPercentage = totalPercentage + newRoyalty.royalty;
            owners.push(newRoyalty);
        }
        require(totalPercentage == 10000, "Total Percentage must equal 10,000");
    }

    function _distributeRoyalty(uint256 loopIndex, uint256 _amountReceived, uint256 _uid) internal {
        Royalty storage royalty = owners[loopIndex];
        uint256 percentage = royalty.royalty;
        address payable addressToPay = royalty.royaltyAddress;
        uint256 amountToPay = (percentage * _amountReceived) / 10000;
        bool wasSentRoyalty = addressToPay.send(amountToPay);
        require(wasSentRoyalty, "Failed to send Ether");
        emit RoyaltyPaidNative(addressToPay, amountToPay, _uid);
    }
    function _distributeRoyaltyERC20(
        address _tokenAddress,
        uint256 loopIndex,
        uint256 _amountReceived,
        uint256 _uid
    ) internal {
        Royalty storage royalty = owners[loopIndex];
        uint256 percentage = royalty.royalty;
        address payable addressToPay = royalty.royaltyAddress;
        uint256 amountToPay = (percentage * _amountReceived) / 10000;
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(addressToPay, amountToPay);
        emit RoyaltyPaidERC20(_tokenAddress, addressToPay, amountToPay, _uid);
    }

    function receiveRoyalty(uint256 amountReceived, uint256 uid) public payable {
        require(msg.value >= amountReceived);
        emit RoyaltyReceived(msg.sender, amountReceived, uid);
        for (uint i = 0; i < owners.length; i++) {
            _distributeRoyalty(i, amountReceived, uid);
        }
    }
    function distributeERC20RoyaltyTokenBalence(address _tokenAddress) external {
        IERC20 token = IERC20(_tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        require(balance > 0, "No balance to distribute");
        for (uint i = 0; i < owners.length; i++) {
            _distributeRoyaltyERC20(_tokenAddress, i, balance, 0);
        }
    }
    receive() external payable {
        receiveRoyalty(msg.value, 0);
    }
    fallback() external payable {
        receiveRoyalty(msg.value, 0);
    }
}
