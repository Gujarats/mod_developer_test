::DeveloperTest <- {
    ID = "mod_gz_developer_test",
    Version = "0.0.1",
    Name = "guzBluez Developer Test"
};

::DeveloperTest.HookMod <- ::Hooks.register(::DeveloperTest.ID, ::DeveloperTest.Version, ::DeveloperTest.Name);
::DeveloperTest.HookMod.require("mod_msu >= 1.9.0");

::include("scripts/mods/developer_test/log_controller");

::DeveloperTest.HookMod.queue(">mod_msu", function()
{
    ::DeveloperTest.Mod <- ::MSU.Class.Mod(::DeveloperTest.ID, ::DeveloperTest.Version, ::DeveloperTest.Name);
    ::DeveloperTest.registerSettings();
    ::include("scripts/mods/developer_test/service");
    ::include("scripts/mods/developer_test/adapters");
    ::DeveloperTest.debugLog("Initialized; all developer actions are disabled until Developer Test Mode is enabled.");
});
