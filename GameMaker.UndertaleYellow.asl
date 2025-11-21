// Undertale Yellow Autosplitter by NERS

state("Undertale Yellow", "v1.0")
{
    // Global
    double dialogue : 0x82FC70, 0x48, 0x10, 0x390, 0xA0; // global.dialogue_open

    // Self
    double startWaiter     : 0xA3FD40, 0xD8,  0x48,  0x10, 0xC0,  0x0;                                 // obj_mainmenu.waiter
    double neutralEndScene : 0xA3FD40, 0x1A0, 0x760, 0x88, 0x70,  0x38,  0x48,  0x10, 0x60, 0x0;       // obj_flowey_battle_final_ending_cutscene.scene
    double asgoreFade      : 0xA3FD40, 0x178, 0x70,  0x38, 0x198, 0x1A0, 0x1A0, 0x48, 0x10, 0xE0, 0x0; // obj_battle_enemy_attack_asgore_checker.fade_out
    double genoEndScene    : 0xA3FD40, 0x1A0, 0x4F0, 0x70, 0x38,  0x48,  0x10,  0x60, 0x0;             // obj_castle_throne_room_controller.scene
    double ropeWaiter      : 0xA3FD40, 0x1A0, 0x1B0, 0x90, 0x70,  0x38,  0x48,  0x10, 0xC0, 0x0;       // obj_darkruins_01_rope.waiter

    float cerobaY : 0xA60DA0, 0x8, 0x90, 0x8, 0x68, 0x10, 0xEC; // obj_ceroba_npc.y
}

state("Undertale Yellow", "v1.1 - v1.2.2")
{
    double dialogue : 0x82FC70, 0x48, 0x10, 0x390, 0xA0;

    double startWaiter     : 0xA3FD40, 0xD8,  0x48,  0x10, 0xE0,  0x0;
    double neutralEndScene : 0xA3FD40, 0x1A0, 0x760, 0x88, 0x70,  0x38,  0x48,  0x10, 0x60, 0x0;
    double asgoreFade      : 0xA3FD40, 0x178, 0x70,  0x38, 0x198, 0x1A0, 0x1A0, 0x48, 0x10, 0xE0, 0x0;
    double genoEndScene    : 0xA3FD40, 0x1A0, 0x4F0, 0x70, 0x38,  0x48,  0x10,  0x60, 0x0;
    double ropeWaiter      : 0xA3FD40, 0x1A0, 0x1B0, 0x90, 0x70,  0x38,  0x48,  0x10, 0xE0, 0x0;

    float cerobaY : 0xA60DA0, 0x8, 0x90, 0x8, 0x68, 0x10, 0xEC;
}

