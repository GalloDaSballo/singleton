// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {ERC20} from "./ERC20.sol";

contract CollateralModule is SharedStorage {
    // Deposit Coll
    function deposit(ERC20 collateral, uint256 amt) external {
        deposits[msg.sender] += amt;

        // Transfer the collateral amt
        // Credit that to the user
        collateral.transferFrom(msg.sender, address(this), amt);
    }

    // Withdraw Coll
    function withdraw(ERC20 collateral, uint256 amt) external {
        deposits[msg.sender] -= amt;

        collateral.transfer(msg.sender, amt);
    }
}
