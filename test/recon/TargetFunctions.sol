
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {

    function singleton_burn(uint256 amt) public {
      singleton.burn(amt);
    }

    function singleton_canLiquidate(address target) public {
      singleton.canLiquidate(target);
    }

    function singleton_deposit(uint256 amt) public {
      singleton.deposit(amt);
    }

    function singleton_mint(uint256 amt) public {
      // I can never make myself liquidatable on purpose
      singleton.mint(amt);

      t(!singleton.canLiquidate(address(this)), "singleton_mint - Can never make yourself liquidatable on purpose");
    }

    function singleton_withdraw(uint256 amt) public {
      singleton.withdraw(amt);
      t(!singleton.canLiquidate(address(this)), "singleton_withdraw - Can never make yourself liquidatable on purpose");
    }

    function collateral_mint(address usr, uint256 wad) public {
      collateral.mint(address(this), wad); // NOTE: Actor
    }

    // == ORACLE == //

    function mockOracle_setPrice(uint256 amt) public {
      mockOracle.setPrice(amt);
    }
}