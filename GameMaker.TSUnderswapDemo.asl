// TS!Underswap Demo Autosplitter by NERS

state("TS!Underswap", "v1.0.8")
{
    // Global
    double kills : 0x6FCAF4, 0x30, 0x600, 0x20; // global.playerkills

    // Self
    double namePhase  : 0x6EFDE8, 0x84,  0x14C, 0x2C, 0x10, 0x264, 0x0; // obj_namehandler.phase
    double menuFade   : 0x6EFDE8, 0x24C, 0x84,  0x2C, 0x10, 0x12C, 0x0; // obj_menuhandler.bfadealpha
    double menuOption : 0x6EFDE8, 0x24C, 0x84,  0x2C, 0x10, 0x1BC, 0x0; // obj_menuhandler.selected
}

state("TS!Underswap", "v2.0.4")
{
    double kills : 0xB7B040, 0x48, 0x10, 0x170, 0x20;

    double namePhase  : 0xD8AB08, 0xE0,  0x48, 0x10, 0x310, 0x0;
    double menuFade   : 0xB4B710, 0xA70, 0x18, 0x48, 0x10,  0x300, 0x0;
    double menuOption : 0xB4B710, 0xA70, 0x18, 0x48, 0x10,  0x3D0, 0x0;
    double liftState  : 0xDAB2F0, 0x8,   0x48, 0x10, 0x3E0, 0x0; // obj_crys_lift.state

    float playerX : 0xB680E8, 0x0, 0x868, 0x18, 0x68, 0x10, 0xF0; // obj_player.x

    string128 text : 0xD8AB08, 0xE0, 0x48, 0x10, 0xB0, 0x0, 0x0, 0x0;
}

state("TS!Underswap", "v2.0.5")
{
    double kills : 0xB7B040, 0x48, 0x10, 0x170, 0x20;

    double namePhase  : 0xD8AB08, 0xE0,  0x48, 0x10, 0x3E0, 0x0;
    double menuFade   : 0xB4B710, 0xA70, 0x18, 0x48, 0x10,  0x20,  0x0;
    double menuOption : 0xB4B710, 0xA70, 0x18, 0x48, 0x10,  0x3E0, 0x0;
    double liftState  : 0xDAB2F0, 0x8,   0x48, 0x10, 0x3E0, 0x0;

    float playerX : 0xB680E8, 0x0, 0x868, 0x18, 0x68, 0x10, 0xF0;

    string128 text : 0xD8AB08, 0xE0, 0x48, 0x10, 0xB0, 0x0, 0x0, 0x0;
}

startup
{
    refreshRate = 30;

    settings.Add("KillCount", false, "Show kill count");
    settings.SetToolTip("KillCount", "A new row will appear on your layout with the total amount of kills\non the current save file.");

    settings.Add("StartOnContinue", false, "Start/Reset the timer when loading a save file");

    settings.Add("FG", true, "Full Game");
    settings.CurrentDefaultParent = "FG";
    settings.Add("v1_Ending",      true, "v1.0 Ending");
    settings.Add("v2_Ending",      true, "v2.0 Ending");
    settings.Add("v2_DirtyHacker", true, "v2.0 Dirty Hacker Ending");

    settings.CurrentDefaultParent = null;
    settings.Add("IL", false, "Individual Levels");
    settings.CurrentDefaultParent = "IL";
    settings.Add("Exit_RuinedHome",      false, "Exit Ruined Home");
    settings.Add("Enter_StarlightIsles", false, "Start/Reset the timer when entering Starlight Isles");
    settings.Add("Exit_StarlightIsles",  false, "Exit Starlight Isles");

    // Thanks to Ero for this
    var cache = new Dictionary<string, LiveSplit.UI.Components.ILayoutComponent>();
    vars.setText = (Action<string, object>)((text1, text2) =>
    {
        LiveSplit.UI.Components.ILayoutComponent lc;
        if(!cache.TryGetValue(text1, out lc))
        {
            lc = LiveSplit.UI.Components.ComponentManager.LoadLayoutComponent("LiveSplit.Text.dll", timer);
            cache[text1] = lc;
        }

        if(!timer.Layout.LayoutComponents.Contains(lc))
            timer.Layout.LayoutComponents.Add(lc);

        dynamic tc = lc.Component;
        tc.Settings.Text1 = text1;
        tc.Settings.Text2 = text2.ToString();
    });

    vars.removeAllTexts = (Action)(() =>
    {
        foreach(var lc in cache.Values)
            timer.Layout.LayoutComponents.Remove(lc);
    });
}

shutdown
{
    vars.removeAllTexts();
}

exit
{
    vars.removeAllTexts();
}

