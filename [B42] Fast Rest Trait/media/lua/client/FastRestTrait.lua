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

    if currentEndurance >= maxEndurance then
        return
    end

    -- Scale based on Fitness Level (0-10)
    local fitness = player:getPerkLevel(Perks.Fitness)
    local baseRegen = 0.000047 -- Base regen bonus
    local scale = 1 + (fitness * 0.25) -- plus 25% per level in fitness
    local regenBonus = baseRegen * scale

    stats:setEndurance(math.min(currentEndurance + regenBonus, maxEndurance))
end

Events.OnPlayerUpdate.Add(function(player)
    if player then
        FasterRestComposed(player)
    end
end)

-- Dynamic Trait unlocker
local function CheckComposedUnlock(player, perk, level)
    if not player or perk ~= Perks.Fitness then
        return
    end
    
    local fitness = player:getPerkLevel(Perks.Fitness)

    -- Unlock at Fitness >= 8
    if fitness >= 8 and not player:HasTrait("Composed") then
        player:getTraits():add("Composed")
    end
end

Events.LevelPerk.Add(CheckComposedUnlock)