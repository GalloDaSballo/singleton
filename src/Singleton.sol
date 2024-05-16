// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "./ERC20.sol";
import {SharedStorage} from "./SharedStorage.sol";
import {CollateralModule} from "./CollateralModule.sol";
import {LiquidationModule} from "./LiquidationModule.sol";
import {MintModule} from "./MintModule.sol";
import {MockOracle} from "./MockOracle.sol";

contract Singleton is SharedStorage {
    // STORAGE CLASHES

    // functionality
    // delegate call

    ERC20 public immutable collateral;
    ERC20 public immutable debt;
    MockOracle public immutable oracle;
    uint256 public constant thresholdBPS = 7_500;

    // == MODULES == //
    address public immutable collateralModule;
    address public immutable mintModule;
    address public immutable liquidationModule;

    // == END MODULES == //

    constructor(ERC20 _collateral, ERC20 _debt, MockOracle _oracle,address _collateralModule, address _mintModule, address _liquidationModule) {
        collateral = _collateral;
        debt = _debt;

        oracle = _oracle;

        collateralModule = _collateralModule;
        mintModule = _mintModule;
        liquidationModule = _liquidationModule;
    }


    // Deposit Coll
    function deposit(uint256 amt) external {
        _executeModule(collateralModule, abi.encodeCall(CollateralModule.deposit, (collateral, amt)));
    }

    // Withdraw Coll
    function withdraw(uint256 amt) external {
        _executeModule(collateralModule, abi.encodeCall(CollateralModule.withdraw, (collateral, amt)));
    }

    function mint(uint256 amt) external {
        _executeModule(mintModule, abi.encodeCall(MintModule.mint, (debt, amt)));
    }

    function burn(uint256 amt) external {
        _executeModule(mintModule, abi.encodeCall(MintModule.burn, (debt, amt)));
    }

    // Check for liquidations
    function canLiquidate(address target) external returns (bool) {
        bytes memory returnData = _executeModule(liquidationModule, abi.encodeCall(LiquidationModule.canLiquidate, (oracle, thresholdBPS, target)));
        return abi.decode(returnData, (bool));
    }

    // Credito to: https://github.com/Tapioca-DAO/Tapioca-bar/blob/b1a30b07ec1fd2626a0256f0393edac1e5055ebd/contracts/markets/bigBang/BigBang.sol#L381
    function _executeModule(address module, bytes memory _data) private returns (bytes memory returnData) {
        bool success = true;

        (success, returnData) = module.delegatecall(_data);
        if (!success) {
            revert("An error occured");
        }
    }
}
