if (!("DeveloperTest" in getroottable()))
{
    ::DeveloperTest <- {};
}

::DeveloperTest.registerSettings <- function()
{
    local general = ::DeveloperTest.Mod.ModSettings.addPage("General");
    local kits = ::DeveloperTest.Mod.ModSettings.addPage("Test Kits");
    local progression = ::DeveloperTest.Mod.ModSettings.addPage("Progression");

    general.addBooleanSetting("EnableDeveloperTestMode", false, "Enable Developer Test Mode", "Enables the explicit test buttons. Use only on a disposable save.");
    local debug = general.addBooleanSetting("EnableAllOwnedModDebugLogs", true, "Enable All My Mod Debug Logs", "Override debug logging for all installed guzBluez gameplay mods.");
    debug.addCallback(function(_enabled = true)
    {
        ::GuzBluezDebugLogController.setEnabled(_enabled);
    });
    ::GuzBluezDebugLogController.setEnabled(debug.getValue());

    kits.addRangeSetting("KitCopies", 1, 1, 10, 1, "Kit Copies", "Copies of each item granted by an explicit test-kit action.");
    kits.addButtonSetting("GrantAuraRouting", null, "Grant Aura Routing", "Explicit action: grants Aura Routing to current player brothers when Aura Routing is installed.").addCallback(function(_data = null) { ::DeveloperTest.Adapters.grantAuraRouting(); });
    kits.addButtonSetting("GrantOpArchers", null, "Grant OP Archers Kit", "Explicit action: adds short bows and crossbows to the stash when OP Archers is installed.").addCallback(function(_data = null) { ::DeveloperTest.Adapters.grantOpArchersKit(); });
    kits.addButtonSetting("GrantBandages", null, "Grant Bandages Kit", "Explicit action: adds vanilla bandages when Bandages Enhanced is installed.").addCallback(function(_data = null) { ::DeveloperTest.Adapters.grantBandagesKit(); });
    kits.addButtonSetting("GrantPotionHelper", null, "Grant Potion Helper Kit", "Explicit action: adds all Potion Helper potion types to the stash.").addCallback(function(_data = null) { ::DeveloperTest.Adapters.grantPotionHelperKit(); });
    kits.addButtonSetting("GrantPotionResurrection", null, "Grant Resurrection Kit", "Explicit action: adds Normal, Rare, and Legendary resurrection potions to the stash.").addCallback(function(_data = null) { ::DeveloperTest.Adapters.grantPotionResurrectionKit(); });

    progression.addRangeSetting("LevelMaxTestXP", 4000, 1, 100000, 1000, "XP Per Brother", "XP granted through the normal progression path to each current player brother.");
    progression.addButtonSetting("GrantLevelMaxXP", null, "Grant Level Max XP", "Explicit action: grants configured XP to every player brother when Level Max is installed.").addCallback(function(_data = null) { ::DeveloperTest.Adapters.grantLevelMaxXP(); });
};
