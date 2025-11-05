// TS!Underswap Autosplitter by NERS

state("TS!Underswap", "v1.0.8")
{
    // Global
    double kills : 0x6FCAF4, 0x30, 0x600, 0x20; // global.playerkills

    // Self
    double namePhase  : 0x6EFDE8, 0x84,  0x14C, 0x2C, 0x10, 0x264, 0x0; // obj_namehandler.phase
    double menuOption : 0x6EFDE8, 0x24C, 0x84,  0x2C, 0x10, 0x1BC, 0x0; // obj_menuhandler.selected

    string32 menuContinue : 0x6EFDE8, 0x84, 0x2C, 0x10, 0x2E8, 0x0, 0x6C, 0x80, 0x10; // obj_menuhandler.storedText[6]
}

state("TS!Underswap", "v2.0.4")
{
    double kills : 0xB7B040, 0x48, 0x10, 0x170, 0x20;

    float  playerX    : 0xB680E8, 0x0,  0x868, 0x18, 0x68,  0x10,  0xF0; // obj_player.x
    double namePhase  : 0xD8AB08, 0xE0, 0x48,  0x10, 0x310, 0x0;
    double menuOption : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10,  0x3D0, 0x0;
    double liftState  : 0xDAB2F0, 0x8,  0x48,  0x10, 0x3E0, 0x0;         // obj_crys_lift.state

    string32 menuContinue : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10, 0x320, 0x0, 0x8, 0x80, 0x10;
    string32 song         : 0xD8AB08, 0xE0, 0x48,  0x10, 0xB0, 0x0,   0x0, 0x0; // Name of the current song
}

state("TS!Underswap", "v2.0.9 / v2.0.10")
{
    double kills : 0xB7B040, 0x48, 0x10, 0x180, 0x20;

    float  playerX    : 0xB680E8, 0x0,  0x858, 0x18, 0x68,  0x10,  0xF0;
    double namePhase  : 0xD8AB08, 0xE0, 0x48,  0x10, 0xF0,  0x0;
    double menuOption : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10,  0x3D0, 0x0;
    double liftState  : 0xAE5250, 0xB0, 0x48,  0x10, 0x120, 0x0;

    string32 menuContinue : 0xD8AB08, 0xE0, 0x1A8, 0x48, 0x10, 0x2D0, 0x0, 0x8, 0x80, 0x10;
    string32 song         : 0xD8AB08, 0xE0, 0x48,  0x10, 0xB0, 0x0,   0x0, 0x0;
}

