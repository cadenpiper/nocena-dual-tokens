// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Nocenite (NCT)
 * @dev Unlimited supply reward token for challenge completion with role-based minting
 * @notice NCT tokens are earned through daily, weekly, and monthly challenges
 */
contract Nocenite is ERC20, Ownable {
    /// @dev Mapping of addresses authorized to mint reward tokens
    mapping(address => bool) public rewardMinters;
    
    /// @dev Emitted when a reward minter is added or removed
    event RewardMinterUpdated(address indexed minter, bool authorized);

    /**
     * @dev Creates the Nocenite token with unlimited supply
     * @param initialOwner Address that will own the contract
     */
    constructor(address initialOwner) ERC20("Nocenite", "NCT") Ownable(initialOwner) {}

    /**
     * @dev Modifier to restrict function access to owner or authorized reward minters
     */
    modifier onlyRewardMinter() {
        require(rewardMinters[msg.sender] || msg.sender == owner(), "Not authorized to mint");
        _;
    }

    /**
     * @dev Mints NCT tokens to specified address
     * @param to Address to receive the tokens
     * @param amount Amount of tokens to mint
     * @notice Owner or authorized reward minters can mint tokens for challenge rewards
     */
    function mint(address to, uint256 amount) public onlyRewardMinter {
        _mint(to, amount);
    }

    /**
     * @dev Adds an address as an authorized reward minter
     * @param minter Address to authorize for minting
     * @notice Only owner can add reward minters (e.g., frontend services)
     */
    function addRewardMinter(address minter) external onlyOwner {
        rewardMinters[minter] = true;
        emit RewardMinterUpdated(minter, true);
    }

    /**
     * @dev Removes an address from authorized reward minters
     * @param minter Address to remove from minting authorization
     * @notice Only owner can remove reward minters
     */
    function removeRewardMinter(address minter) external onlyOwner {
        rewardMinters[minter] = false;
        emit RewardMinterUpdated(minter, false);
    }

    /**
     * @dev Checks if an address is authorized to mint rewards
     * @param minter Address to check
     * @return bool True if authorized to mint
     */
    function isRewardMinter(address minter) external view returns (bool) {
        return rewardMinters[minter] || minter == owner();
    }
}
