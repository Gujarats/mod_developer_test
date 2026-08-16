::DeveloperTest.debugLog <- function(_message)
{
    ::DeveloperTest.Mod.Debug.printLog("[DeveloperTest] " + _message);
};

::DeveloperTest.isEnabled <- function()
{
    return ::DeveloperTest.Mod.ModSettings.getSetting("EnableDeveloperTestMode").getValue();
};

::DeveloperTest.requireAction <- function(_targetID, _label)
{
    if (!::DeveloperTest.isEnabled())
    {
        ::DeveloperTest.debugLog("[" + _label + "] ignored: Developer Test Mode is disabled.");
        return false;
    }
    if (!::Hooks.hasMod(_targetID))
    {
        ::DeveloperTest.debugLog("[" + _label + "] ignored: required mod " + _targetID + " is not installed.");
        return false;
    }
    if (!("World" in getroottable()) || ::World == null || ::World.getPlayerRoster() == null || ::World.Assets == null)
    {
        ::DeveloperTest.debugLog("[" + _label + "] ignored: a loaded campaign is required.");
        return false;
    }
    return true;
};

::DeveloperTest.grantItems <- function(_label, _scripts)
{
    local copies = ::DeveloperTest.Mod.ModSettings.getSetting("KitCopies").getValue();
    local stash = ::World.Assets.getStash();
    local needed = _scripts.len() * copies;
    if (stash == null || stash.getNumberOfEmptySlots() < needed)
    {
        ::DeveloperTest.debugLog("[" + _label + "] ignored: stash needs " + needed + " empty slots.");
        return;
    }

    try
    {
        foreach (script in _scripts)
        {
            for (local i = 0; i < copies; i = ++i)
            {
                stash.add(::new(script));
            }
        }
        ::DeveloperTest.debugLog("[" + _label + "] granted " + needed + " item(s).");
    }
    catch (error)
    {
        ::DeveloperTest.debugLog("[" + _label + "] failed: " + error);
    }
};