startup
{
    refreshRate = 30;

    settings.Add("KillCount", false, "Show kill count");
    settings.SetToolTip("KillCount", "A new row will appear on your layout with the total amount of kills\non the current save file.");

    settings.Add("StartOnContinue",      false, "Start / Reset the timer when loading a save file");
    settings.Add("Start_StarlightIsles", false, "Start / Reset the timer when entering Starlight Isles");
     settings.SetToolTip("Start_StarlightIsles", "This setting is mainly used for IL runs.");

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

    vars.splits = new Dictionary<string, Func<dynamic, dynamic, bool>>()
    {
        // org = original (equivalent to old), cur = current (can't use the same names)
        {"Exit_LongHallway",     (org, cur) => org.roomName == "rm_ruin6_long" && cur.roomName == "rm_ruin7"},
        {"Exit_TripleFlower",    (org, cur) => org.roomName == "rm_ruin9_gl2" && cur.roomName == "rm_ruin14"},
        {"Exit_RuinedKnights",   (org, cur) => org.roomName == "rm_ruin16" && cur.roomName == "rm_ruin16B"},
        {"Exit_SingleRock",      (org, cur) => org.roomName == "rm_ruin21_g2r2" && cur.roomName == "rm_ruin22_g2r3"},
        {"Enter_MadDummyBridge", (org, cur) => org.roomName == "rm_ruin23" && cur.roomName == "rm_ruin24"},
        {"Exit_Sewers",          (org, cur) => org.roomName == "rm_ruins5" && cur.roomName == "rm_ruinc_main"},
        {"Exit_Greasers",        (org, cur) => org.roomName == "rm_ruinc_alley1" && cur.roomName == "rm_ruinc_main"},
        {"Exit_Mettalot",        (org, cur) => org.roomName == "rm_ruinc_square" && cur.roomName == "rm_ruinc_end"},
        {"Exit_RuinedHome",      (org, cur) => org.roomName == "rm_ruina_final" && (cur.roomName == "rm_credits" || cur.roomName == "rm_credits_short")},
        {"v1_Ending",            (org, cur) => org.roomName == "rm_star3" && cur.roomName == "rm_demoend"},

        {"Enter_SubDoggo",      (org, cur) => org.roomName == "rm_star8" && cur.roomName == "rm_star9_doggo"},
        {"Exit_SubDoggo",       (org, cur) => org.roomName == "rm_star9_doggo" && cur.roomName == "rm_star10"},
        {"Exit_Dogi",           (org, cur) => org.roomName == "rm_star13_marriage" && cur.roomName == "rm_star14"},
        {"Exit_TripleRock",     (org, cur) => org.roomName == "rm_star15" && cur.roomName == "rm_star16"},
        {"Exit_Muffet",         (org, cur) => (org.roomName == "rm_star17_long" || org.roomName == "rm_star18_cave") && cur.roomName == "rm_star19_outcave"},
        {"Exit_KoffinKeep",     (org, cur) => org.roomName == "rm_stark_front" && cur.roomName == "rm_star23_chase2"},
        {"Exit_HarryLarry",     (org, cur) => org.roomName == "rm_stars_mountain4" && cur.roomName == "rm_stars_mountain3"},
        {"Exit_FerrisWheel",    (org, cur) => org.roomName == "rm_stars_ferriswheel" && cur.roomName == "rm_stars_crossroads"},
        {"Enter_CBArena",       (org, cur) => org.roomName == "rm_stars_residential" && cur.roomName == "rm_stars_cb_arena"},
        {"Exit_CBArena",        (org, cur) => org.roomName == "rm_stars_cb_arena" && cur.roomName == "rm_stars_bridge"},
        {"v2_DirtyHacker",      (org, cur) => cur.roomName == "rm_terribleend" && org.song != "dogsong" && cur.song == "dogsong"},
        {"Exit_StarlightIsles", (org, cur) => cur.roomName == "rm_stars_bridge" && cur.playerX >= 1362},
        {"v2_Ending",           (org, cur) => cur.roomName == "rm_crys_entermines" && org.liftState == 0 && cur.liftState != 0}
    };
    vars.completedSplits = new HashSet<string>();

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

    string hash = "Invalid hash";
    string gameFile = new FileInfo(module.FileName).DirectoryName + @"\data\game.dxb";
    if(File.Exists(gameFile))
    {
        using(var md5 = System.Security.Cryptography.MD5.Create())
            using(var fs = File.OpenRead(gameFile))
                hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));
    }
    switch(hash)
    {
        case "BB9CF694EB1353F3C168362FAF76F580":
            version = "v1.0.8";
            break;

        case "675707015AFC412444119698E30E0F52":
            version = "v2.0.4";
            break;

        case "47531919D1B83B43AEE93E80347119C0":
            version = "v2.0.9 / v2.0.10";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of TS!Underswap is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.\n\n" +

                "Supported versions: v1.0.8, v2.0.4, v2.0.9, v2.0.10.",
                "LiveSplit | TS!Underswap", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[TS!Underswap] Version: " + version + " (" + hash + ")");

    if(version != "Unknown" && settings["KillCount"])
        vars.setText("Kills", 0);
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
    vars.completedSplits.Clear();
    print("[TS!Underswap] All splits have been reset to initial state");
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);
    current.roomName = vars.getRoomName();
    if(old.room != current.room)
        print("[TS!Underswap] Room: " + old.room + " (" + old.roomName + ")" + " -> " + current.room + " (" + current.roomName + ")");

    if(settings["KillCount"] && old.kills != current.kills && current.kills % 1 == 0)
        vars.setText("Kills", current.kills);
}

split
{
    foreach(var split in vars.splits)
    {
        if(!settings[split.Key] || 
           vars.completedSplits.Contains(split.Key) ||
           !split.Value(old, current)) continue;

        vars.completedSplits.Add(split.Key);
        print("[TS!Underswap] Split triggered (" + split.Key + ")");
        return true;
    }
}
