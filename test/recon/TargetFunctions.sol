
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {


  function invariant_checkSolvent() public returns (bool) {
    return _after.is_solvent == true;
  }
  
  // function invariant_checkSolvent() public returns (bool) {
  //   return _after.is_solvent == true;
  // }

  // function _checkNeverInsolvent() internal {
  //   t(!singleton.canLiquidate(address(this)), "singleton_mint - Can never make yourself liquidatable on purpose");
  // }

    function singleton_burn(uint256 amt) checkBeforeAfter public {
      singleton.burn(amt);
    }

    function singleton_canLiquidate(address target) checkBeforeAfter public {
      singleton.canLiquidate(target);
    }

    function singleton_deposit(uint256 amt) checkBeforeAfter public {
      singleton.deposit(amt);
    }

    function singleton_mint(uint256 amt) checkBeforeAfter public {
      // I can never make myself liquidatable on purpose
      singleton.mint(amt);

      // _checkNeverInsolvent();
    }

    function singleton_withdraw(uint256 amt) checkBeforeAfter public {
      singleton.withdraw(amt);

      // _checkNeverInsolvent();
    }

    function collateral_mint(address usr, uint256 wad) checkBeforeAfter public {
      collateral.mint(address(this), wad); // NOTE: Actor
    }

    // == ORACLE == //

    function mockOracle_setPrice(uint256 amt) checkBeforeAfter public {
      mockOracle.setPrice(amt);
    }
}