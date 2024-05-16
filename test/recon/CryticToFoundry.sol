// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import "forge-std/console2.sol";

contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();

        targetContract(address(singleton));
    }

    function test_wireup() public {
        // We have deployed the Mint Module
        // The storage is actually tracked in singleton

        // For unit tests we can directly test on the CollateralModule

        assertEq(address(singleton.collateral()), address(collateral), "Match");
        assertEq(address(singleton.mintModule()), address(mintModule), "Match");
    }

    function test_mintUnit() public {
        // Approve the token
        // Deposit
        // Ensure balance changes

        collateral.mint(address(this), 1e18);
        collateral.approve(address(mintModule), 1e18);
        collateralModule.deposit(collateral, 1e18);

        assertTrue(collateralModule.deposits(address(this)) == 1e18);
    }

    function test_basicLiquidationModule(uint128 price, uint128 collateral, uint256 debt) public {
        uint256 treshold = 7_500;
        uint256 decimals = 18;

        try liquidationModule.canLiquidateGivenCollateralAndDebt(price, decimals, treshold, collateral, debt) {

        } catch {
            assertTrue(false, "Should never revert");
        }
    }

    function test_canAlwaysLiquidate(uint128 price, uint128 collateral, uint256 multiplier) public {
        uint256 treshold = 7_500;
        uint256 decimals = 18;

        multiplier %= 25;

        uint256 debt = uint256(collateral) * (75 + multiplier) / 100;

        assertTrue(liquidationModule.canLiquidateGivenCollateralAndDebt(price, decimals, treshold, collateral, debt), "Can always liquidate");
    }
}
