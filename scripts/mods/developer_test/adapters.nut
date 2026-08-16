::DeveloperTest.Adapters <- {};

::DeveloperTest.Adapters.grantAuraRouting <- function()
{
    local label = "AuraRouting";
    if (!::DeveloperTest.requireAction("mod_aura_routing", label)) return;

    local granted = 0;
    foreach (bro in ::World.getPlayerRoster().getAll())
    {
        if (bro == null || bro.getSkills().hasSkill("perk.aura_routing")) continue;
        try
        {
            bro.getSkills().add(::new("scripts/skills/perks/aura_routing_perk"));
            bro.getSkills().update();
            granted = ++granted;
        }
        catch (error)
        {
            ::DeveloperTest.debugLog("[" + label + "] failed for " + bro.getName() + ": " + error);
        }
    }
    ::DeveloperTest.debugLog("[" + label + "] granted perk to " + granted + " brother(s). Legends perk-tree placement is tested through Aura Routing's own developer options.");
};

::DeveloperTest.Adapters.grantOpArchersKit <- function()
{
    local label = "OpArchers";
    if (!::DeveloperTest.requireAction("mod_op_archers", label)) return;
    ::DeveloperTest.grantItems(label, ["scripts/items/weapons/short_bow", "scripts/items/weapons/crossbow", "scripts/items/weapons/heavy_crossbow"]);
};

::DeveloperTest.Adapters.grantBandagesKit <- function()
{
    local label = "BandagesEnhanced";
    if (!::DeveloperTest.requireAction("mod_bandages_enhanced", label)) return;
    ::DeveloperTest.grantItems(label, ["scripts/items/accessory/bandage_item"]);
};

::DeveloperTest.Adapters.grantPotionHelperKit <- function()
{
    local label = "PotionHelper";
    if (!::DeveloperTest.requireAction("mod_potion_helper", label)) return;
    ::DeveloperTest.grantItems(label, [
        "scripts/items/accessory/potion_helper_low_item",
        "scripts/items/accessory/potion_helper_medium_item",
        "scripts/items/accessory/potion_helper_high_item",
        "scripts/items/accessory/potion_helper_armor_item"
    ]);
};

::DeveloperTest.Adapters.grantPotionResurrectionKit <- function()
{
    local label = "PotionResurrection";
    if (!::DeveloperTest.requireAction("mod_potion_resurrection", label)) return;
    ::DeveloperTest.grantItems(label, [
        "scripts/items/misc/resurrection_potion_normal_item",
        "scripts/items/misc/resurrection_potion_medium_item",
        "scripts/items/misc/resurrection_potion_high_item"
    ]);
};

::DeveloperTest.Adapters.grantLevelMaxXP <- function()
{
    local label = "LevelMax";
    if (!::DeveloperTest.requireAction("mod_level_max", label)) return;

    local xp = ::DeveloperTest.Mod.ModSettings.getSetting("LevelMaxTestXP").getValue();
    local changed = 0;
    foreach (bro in ::World.getPlayerRoster().getAll())
    {
        if (bro == null) continue;
        bro.addXP(xp, false);
        bro.updateLevel();
        bro.getSkills().update();
        changed = ++changed;
    }
    ::DeveloperTest.debugLog("[" + label + "] granted xp=" + xp + " to " + changed + " brother(s) through the native progression path.");
};
