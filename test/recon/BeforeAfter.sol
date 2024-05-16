// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Setup} from "./Setup.sol";

// ghost variables for tracking state variable values before and after function calls
abstract contract BeforeAfter is Setup {
  struct Vars {
      bool is_solvent;
  }

  Vars internal _before;
  Vars internal _after;

  modifier checkBeforeAfter() {
    __before();

    _;

    __after();
  }

  function __before() internal {
    _before.is_solvent = !singleton.canLiquidate(address(this));
  }

  function __after() internal {
    _after.is_solvent = !singleton.canLiquidate(address(this));
  }
}