startup
{
    refreshRate = 30;
    vars.killRoom = 0;
    vars.tempVar = false;

    settings.Add("F_KillCount", false, "Show kill count (updates on room changes)");
     settings.SetToolTip("F_KillCount", "A new row will appear on your layout with the current room and area kills.");

    settings.Add("F_StartOnContinue", false, "Start / Reset the timer when loading a save file in the first room");

    settings.Add("F_Ruins",            false, "Exit Regular Ruins");
    settings.Add("F_FiveLights",       false, "Exit the five lights puzzle room");
    settings.Add("F_Decibat",          false, "Exit Decibat room");
    settings.Add("F_Dalv",             false, "Exit Dalv room (either side)");
    settings.Add("F_GoldenPear",       false, "Obtain Golden Pear");
    settings.Add("F_GoldenPearExit",   false, "Exit Golden Pear room");
    settings.Add("F_DarkRuins",        false, "Exit Dark Ruins");
    settings.Add("F_Honeydew",         false, "Enter Honeydew Resort");
    settings.Add("F_GoldenCoffee",     false, "Obtain Golden Coffee");
    settings.Add("F_GoldenCoffeeExit", false, "Exit Golden Coffee room");
    settings.Add("F_EnterMartlet",     false, "Enter Martlet room");
    settings.Add("F_ExitMartlet",      false, "Exit Martlet room");
    settings.Add("F_ExitElevator",     false, "Exit East Mines elevator");
    settings.Add("F_ElBailador",       false, "Exit El Bailador room");
    settings.Add("F_EnterWildEast",    false, "Enter Wild East");
    settings.Add("F_FForCeroba",       false, "End Feisty Four / Genocide Ceroba battle");
    settings.Add("F_Starlo",           false, "Exit Starlo room");
    settings.Add("F_GoldenCactus",     false, "Obtain Golden Cactus");
    settings.Add("F_GoldenCactusExit", false, "Exit Golden Cactus room");
    settings.Add("F_GoldenBandana",    false, "Obtain Golden Bandana");
    settings.Add("F_Guardener",        false, "Exit Guardener room");
    settings.Add("F_GreenhouseSkip",   false, "Greenhouse Skip");
     settings.SetToolTip("F_GreenhouseSkip", "This autosplit triggers when you exit the room with the save point after Guardener\n(most common split location for Greenhouse Skip).");
    settings.Add("F_ExitSWElevator",   false, "Exit Steamworks elevator");
    settings.Add("F_EnterComputer",    false, "Enter Computer room");
    settings.Add("F_ExitComputer",     false, "Exit Computer room");
    settings.Add("F_Axis",             false, "Exit Axis room");
    settings.Add("F_Flowey1",          false, "Flowey Flashback (Phase 1 End)");
    settings.Add("F_Zenith1",          false, "Zenith Martlet Flashback (Phase 1 End) / Zenith Warp");
    settings.Add("F_Zenith2",          false, "End Zenith Martlet battle");
    settings.Add("F_NewHome",          false, "Enter New Home");
    settings.Add("F_Ceroba1",          false, "Ceroba Flashback 1");
    settings.Add("F_Ceroba2",          false, "Ceroba Flashback 2");
    settings.Add("F_Ceroba3",          false, "End Pacifist Ceroba battle");
    settings.Add("F_Neutral",           true, "Neutral Ending");
    settings.Add("F_Pacifist",          true, "True Pacifist Ending");
    settings.Add("F_FPacifist",         true, "Flawed Pacifist Ending");
    settings.Add("F_Genocide",          true, "Genocide Ending");
    settings.Add("F_Rope",              true, "Rope Ending");

    vars.splits = new Dictionary<string, Func<dynamic, dynamic, bool>>()
    {
        // org = original (equivalent to old), cur = current (can't use the same names)
        {"F_Ruins",            (org, cur) => org.room == 10 && cur.room == 11},
        {"F_FiveLights",       (org, cur) => org.room == 18 && cur.room == 19},
        {"F_Decibat",          (org, cur) => org.room == 25 && cur.room == 26},
        {"F_Dalv",             (org, cur) => org.room == 34 && (cur.room == 31 || cur.room == 37)},
        {"F_GoldenPear",       (org, cur) => cur.room == 29 && vars.checkItem("G. Pear")},
        {"F_GoldenPearExit",   (org, cur) => org.room == 29 && cur.room == 28},
        {"F_DarkRuins",        (org, cur) => org.room == 35 && cur.room == 43},
        {"F_Honeydew",         (org, cur) => org.room == 58 && cur.room == 59},
        {"F_GoldenCoffee",     (org, cur) => cur.room == 63 && vars.checkItem("G. Coffee")},
        {"F_GoldenCoffeeExit", (org, cur) => org.room == 63 && cur.room == 59},
        {"F_EnterMartlet",     (org, cur) => org.room == 70 && cur.room == 71},
        {"F_ExitMartlet",      (org, cur) => org.room == 71 && cur.room == 72},
        {"F_ExitElevator",     (org, cur) => org.room == 93 && cur.room == 94},
        {"F_ElBailador",       (org, cur) => org.room == 108 && cur.room == 109},
        {"F_EnterWildEast",    (org, cur) => org.room == 126 && cur.room == 127},
        {"F_FForCeroba",       (org, cur) => org.room == 180 && cur.room == 127},
        {"F_Starlo",           (org, cur) => org.room == 135 && cur.room == 136},
        {"F_GoldenCactus",     (org, cur) => cur.room == 83 && vars.checkItem("G. Cactus")},
        {"F_GoldenCactusExit", (org, cur) => org.room == 83 && cur.room == 82},
        {"F_GoldenBandana",    (org, cur) => (cur.room == 167 || cur.room == 275) && vars.checkItem("G. Bandana")},
        {"F_Guardener",        (org, cur) => org.room == 191 && cur.room == 190},
        {"F_GreenhouseSkip",   (org, cur) => org.room == 190 && cur.room == 281},
        {"F_ExitSWElevator",   (org, cur) => org.room == 209 && cur.room == 202},
        {"F_EnterComputer",    (org, cur) => org.room == 202 && cur.room == 205},
        {"F_ExitComputer",     (org, cur) => org.room == 205 && cur.room == 203},
        {"F_Axis",             (org, cur) => org.room == 204 && cur.room == 206},
        {"F_Flowey1",          (org, cur) => org.room == 234 && cur.room == 233},
        {"F_Zenith1",          (org, cur) => (org.room == 72 || org.room == 180) && cur.room == 260},
        {"F_Zenith2",          (org, cur) => org.room == 180 && cur.room == 221},
        {"F_NewHome",          (org, cur) => org.room == 259 && cur.room == 253},
        {"F_Ceroba1",          (org, cur) => org.room == 180 && cur.room == 246},
        {"F_Ceroba2",          (org, cur) => org.room == 180 && cur.room == 250},
        {"F_Ceroba3",          (org, cur) => org.room == 180 && cur.room == 255},
        {"F_Neutral",          (org, cur) => cur.room == 235 && org.neutralEndScene == 5 && cur.neutralEndScene == 6 && vars.tempVar},
        {"F_Pacifist",         (org, cur) => cur.room == 255 && org.cerobaY <= 387 && cur.cerobaY >= 387},
        {"F_FPacifist",        (org, cur) => cur.room == 180 && org.asgoreFade == 0 && cur.asgoreFade == 1 && vars.tempVar},
        {"F_Genocide",         (org, cur) => cur.room == 268 && org.genoEndScene == 35 && (cur.genoEndScene == 36 || cur.genoEndScene == 37)},
        {"F_Rope",             (org, cur) => cur.room == 13 && org.ropeWaiter == 3 && cur.ropeWaiter != 3}
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

    vars.killTextKey = "Kills (Room | Area)";
    vars.dontUpdate = new HashSet<int> {180, 182, 185, 246, 250}; // Battle room, shops, game over screen, Chujin's bedroom, Chujin's basement
    vars.areas = new List<Tuple<int, int, int, int>>
    {
        // Min room, max room, area, max kills per room
        Tuple.Create(13,   42, 1, 5), // Dark Ruins
        Tuple.Create(43,   72, 2, 5), // Snowdin
        Tuple.Create(77,  140, 3, 3), // Dunes
        Tuple.Create(241, 252, 3, 3),
        Tuple.Create(276, 276, 3, 3),
        Tuple.Create(283, 283, 3, 3),
        Tuple.Create(141, 177, 4, 3), // Steamworks
        Tuple.Create(187, 209, 4, 3),
        Tuple.Create(220, 220, 4, 3),
        Tuple.Create(237, 240, 4, 3),
        Tuple.Create(275, 275, 4, 3),
        Tuple.Create(277, 281, 4, 3)
    };
}

shutdown
{
    vars.removeAllTexts();
}

exit
{
    vars.removeAllTexts();
    vars.killRoom = 0;
}

init
{
    var module = modules.First();
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
    Func<int, string, IntPtr> scan = (o, sig) =>
    {
        IntPtr ptr = scanner.Scan(new SigScanTarget(o, sig) { OnFound = (p, s, addr) => addr + p.ReadValue<int>(addr) + 0x4 });
        if(ptr == IntPtr.Zero) throw new NullReferenceException("[Undertale Yellow] Signature scanning failed");
        print("[Undertale Yellow] Signature found at " + ptr.ToString("X"));
        return ptr;
    };
    vars.ptrRoomID = scan(6, "48 ?? ?? ?? 3B 35 ?? ?? ?? ?? 41 ?? ?? ?? 49 ?? ?? E8 ?? ?? ?? ?? FF");

    string hash = "Invalid hash";
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(modules.First().FileName)) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    switch(hash)
    {
        case "427DEFE07AE67CEC2B3E6CCA52390AA6":
            version = "v1.0";

            vars.checkItem = (Func<string, bool>)((itemName) => 
            {
                for(int i = 1; i <= 8; i++)
                    if(new DeepPointer(0x82FC70, 0x48, 0x10, 0x390, 0x20, 0x90, (0x10 * i), 0x0, 0x0).DerefString(game, 32) == itemName) return true;
                
                return false;
            });
            break;

        case "2610A3F58304DE377DA56C221FC68D6B":
            version = "v1.1 - v1.2.2";

            vars.checkItem = (Func<string, bool>)((itemName) => 
            {
                for(int i = 1; i <= 8; i++)
                    if(new DeepPointer(0x82FC70, 0x48, 0x10, 0x390, 0x20, 0x90, (0x10 * i), 0x0, 0x0).DerefString(game, 32) == itemName) return true;
                
                return false;
            });
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Yellow is currently not supported by the autosplitter.\n\n" +

                "Supported versions: Full Game v1.0 - v1.2.2.",
                "LiveSplit | Undertale Yellow", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }

    print("[Undertale Yellow] Version: " + version + " (" + hash + ")");
}

