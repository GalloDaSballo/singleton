// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import "src/ERC20.sol";
import "src/MockOracle.sol";
import "src/Singleton.sol";
import "src/CollateralModule.sol";
import "src/LiquidationModule.sol";

abstract contract Setup is BaseSetup {
    Singleton singleton;

    ERC20 collateral;
    ERC20 debt;
    MockOracle mockOracle;
    

    CollateralModule collateralModule;
    LiquidationModule liquidationModule;
    MintModule mintModule;

    function setup() internal virtual override {
        collateral = new ERC20("Collateral", "COLL");
        debt = new ERC20("Debt", "DEBT");
        
        mintModule = new MintModule();
        liquidationModule = new LiquidationModule();
        collateralModule = new CollateralModule();
        singleton = new Singleton(collateral, debt, mockOracle, address(collateralModule), address(mintModule), address(liquidationModule));

        debt.rely(address(singleton));
        
        collateral.mint(address(this), 1e18);
        collateral.approve(address(singleton), type(uint256).max);
    }
}
