// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Nocenite.sol";
import "./Nocenix.sol";

contract Airdrop is Ownable {
    Nocenite public nocenite;
    Nocenix public nocenix;
    
    uint256 public immutable deploymentTime;
    uint256 public constant WEEK_DURATION = 7 days;
    uint256 public constant YEAR_DURATION = 365 days;
    
    // Airdrop tracking
    mapping(uint256 => bool) public weeklyAirdropExecuted;
    uint256 public totalAirdropsExecuted;
    
    event AirdropExecuted(uint256 indexed weekNumber, uint256 totalAmount, uint256 recipientCount);
    
    constructor(address _nocenite, address _nocenix, address initialOwner) Ownable(initialOwner) {
        nocenite = Nocenite(_nocenite);
        nocenix = Nocenix(_nocenix);
        deploymentTime = block.timestamp;
    }
    
    function getCurrentWeek() public view returns (uint256) {
        return (block.timestamp - deploymentTime) / WEEK_DURATION;
    }
    
    function getCurrentYear() public view returns (uint256) {
        return (block.timestamp - deploymentTime) / YEAR_DURATION;
    }
    
    function getWeeklyRewardAmount() public view returns (uint256) {
        uint256 year = getCurrentYear();
        
        if (year == 0) return 1_000_000 * 10**18; // Year 1: 1M NCX
        if (year == 1) return 750_000 * 10**18;  // Year 2: 750K NCX
        if (year == 2) return 500_000 * 10**18;  // Year 3: 500K NCX
        if (year == 3) return 250_000 * 10**18;  // Year 4: 250K NCX
        
        return 100_000 * 10**18; // Year 5+: 100K NCX minimum
    }
    
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
