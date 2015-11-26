-- Returns Int
function GetFoodProduced( unit )
    if unit and IsValidEntity(unit) then
        if GameRules.UnitKV[unit:GetUnitName()] and GameRules.UnitKV[unit:GetUnitName()].FoodProduced then
            return GameRules.UnitKV[unit:GetUnitName()].FoodProduced
        end
    end
    return 0
end

-- Returns Int
function GetFoodCost( unit )
    if unit and IsValidEntity(unit) then
        if GameRules.UnitKV[unit:GetUnitName()] and GameRules.UnitKV[unit:GetUnitName()].FoodCost then
            return GameRules.UnitKV[unit:GetUnitName()].FoodCost
        elseif GameRules.HeroKV[unit:GetUnitName()] and GameRules.HeroKV[unit:GetUnitName()].FoodCost then
            return GameRules.HeroKV[unit:GetUnitName()].FoodCost
        end
    end
    return 0
end

-- Returns Int
function GetGoldCost( unit )
    if unit and IsValidEntity(unit) then
        if GameRules.UnitKV[unit:GetUnitName()] and GameRules.UnitKV[unit:GetUnitName()].GoldCost then
            return GameRules.UnitKV[unit:GetUnitName()].GoldCost
        end
    end
    return 0
end

-- Returns Int
function GetLumberCost( unit )
    if unit and IsValidEntity(unit) then
        if GameRules.UnitKV[unit:GetUnitName()] and GameRules.UnitKV[unit:GetUnitName()].LumberCost then
            return GameRules.UnitKV[unit:GetUnitName()].LumberCost
        end
    end
    return 0
end

-- Returns float
function GetBuildTime( unit )
    if unit and IsValidEntity(unit) then
        if GameRules.UnitKV[unit:GetUnitName()] and GameRules.UnitKV[unit:GetUnitName()].BuildTime then
            return GameRules.UnitKV[unit:GetUnitName()].BuildTime
        end
    end
    return 0
end

function GetCollisionSize( unit )
    if unit and IsValidEntity(unit) then
        if GameRules.UnitKV[unit:GetUnitName()]["CollisionSize"] and GameRules.UnitKV[unit:GetUnitName()]["CollisionSize"] then
            return GameRules.UnitKV[unit:GetUnitName()]["CollisionSize"]
        end
    end
    return 0
end

-- Returns a string with the race of the unit
function GetUnitRace( unit )
    local name = unit:GetUnitName()
    local name_split = split(name, "_")
    return name_split[1]
end



-- Checks the UnitLabel for "city_center"
function IsCityCenter( unit )
    return IsCustomBuilding(unit) and string.match(unit:GetUnitLabel(), "city_center")
end

-- Builders are stored in a nettable in addition to the builder label
function IsBuilder( unit )
    local label = unit:GetUnitLabel()
    if label == "builder" then
        return true
    end
    local table = CustomNetTables:GetTableValue("builders", tostring(unit:GetEntityIndex()))
    if table then
        return tobool(table["IsBuilder"])
    else
        return false
    end
end

function IsBase( unit )
    local race = GetUnitRace(unit)
    local unitName = unit:GetUnitName()
    if race == "human" then
        if unitName == "human_town_hall" or unitName == "human_keep" or unitName == "human_castle" then
            return true
        end
    elseif race == "nightelf" then
        if unitName == "nightelf_tree_of_life" or unitName == "nightelf_tree_of_ages" or unitName == "nightelf_tree_of_eternity" then
            return true
        end
    elseif race == "orc" then
        if unitName == "orc_great_hall" or unitName == "orc_stronghold" or unitName == "orc_fortress" then
            return true
        end
    elseif race == "undead" then
        if unitName == "undead_necropolis" or unitName == "undead_halls_of_the_dead" or unitName == "undead_black_citadel" then
            return true
        end
    end
    return false
end

-- Returns true if the unit is a valid lumberjack
function CanGatherLumber( unit )
    local unitName = unit:GetUnitName()
    if unitName == "human_peasant" or unitName == "nightelf_wisp" or unitName == "undead_ghoul" or unitName == "orc_peon" then
        return true
    else
        return false
    end
end

-- Returns true if the unit is a gold miner
function CanGatherGold( unit )
    local unitName = unit:GetUnitName()
    if unitName == "human_peasant" or unitName == "nightelf_wisp" or unitName == "undead_acolyte" or unitName == "orc_peon" then
        return true
    else
        return false
    end
