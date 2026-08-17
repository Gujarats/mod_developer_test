if (!("DeveloperTest" in getroottable()))
{
    ::DeveloperTest <- {};
}

::GuzBluezDebugLogController <- {
    Enabled = true,
    Targets = {},

    function isSupported( _id )
    {
        return _id == "mod_aura_routing"
            || _id == "mod_op_archers"
            || _id == "mod_bandages_enhanced"
            || _id == "mod_potion_helper"
            || _id == "mod_potion_resurrection"
            || _id == "mod_dismissal_enhanced"
            || _id == "mod_level_max";
    }

    function getEnabled()
    {
        return this.Enabled;
    }

    function applyTarget( _id )
    {
        if (!(_id in this.Targets) || this.Targets[_id] == null)
        {
            return;
        }

        try
        {
            this.Targets[_id].Debug.setFlag("default", this.Enabled);
        }
        catch (error)
        {
            if ("Mod" in ::DeveloperTest && ::DeveloperTest.Mod != null)
            {
                ::DeveloperTest.Mod.Debug.printLog("[DeveloperTest][Logs] unable to apply " + _id + ": " + error);
            }
        }
    }

    function registerTarget( _id, _mod )
    {
        if (!this.isSupported(_id) || _mod == null)
        {
            return;
        }

        if (_id in this.Targets)
        {
            this.Targets[_id] = _mod;
        }
        else
        {
            this.Targets[_id] <- _mod;
        }
        this.applyTarget(_id);
    }

    function applyAll()
    {
        foreach (id, _mod in this.Targets)
        {
            this.applyTarget(id);
        }
    }

    function setEnabled( _enabled )
    {
        this.Enabled = _enabled == true;

        if ("Mod" in ::DeveloperTest && ::DeveloperTest.Mod != null)
        {
            ::DeveloperTest.Mod.Debug.setFlag("default", this.Enabled);
        }

        this.applyAll();

        if (this.Enabled && "Mod" in ::DeveloperTest && ::DeveloperTest.Mod != null)
        {
            ::DeveloperTest.Mod.Debug.printLog("[DeveloperTest][Logs] all owned mod debug logs enabled=true");
        }
    }
};
