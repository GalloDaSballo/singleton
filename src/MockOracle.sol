// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {SharedStorage} from "./SharedStorage.sol";
import {ERC20} from "./ERC20.sol";

// External dependency
// We don't delegate to this
contract MockOracle {
    // TODO: Allow for reverts, for fun
    uint256 public getPrice;
    uint256 public lastUpdated;
    uint256 public constant DECIMALS = 18;

    function setPrice(uint256 amt) external {
        getPrice = amt;
        lastUpdated = block.timestamp; // TODO: Allow manipulation
    }
}
