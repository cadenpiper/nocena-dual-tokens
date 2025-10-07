// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Nocenite.sol";
import "./Nocenix.sol";

/**
 * @title Airdrop
 * @dev Time-based airdrop system for distributing NCX tokens
 * @notice Distributes NCX tokens weekly based on NCT holdings with decreasing rewards over time
 */
contract Airdrop is Ownable {
    /// @dev Nocenite token contract
    Nocenite public nocenite;
    /// @dev Nocenix token contract
    Nocenix public nocenix;
    
    /// @dev Timestamp when contract was deployed
    uint256 public immutable deploymentTime;
    /// @dev Duration of one week in seconds
    uint256 public constant WEEK_DURATION = 7 days;
    /// @dev Duration of one year in seconds
    uint256 public constant YEAR_DURATION = 365 days;
    
    /// @dev Tracks which weeks have had airdrops executed
    mapping(uint256 => bool) public weeklyAirdropExecuted;
    /// @dev Total number of airdrops executed
    uint256 public totalAirdropsExecuted;
    
    /// @dev Emitted when a weekly airdrop is executed
    event AirdropExecuted(uint256 indexed weekNumber, uint256 totalAmount, uint256 recipientCount);
    
    /**
     * @dev Creates the airdrop contract
     * @param _nocenite Address of the Nocenite token contract
     * @param _nocenix Address of the Nocenix token contract
     * @param initialOwner Address that will own the contract
     */
    constructor(address _nocenite, address _nocenix, address initialOwner) Ownable(initialOwner) {
        nocenite = Nocenite(_nocenite);
        nocenix = Nocenix(_nocenix);
        deploymentTime = block.timestamp;
    }
    
    /**
     * @dev Gets the current week number since deployment
     * @return Current week number (0-based)
     */
    function getCurrentWeek() public view returns (uint256) {
        return (block.timestamp - deploymentTime) / WEEK_DURATION;
    }
    
    /**
     * @dev Gets the current year since deployment
     * @return Current year number (0-based)
     */
    function getCurrentYear() public view returns (uint256) {
        return (block.timestamp - deploymentTime) / YEAR_DURATION;
    }
    
    /**
     * @dev Gets the weekly reward amount based on current year
     * @return Weekly NCX reward amount with decreasing schedule
     * @notice Year 1: 1M NCX, Year 2: 750K NCX, Year 3: 500K NCX, Year 4: 250K NCX, Year 5+: 100K NCX
     */
    function getWeeklyRewardAmount() public view returns (uint256) {
        uint256 year = getCurrentYear();
        
        if (year == 0) return 1_000_000 * 10**18; // Year 1: 1M NCX
        if (year == 1) return 750_000 * 10**18;  // Year 2: 750K NCX
        if (year == 2) return 500_000 * 10**18;  // Year 3: 500K NCX
        if (year == 3) return 250_000 * 10**18;  // Year 4: 250K NCX
        
        return 100_000 * 10**18; // Year 5+: 100K NCX minimum
    }
    
    /**
     * @dev Executes weekly airdrop to specified recipients
     * @param recipients Array of addresses to receive airdrop
     * @notice Distributes NCX proportionally based on NCT holdings
     * @notice Can only be executed once per week
     */
    function executeWeeklyAirdrop(address[] calldata recipients) external onlyOwner {
        uint256 currentWeek = getCurrentWeek();
        require(!weeklyAirdropExecuted[currentWeek], "Airdrop already executed this week");
        
        uint256 weeklyReward = getWeeklyRewardAmount();
        uint256 totalNCT = nocenite.totalSupply();
        require(totalNCT > 0, "No NCT tokens exist");
        
        uint256 recipientCount = 0;
        
        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            uint256 nctBalance = nocenite.balanceOf(recipient);
            
            if (nctBalance > 0) {
                uint256 ncxAmount = (nctBalance * weeklyReward) / totalNCT;
                nocenix.mint(recipient, ncxAmount);
                recipientCount++;
            }
        }
        
        weeklyAirdropExecuted[currentWeek] = true;
        totalAirdropsExecuted++;
        
        emit AirdropExecuted(currentWeek, weeklyReward, recipientCount);
    }
    
    /**
     * @dev Gets comprehensive airdrop information
     * @return currentWeek Current week number
     * @return currentYear Current year number
     * @return weeklyReward Current weekly reward amount
     * @return weekExecuted Whether current week's airdrop has been executed
     * @return totalExecuted Total number of airdrops executed
     */
    function getAirdropInfo() external view returns (
        uint256 currentWeek,
        uint256 currentYear, 
        uint256 weeklyReward,
        bool weekExecuted,
        uint256 totalExecuted
    ) {
        currentWeek = getCurrentWeek();
        currentYear = getCurrentYear();
        weeklyReward = getWeeklyRewardAmount();
        weekExecuted = weeklyAirdropExecuted[currentWeek];
        totalExecuted = totalAirdropsExecuted;
    }
}
