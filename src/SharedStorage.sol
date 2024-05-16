// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// NOTE: Every contract must inherit from this
abstract contract SharedStorage {
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public liabilities;
}
