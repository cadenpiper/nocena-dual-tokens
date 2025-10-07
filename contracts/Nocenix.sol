// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Nocenix (NCX)
 * @dev Capped supply value token distributed through time-based airdrops
 * @notice NCX tokens are distributed weekly based on NCT holdings
 */
contract Nocenix is ERC20, Ownable {
    /// @dev Maximum supply of 1 billion NCX tokens
    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10**18;

    /**
     * @dev Creates the Nocenix token with capped supply
     * @param initialOwner Address that will own the contract
     */
    constructor(address initialOwner) ERC20("Nocenix", "NCX") Ownable(initialOwner) {}

    /**
     * @dev Mints NCX tokens to specified address
     * @param to Address to receive the tokens
     * @param amount Amount of tokens to mint
     * @notice Only owner can mint tokens, respects max supply cap
     */
    function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _mint(to, amount);
    }

    /**
     * @dev Burns NCX tokens from specified address
     * @param from Address to burn tokens from
     * @param amount Amount of tokens to burn
     * @notice Only owner can burn tokens
     */
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}
