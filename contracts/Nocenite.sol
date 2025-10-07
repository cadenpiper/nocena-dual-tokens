// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Nocenite (NCT)
 * @dev Unlimited supply reward token for challenge completion
 * @notice NCT tokens are earned through daily, weekly, and monthly challenges
 */
contract Nocenite is ERC20, Ownable {
    /**
     * @dev Creates the Nocenite token with unlimited supply
     * @param initialOwner Address that will own the contract
     */
    constructor(address initialOwner) ERC20("Nocenite", "NCT") Ownable(initialOwner) {}

    /**
     * @dev Mints NCT tokens to specified address
     * @param to Address to receive the tokens
     * @param amount Amount of tokens to mint
     * @notice Only owner can mint tokens for challenge rewards
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
