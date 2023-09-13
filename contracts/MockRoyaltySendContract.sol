//SPDX-License-Identifier: Unlicense
pragma solidity ^ 0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockRoyaltySendContract { 
	using Address for address;

  function sendRoyaltyTest(address sendTo, uint256 amountToPay) external payable {	  
		console.log("msg.value ", msg.value);
		console.log("amountToPay ", amountToPay);
	  	require(msg.value >= amountToPay);	
    	address payable addressToPay = payable(sendTo);
		console.log("Sending Now");
		if(sendTo.isContract()){
		console.log("Contract");
		Address.sendValue(addressToPay, msg.value);
		}
  } 
}