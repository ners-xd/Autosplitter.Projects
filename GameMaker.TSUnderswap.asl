// TS!Underswap Autosplitter by NERS

state("TS!Underswap", "v1.0.8")
{
    // Global
    double kills : 0x6FCAF4, 0x30, 0x600, 0x20; // global.playerkills

    // Self
    double namePhase  : 0x6EFDE8, 0x84,  0x14C, 0x2C, 0x10, 0x264, 0x0; // obj_namehandler.phase
    double menuOption : 0x6EFDE8, 0x24C, 0x84,  0x2C, 0x10, 0x1BC, 0x0; // obj_menuhandler.selected

    string8 menuContinue : 0x6EFDE8, 0x84, 0x2C, 0x10, 0x2E8, 0x0, 0x6C, 0x80, 0x10;
}

state("TS!Underswap", "v2.0.4")
{
    double kills : 0xB7B040, 0x48, 0x10, 0x170, 0x20;

    float  playerX    : 0xB680E8, 0x0,  0x868, 0x18, 0x68,  0x10,  0xF0; // obj_player.x
    double namePhase  : 0xD8AB08, 0xE0, 0x48,  0x10, 0x310, 0x0;
    double menuOption : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10,  0x3D0, 0x0;
    double liftState  : 0xDAB2F0, 0x8,  0x48,  0x10, 0x3E0, 0x0;         // obj_crys_lift.state

    string8  menuContinue : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10, 0x320, 0x0, 0x8, 0x80, 0x10;
    string32 song         : 0xD8AB08, 0xE0, 0x48,  0x10, 0xB0, 0x0,   0x0, 0x0;
}

state("TS!Underswap", "v2.0.9")
{
    double kills : 0xB7B040, 0x48, 0x10, 0x180, 0x20;

    float  playerX    : 0xB680E8, 0x0,  0x858, 0x18, 0x68,  0x10,  0xF0;
    double namePhase  : 0xD8AB08, 0xE0, 0x48,  0x10, 0xF0,  0x0;
    double menuOption : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10,  0x3D0, 0x0;
    double liftState  : 0xAE5250, 0xB0, 0x48,  0x10, 0x120, 0x0;

    string8  menuContinue : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10, 0x2D0, 0x0, 0x8, 0x80, 0x10;
    string32 song         : 0xD8AB08, 0xE0, 0x48,  0x10, 0xB0, 0x0,   0x0, 0x0;
}