init
{
    var module = modules.First();
    vars.x64 = game.Is64Bit();

    // Thanks to Jujstme and Ero for this (finding room names)
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
    Func<int, string, IntPtr> scan = (o, sig) =>
    {
        IntPtr ptr = vars.x64
            ? scanner.Scan(new SigScanTarget(o, sig) { OnFound = (p, s, addr) => addr + p.ReadValue<int>(addr) + 0x4 })
            : scanner.Scan(new SigScanTarget(o, sig) { OnFound = (p, s, addr) => p.ReadPointer(addr) });

        if(ptr == IntPtr.Zero) throw new NullReferenceException("[TS!Underswap Demo] Signature scanning failed");
        print("[TS!Underswap Demo] Signature found at " + ptr.ToString("X"));
        return ptr;
    };
    
    IntPtr ptrRoomArray = vars.x64 
        ? scan(5, "74 0C 48 8B 05 ?? ?? ?? ?? 48 8B 04 D0")
        : scan(2, "8B 3D ?? ?? ?? ?? 2B EF");

    vars.ptrRoomID = vars.x64 
        ? scan(9, "48 8B 05 ?? ?? ?? ?? 89 3D ?? ?? ?? ??")
        : scan(2, "FF 35 ?? ?? ?? ?? E8 ?? ?? ?? ?? 83 C4 04 50 68");

    vars.getRoomName = (Func<string>)(() =>
    {
        IntPtr arrayMain = game.ReadPointer(ptrRoomArray);
        if(arrayMain == IntPtr.Zero) return string.Empty;

        IntPtr arrayItem = vars.x64 
            ? game.ReadPointer(arrayMain + game.ReadValue<int>((IntPtr)vars.ptrRoomID) * 8)
            : game.ReadPointer(arrayMain + game.ReadValue<int>((IntPtr)vars.ptrRoomID) * 4);

        if(arrayItem == IntPtr.Zero) return string.Empty;
        return game.ReadString(arrayItem, 64);
    });

    string hash;
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(new FileInfo(module.FileName).DirectoryName + @"\data\game.dxb")) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    switch(hash)
    {
        case "BB9CF694EB1353F3C168362FAF76F580":
            version = "v1.0.8";
            break;

        case "675707015AFC412444119698E30E0F52":
            version = "v2.0.4";
            break;

        case "9AA62DA009DF346C43E7B55C912844A2": 
            version = "v2.0.5";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of the TS!Underswap Demo is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update." +
                "\n\nSupported versions: v1.0.8, v2.0.4, v2.0.5.",
                "LiveSplit | TS!Underswap Demo", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[TS!Underswap Demo] Version: " + version + " (" + hash + ")");

    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old room, new room, special condition
        {"Exit_RuinedHome",     new object[] {false, "rm_ruina_final", null,                 1}},
        {"v1_Ending",           new object[] {false, "rm_star3",       "rm_demoend",         0}},
        {"v2_Ending",           new object[] {false, null,             "rm_crys_entermines", 2}},
        {"v2_DirtyHacker",      new object[] {false, null,             "rm_terribleend",     3}},
        {"Exit_StarlightIsles", new object[] {false, null,             "rm_stars_bridge",    4}}
    };
}

start
{
    if(current.roomName == "rm_menu_start" || current.roomName == "rm_load")
    {
        if(current.menuOption == 1)
            return (old.menuFade == 0 && current.menuFade > 0 && settings["StartOnContinue"]);
        
        return (old.namePhase != 3 && current.namePhase == 3);
    }

    else if(old.roomName == "rm_credits_short" && current.roomName == "rm_star1")
        return (settings["Enter_StarlightIsles"]);
}

reset
{
    if(current.roomName == "rm_menu_start" || current.roomName == "rm_load")
    {
        if(current.menuOption == 1)
            return (old.menuFade == 0 && current.menuFade > 0 && settings["StartOnContinue"]);
        
        return (old.namePhase != 3 && current.namePhase == 3);
    }

    else if(old.roomName == "rm_credits_short" && current.roomName == "rm_star1")
        return (settings["Enter_StarlightIsles"]);
}

onReset
{
    if(game != null)
    {
        foreach(string split in vars.splits.Keys) 
            vars.splits[split][0] = false;
        
        print("[TS!Underswap Demo] All splits have been reset to initial state");
    }
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);
    current.roomName = vars.getRoomName();
    if(old.room != current.room)
    {
        if(settings["KillCount"] && old.roomName == "rm_init") // Show the counter on game start
            vars.setText("Kills", 0);

        print("[TS!Underswap Demo] Room: " + old.room + " (" + old.roomName + ")" + " -> " + current.room + " (" + current.roomName + ")");
    }

    if(settings["KillCount"] && old.kills != current.kills)
        vars.setText("Kills", current.kills);
}

split
{
    int done      = 0,
        oldRoom   = 1,
        newRoom   = 2,
        condition = 3;

    foreach(string splitKey in vars.splits.Keys)
    {
        if((!settings[splitKey] || vars.splits[splitKey][done]) ||
           (vars.splits[splitKey][oldRoom] != null && old.roomName != vars.splits[splitKey][oldRoom]) ||
           (vars.splits[splitKey][newRoom] != null && current.roomName != vars.splits[splitKey][newRoom])) continue;

        bool pass = false;
        switch((int)vars.splits[splitKey][condition])
        {
            case 0:
                pass = true;
                break;

            case 1: // Exit_RuinedHome
                pass = (current.roomName.StartsWith("rm_credits")); // The room is named rm_credits in v1.0 and rm_credits_short in v2.0
                break;

            case 2: // v2_Ending
                pass = (old.liftState == 0 && current.liftState != 0);
                break;

            case 3: // v2_DirtyHacker
                pass = (current.text == "dogsong"); // For some reason this pointer also tracks the current song that's playing if there's no textbox up which is pretty funny
                break;

            case 4: // Exit_StarlightIsles
                pass = (current.playerX >= 1362);
                break;
        }

        if(pass)
        {
            vars.splits[splitKey][done] = true;
            print("[TS!Underswap Demo] Split triggered (" + splitKey + ")");
            return true;
        }
    }
}