start
{
    if(current.room == 2 || current.room == 3)
        return (old.startWaiter == 0 && current.startWaiter == 1);

    else
        return (old.room <= 3 && current.room == 6 && old.startWaiter == 0 && settings["F_StartOnContinue"]);
}

reset
{
    if(current.room == 2 || current.room == 3)
        return (old.startWaiter == 0 && current.startWaiter == 1);

    else
        return (old.room <= 3 && current.room == 6 && old.startWaiter == 0 && settings["F_StartOnContinue"]);       
}

onReset
{
    vars.tempVar = false;
    vars.completedSplits.Clear();
    print("[Undertale Yellow] All splits have been reset to initial state");
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);
    if(old.room != current.room)
    {
        if(old.room == 269 && current.room == 180 && settings["F_FPacifist"] && !vars.tempVar) // Entered the Flawed Pacifist Asgore battle
            vars.tempVar = true; // Added for the ending autosplit check because room 180 is used for every battle, so this is mainly just to be safe 

        if(settings["F_KillCount"] && !vars.dontUpdate.Contains(current.room))
        {
            var tuple = ((List<Tuple<int, int, int, int>>)vars.areas).FirstOrDefault(t => current.room >= t.Item1 && current.room <= t.Item2);
            if(tuple != null)
            {
                /* 
                Pretty much copy-pasted obj_rndenc_Other_4
                I could have gotten a pointer path to global.kill_area_current, however any that I tried would occassionally break during specific situations
                Areas array sizes:
                Dark Ruins = 0-6
                Snowdin    = 0-7
                Dunes      = 0-8
                Steamworks = 0-12 
                */
                switch((int)current.room)
                {
                    case 16: case 47: case 79: case 164:
                        vars.killRoom = 0;
                        break;
                    case 18: case 48: case 80: case 169:
                        vars.killRoom = 1;
                        break;
                    case 24: case 51: case 81: case 173:
                        vars.killRoom = 2;
                        break;
                    case 20: case 54: case 82: case 176:
                        vars.killRoom = 3;
                        break;
                    case 22: case 61: case 84: case 177:
                        vars.killRoom = 4;
                        break;
                    case 26: case 64: case 87: case 190:
                        vars.killRoom = 5;
                        break;
                    case 27: case 67: case 88: case 195:
                        vars.killRoom = 6;
                        break;
                    case 68: case 95: case 196:
                        vars.killRoom = 7;
                        break;
                    case 113: case 198:
                        vars.killRoom = 8;
                        break;
                    case 199:
                        vars.killRoom = 9;
                        break;
                    case 200:
                        vars.killRoom = 10;
                        break;
                    case 281:
                        vars.killRoom = 11;
                        break;
                    case 202:
                        vars.killRoom = 12;
                        break;
                }

                int area = tuple.Item3, mKills = tuple.Item4;
                double rKills = new DeepPointer(0x82FC70, 0x48, 0x10, 0x10E0, 0x0,  0x90, (0x10 * area), 0x90, (0x10 * (int)vars.killRoom)).Deref<double>(game);
                double tKills = new DeepPointer(0x82FC70, 0x48, 0x10, 0x10E0, 0x10, 0x90, (0x10 * area)).Deref<double>(game);
                vars.setText(vars.killTextKey, ((mKills - rKills) + "/" + mKills + " | " + (20 - tKills) + "/20"));
            }
            else vars.setText(vars.killTextKey, "Invalid Area");
        }
        
        print("[Undertale Yellow] Room: " + old.room + " -> " + current.room);
    }

    if(current.room == 235 && current.neutralEndScene == 4 && current.dialogue == 1 && settings["F_Neutral"] && !vars.tempVar)
        vars.tempVar = true; // Added for the ending autosplit check because neutralEndScene takes random values in the Flowey battle and would make the split trigger
}

split
{
    foreach(var split in vars.splits)
    {
        if(!settings[split.Key] || 
           vars.completedSplits.Contains(split.Key) ||
           !split.Value(old, current)) continue;

        vars.completedSplits.Add(split.Key);
        print("[Undertale Yellow] Split triggered (" + split.Key + ")");
        return true;
    }
}
