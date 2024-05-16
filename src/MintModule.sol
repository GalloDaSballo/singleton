// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {ERC20} from "./ERC20.sol";

contract MintModule is SharedStorage {
    // Mint to user
    function mint(ERC20 debt, uint256 amt) external {
        liabilities[msg.sender] += amt;

        debt.mint(msg.sender, amt);
    }

    // Burn from user to repay
    function burn(ERC20 debt, uint256 amt) external {
        liabilities[msg.sender] -= amt;

        debt.burn(msg.sender, amt);
    }
}