startup
{
    refreshRate = 30;

    settings.Add("KillCount", false, "Show kill count");
    settings.SetToolTip("KillCount", "A new row will appear on your layout with the total amount of kills\non the current save file.");

    settings.Add("StartOnContinue",      false, "Start/Reset the timer when loading a save file");
    settings.Add("Start_StarlightIsles", false, "Start/Reset the timer when entering Starlight Isles");
    settings.SetToolTip("Start_StarlightIsles", "This setting is mainly used for IL (Individual Level) runs.");

    settings.Add("Ruined_Home", true, "Ruined Home");
    settings.CurrentDefaultParent = "Ruined_Home";
    settings.Add("Exit_LongHallway",     false, "Exit Long Hallway");
    settings.Add("Exit_TripleFlower",    false, "Exit Triple Flower Puzzle room");
    settings.Add("Exit_RuinedKnights",   false, "Exit Ruined Knights room");
    settings.Add("Exit_SingleRock",      false, "Exit Single Rock Puzzle room");
    settings.Add("Enter_MadDummyBridge", false, "Enter Mad Dummy bridge room");
    settings.Add("Exit_Sewers",          false, "Exit Sewers");
    settings.Add("Exit_Greasers",        false, "Exit Greasers room");
    settings.Add("Exit_Mettalot",        false, "Exit Mettalot room");
    settings.Add("Exit_RuinedHome",      false, "Exit Ruined Home");
    settings.Add("v1_Ending",             true, "v1.0 Ending");
    settings.CurrentDefaultParent = null;
    
    settings.Add("Starlight_Isles", true, "Starlight Isles");
    settings.CurrentDefaultParent = "Starlight_Isles";
    settings.Add("Enter_SubDoggo",      false, "Enter Sub-Doggo room");
    settings.Add("Exit_SubDoggo",       false, "Exit Sub-Doggo room");
    settings.Add("Exit_Dogi",           false, "Exit Dogi room");
    settings.Add("Exit_TripleRock",     false, "Exit Triple Rock Puzzle room");
    settings.Add("Exit_Muffet",         false, "Exit Muffet room");
    settings.Add("Exit_KoffinKeep",     false, "Exit Koffin Keep");
    settings.Add("Exit_HarryLarry",     false, "Exit Harry & Larry room");
    settings.Add("Exit_FerrisWheel",    false, "Exit Ferris Wheel room");
    settings.Add("Enter_CBArena",       false, "Enter Crossbones arena");
    settings.Add("Exit_CBArena",        false, "Exit Crossbones arena");
    settings.Add("v2_DirtyHacker",       true, "v2.0 Dirty Hacker Ending");
    settings.Add("Exit_StarlightIsles", false, "Exit Starlight Isles");
    settings.Add("v2_Ending",            true, "v2.0 Ending");
    settings.CurrentDefaultParent = null;

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
        tc.Settings.OverrideFont2 = true;
        tc.Settings.Font2 = timer.LayoutSettings.TimesFont;
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

        if(ptr == IntPtr.Zero) throw new NullReferenceException("[TS!Underswap] Signature scanning failed");
        print("[TS!Underswap] Signature found at " + ptr.ToString("X"));
        return ptr;
    };
    
    IntPtr ptrRoomArray = vars.x64 
        ? scan(5, "74 0C 48 8B 05 ?? ?? ?? ?? 48 8B 04 D0")
        : scan(2, "8B 3D ?? ?? ?? ?? 2B EF");

    vars.ptrRoomID = vars.x64 
        ? scan(6, "48 ?? ?? ?? 3B 35 ?? ?? ?? ?? 41 ?? ?? ?? 49 ?? ?? E8 ?? ?? ?? ?? FF")
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

        case "47531919D1B83B43AEE93E80347119C0":
            version = "v2.0.9";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of TS!Underswap is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.\n\n" +
                "Supported versions: v1.0.8, v2.0.4, v2.0.9.",
                "LiveSplit | TS!Underswap", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[TS!Underswap] Version: " + version + " (" + hash + ")");

    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old room, new room, special condition
        {"Exit_LongHallway",     new object[] {false, "rm_ruin6_long",        "rm_ruin7",            0}},
        {"Exit_TripleFlower",    new object[] {false, "rm_ruin9_gl2",         "rm_ruin14",           0}},
        {"Exit_RuinedKnights",   new object[] {false, "rm_ruin16",            "rm_ruin16B",          0}},
        {"Exit_SingleRock",      new object[] {false, "rm_ruin21_g2r2",       "rm_ruin22_g2r3",      0}},
        {"Enter_MadDummyBridge", new object[] {false, "rm_ruin23",            "rm_ruin24",           0}},
        {"Exit_Sewers",          new object[] {false, "rm_ruins5",            "rm_ruinc_main",       0}},
        {"Exit_Greasers",        new object[] {false, "rm_ruinc_alley1",      "rm_ruinc_main",       0}},
        {"Exit_Mettalot",        new object[] {false, "rm_ruinc_square",      "rm_ruinc_end",        0}},
        {"Exit_RuinedHome",      new object[] {false, "rm_ruina_final",       null,                  1}},
        {"v1_Ending",            new object[] {false, "rm_star3",             "rm_demoend",          0}},

        {"Enter_SubDoggo",       new object[] {false, "rm_star8",             "rm_star9_doggo",      0}},
        {"Exit_SubDoggo",        new object[] {false, "rm_star9_doggo",       "rm_star10",           0}},
        {"Exit_Dogi",            new object[] {false, "rm_star13_marriage",   "rm_star14",           0}},
        {"Exit_TripleRock",      new object[] {false, "rm_star15",            "rm_star16",           0}},
        {"Exit_Muffet",          new object[] {false, null,                   "rm_star19_outcave",   2}},
        {"Exit_KoffinKeep",      new object[] {false, "rm_stark_front",       "rm_star23_chase2",    0}},
        {"Exit_HarryLarry",      new object[] {false, "rm_stars_mountain4",   "rm_stars_mountain3",  0}},
        {"Exit_FerrisWheel",     new object[] {false, "rm_stars_ferriswheel", "rm_stars_crossroads", 0}},
        {"Enter_CBArena",        new object[] {false, "rm_stars_residential", "rm_stars_cb_arena",   0}},
        {"Exit_CBArena",         new object[] {false, "rm_stars_cb_arena",    "rm_stars_bridge",     0}},
        {"v2_DirtyHacker",       new object[] {false, null,                   "rm_terribleend",      3}},
        {"Exit_StarlightIsles",  new object[] {false, null,                   "rm_stars_bridge",     4}},
        {"v2_Ending",            new object[] {false, null,                   "rm_crys_entermines",  5}}
    };
}

start
{
    if(current.roomName == "rm_menu_start" || current.roomName == "rm_load")
    {
        if(current.menuOption == 1)
            return (old.menuContinue != null && current.menuContinue == null && settings["StartOnContinue"]);
        
        return (old.namePhase != 3 && current.namePhase == 3);
    }

    else if(old.roomName == "rm_credits_short" && current.roomName == "rm_star1")
        return (settings["Start_StarlightIsles"]);
}

reset
{
    if(current.roomName == "rm_menu_start" || current.roomName == "rm_load")
    {
        if(current.menuOption == 1)
            return (old.menuContinue != null && current.menuContinue == null && settings["StartOnContinue"]);
        
        return (old.namePhase != 3 && current.namePhase == 3);
    }

    else if(old.roomName == "rm_credits_short" && current.roomName == "rm_star1")
        return (settings["Start_StarlightIsles"]);
}

onReset
{
    if(game != null)
    {
        foreach(string split in vars.splits.Keys) 
            vars.splits[split][0] = false;
        
        print("[TS!Underswap] All splits have been reset to initial state");
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

        print("[TS!Underswap] Room: " + old.room + " (" + old.roomName + ")" + " -> " + current.room + " (" + current.roomName + ")");
    }

    if(settings["KillCount"] && old.kills != current.kills && current.kills % 1 == 0)
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
                pass = (current.roomName == "rm_credits" || current.roomName == "rm_credits_short"); // The room name is different depending on the game version
                break;

            case 2: // Exit_Muffet
                pass = (old.roomName == "rm_star17_long" || old.roomName == "rm_star18_cave"); // You can exit from two different rooms depending on the route
                break;

            case 3: // v2_DirtyHacker
                pass = (old.song != "dogsong" && current.song == "dogsong");
                break;

            case 4: // Exit_StarlightIsles
                pass = (current.playerX >= 1362);
                break;
                
            case 5: // v2_Ending
                pass = (old.liftState == 0 && current.liftState != 0);
                break;
        }

        if(pass)
        {
            vars.splits[splitKey][done] = true;
            print("[TS!Underswap] Split triggered (" + splitKey + ")");
            return true;
        }
    }
}