end

function IsHuman( unit )
    return GetUnitRace(unit)=="human"
end

function IsOrc( unit )
    return GetUnitRace(unit)=="orc"
end

function IsNightElf( unit )
    return GetUnitRace(unit)=="nightelf"
end

function IsUndead( unit )
    return GetUnitRace(unit)=="undead"
end

function IsCustomBuilding( unit )
    local ability_building = unit:FindAbilityByName("ability_building")
    local ability_tower = unit:FindAbilityByName("ability_tower")
    if ability_building or ability_tower then
        return true
    else
        return false
    end
end

function IsAltar( unit )
    return string.match(unit:GetUnitName(), "_altar_")
end

function IsCustomTower( unit )
    return unit:HasAbility("ability_tower")
end

function IsCustomShop( unit )
    return unit:HasAbility("ability_shop")
end

function IsMechanical( unit )
    return unit:HasAbility("ability_siege")
end
-- Shortcut for a very common check
function IsValidAlive( unit )
    return (IsValidEntity(unit) and unit:IsAlive())
end

-- Returns all visible enemies in radius of the unit
function FindEnemiesInRadius( unit, radius )
    local team = unit:GetTeamNumber()
    local position = unit:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
    return FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
end

-- Returns all units (friendly and enemy) in radius of the unit
function FindAllUnitsInRadius( unit, radius )
    local team = unit:GetTeamNumber()
    local position = unit:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    return FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, target_type, flags, FIND_ANY_ORDER, false)
end

function FindAlliesInRadius( unit, radius )
    local team = unit:GetTeamNumber()
    local position = unit:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    return FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, 0, FIND_CLOSEST, false)
end

function HasGoldMineDistanceRestriction( unit_name )
    if GameRules.UnitKV[unit_name] then
        local bRestrictGoldMineDistance = GameRules.UnitKV[unit_name]["RestrictGoldMineDistance"]
        if bRestrictGoldMineDistance and bRestrictGoldMineDistance == 1 then
            return true
        end
    end
    return false
end

function ReplaceUnit( unit, new_unit_name )
    --print("Replacing "..unit:GetUnitName().." with "..new_unit_name)

    local hero = unit:GetOwner()
    local playerID = hero:GetPlayerOwnerID()

    local position = unit:GetAbsOrigin()
    local relative_health = unit:GetHealthPercent()
    local bSelected = IsCurrentlySelected(unit)

    local new_unit = CreateUnitByName(new_unit_name, position, true, hero, hero, hero:GetTeamNumber())
    new_unit:SetOwner(hero)
    new_unit:SetControllableByPlayer(playerID, true)
    new_unit:SetHealth(new_unit:GetMaxHealth() * relative_health)
    FindClearSpaceForUnit(new_unit, position, true)

    if bSelected then
        AddUnitToSelection(new_unit)
    end

    -- Add the new unit to the player units
    Players:AddUnit(playerID, new_unit)

    -- Remove replaced unit from the game
    Players:RemoveUnit(playerID, unit)
    unit:RemoveSelf()

    return new_unit
end

function HasTrainAbility( unit )
    for i=0,15 do
        local ability = unit:GetAbilityByIndex(i)
        if ability then
            local ability_name = ability:GetAbilityName()
            if string.match(ability_name, "_train_") then
                return true
            end
        end
    end
    return false
end

-- Returns if the builder is fully idle (not reparing or in a gathering process)
function IsIdleBuilder( unit )
    return (unit.state == "idle" and unit:IsIdle())
end

function ApplyConstructionEffect( unit )
    local item = CreateItem("item_apply_modifiers", nil, nil)
    item:ApplyDataDrivenModifier(unit, unit, "modifier_construction", {})
    item = nil
end

function RemoveConstructionEffect( unit )
    unit:RemoveModifierByName("modifier_construction")
end

function HoldPosition( unit )
    unit.bHold = true
    ApplyModifier(unit, "modifier_hold_position")
end

function IsAlliedUnit( unit, target )
    return (unit:GetTeamNumber() == target:GetTeamNumber())
end

function IsNeutralUnit( target )
    return (target:GetTeamNumber() == DOTA_TEAM_NEUTRALS)
end