-- Register trait
TraitFactory.addTrait("Composed", "Composed", 6, "You like to sit down and focus on taking your breath back more than anything.", false, false)

-- Function of the trait
local function FasterRestComposed(player)
    -- If player doesn't have the trait return
    if not player:HasTrait("Composed") then
        return
    end
    
    -- Check if sitting on ground or on furniture
    local isSitting = player:isSitOnGround() or player:isSittingOnFurniture()
    
    -- Only apply bonus when sitting
    if not isSitting then
        return
    end

    local stats = player:getStats()
    local currentEndurance = stats:getEndurance()
    local maxEndurance = 1.0

    if currentEndurance < maxEndurance then
        local regenBonus = 0.0001 -- Adjust this value for balance (start small!)
        local newEndurance = math.min(currentEndurance + regenBonus, maxEndurance)
        stats:setEndurance(newEndurance)
    end
end

local function FasterRestDynamic()
    local player = getPlayer()
    -- Null checker
    if not player then
        return
    end
    
    local fitnessSkill = player:getPerkLevel(Perks.Fitness) -- Check if it's Fitness not fitnessSkill
    local traits = player:getTraits()

    if not traits then
        print("Error: traits is nil")
        return
    end

    -- Award trait at fitness level 8+
    if fitnessSkill >= 8 and not player:HasTrait("Composed") then
        traits:add("Composed")
    end
end

Events.OnPlayerUpdate.Add(FasterRestComposed)
Events.LevelPerk.Add(FasterRestDynamic)