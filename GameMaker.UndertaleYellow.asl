// Undertale Yellow Autosplitter by NERS

state("Undertale Yellow", "v1.0")
{
    // Global
    double dialogue : 0x82FC70, 0x48, 0x10, 0x390, 0xA0; // global.dialogue_open

    // Self
    double startWaiter      : 0xA3FD40, 0xD8,  0x48,  0x10, 0xC0,  0x0;                                  // obj_mainmenu.waiter
    double neutralEndScene  : 0xA3FD40, 0x1A0, 0x760, 0x88, 0x70,  0x38,  0x48,  0x10, 0x60,  0x0;       // obj_flowey_battle_final_ending_cutscene.scene
    double pacifistEndScene : 0xA3FD40, 0x1E8, 0x30,  0x38, 0x198, 0x198, 0x198, 0x48, 0x10,  0x60, 0x0; // obj_newhome_03_cutscene_postfight_spare.scene
    double soulSpeed        : 0xA3FD40, 0x178, 0x88,  0x70, 0x78,  0x1A0, 0x48,  0x10, 0x490, 0x0;       // obj_heart_battle_fighting_parent.walk_speed
    double genoEndScene     : 0xA3FD40, 0x1A0, 0x4F0, 0x70, 0x38,  0x48,  0x10,  0x60, 0x0;              // obj_castle_throne_room_controller.scene
    double ropeWaiter       : 0xA3FD40, 0x1A0, 0x1B0, 0x90, 0x70,  0x38,  0x48,  0x10, 0xC0,  0x0;       // obj_darkruins_01_rope.waiter
}

state("Undertale Yellow", "v1.1")
{
    double dialogue : 0x82FC70, 0x48, 0x10, 0x390, 0xA0; 

    double startWaiter      : 0xA3FD40, 0xD8,  0x48,  0x10, 0xE0,  0x0;                        
    double neutralEndScene  : 0xA3FD40, 0x1A0, 0x760, 0x88, 0x70,  0x38,  0x48,  0x10, 0x60,  0x0;
    double pacifistEndScene : 0xA3FD40, 0x1E8, 0x30,  0x38, 0x198, 0x198, 0x198, 0x48, 0x10,  0x60, 0x0;   
    double soulSpeed        : 0xA3FD40, 0x178, 0x88,  0x70, 0x78,  0x1A0, 0x48,  0x10, 0x490, 0x0;
    double genoEndScene     : 0xA3FD40, 0x1A0, 0x4F0, 0x70, 0x38,  0x48,  0x10,  0x60, 0x0;             
    double ropeWaiter       : 0xA3FD40, 0x1A0, 0x1B0, 0x90, 0x70,  0x38,  0x48,  0x10, 0xE0,  0x0;
}

startup
{
    refreshRate  = 30;
    vars.tempVar = false;
    vars.offset  = new Stopwatch();

    settings.Add("F_KillCount", false, "Show kill count (updates on room changes)");
    settings.SetToolTip("F_KillCount", "A new row will appear on your layout with the current room and area kills.");

    settings.Add("F_StartOnContinue", false, "Start/Reset the timer when loading a save file");

    settings.Add("F_Ruins",            false, "Exit Regular Ruins");
    settings.Add("F_FiveLights",       false, "Exit the five lights puzzle room");
    settings.Add("F_Decibat",          false, "Exit Decibat room");
    settings.Add("F_Dalv",             false, "Exit Dalv room");
    settings.Add("F_GoldenPear",       false, "Obtain Golden Pear");
    settings.Add("F_GoldenPearExit",   false, "Exit Golden Pear room");
    settings.Add("F_DarkRuins",        false, "Exit Dark Ruins");
    settings.Add("F_Honeydew",         false, "Enter Honeydew Resort");
    settings.Add("F_GoldenCoffee",     false, "Obtain Golden Coffee");
    settings.Add("F_GoldenCoffeeExit", false, "Exit Golden Coffee room");
    settings.Add("F_EnterMartlet",     false, "Enter Martlet room");
    settings.Add("F_ExitMartlet",      false, "Exit Martlet room");
    settings.Add("F_ElBailador",       false, "Enter the dimensional bag room");
    settings.Add("F_FForCeroba",       false, "End Feisty Four / Genocide Ceroba battle");
    settings.Add("F_Starlo",           false, "Exit Starlo room");
    settings.Add("F_GoldenCactus",     false, "Obtain Golden Cactus");
    settings.Add("F_GoldenCactusExit", false, "Exit Golden Cactus room");
    settings.Add("F_GoldenBandana",    false, "Obtain Golden Bandana");
    settings.Add("F_Guardener",        false, "Exit Guardener room");
    settings.Add("F_GreenhouseSkip",   false, "Greenhouse Skip");
    settings.SetToolTip("F_GreenhouseSkip", "This autosplit triggers when you exit the room with the savepoint after Guardener\n(most common split location for Greenhouse Skip).");
    settings.Add("F_Axis",             false, "Exit Axis room");
    settings.Add("F_Flowey1",          false, "Flowey Flashback (Phase 1 End)");
    settings.Add("F_Zenith1",          false, "Zenith Martlet Flashback (Phase 1 End)");
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

    vars.killTextKey = "Kills (Room | Area)";
    vars.dontUpdate = new HashSet<int> { 180, 182, 185, 246, 250 }; // Battle room, shops, game over screen, Chujin's bedroom, Chujin's basement
    vars.areas = new List<Tuple<int, int, int, int>>
    {
        // Min room, max room, area, max kills per room
        Tuple.Create(13,   42, 1, 5), // Dark Ruins
        Tuple.Create(43,   72, 2, 5), // Snowdin
        Tuple.Create(77,  140, 3, 3), // Dunes
        Tuple.Create(241, 252, 3, 3), //
        Tuple.Create(276, 276, 3, 3), //
        Tuple.Create(283, 283, 3, 3), //
        Tuple.Create(141, 177, 4, 3), // Steamworks
        Tuple.Create(187, 209, 4, 3), //
        Tuple.Create(220, 220, 4, 3), //
        Tuple.Create(237, 240, 4, 3), //
        Tuple.Create(275, 275, 4, 3), //
        Tuple.Create(277, 281, 4, 3)  //
    };
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
    string hash;
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(modules.First().FileName)) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    var module = modules.First();
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
    Func<int, string, IntPtr> scan = (o, sig) =>
    {
        IntPtr ptr = scanner.Scan(new SigScanTarget(o, sig) { OnFound = (p, s, addr) => addr + p.ReadValue<int>(addr) + 0x4 });
        if(ptr == IntPtr.Zero) throw new NullReferenceException("[Undertale Yellow] Signature scanning failed");
        print("[Undertale Yellow] Signature found at " + ptr.ToString("X"));
        return ptr;
    };
    vars.ptrRoomID = scan(9, "48 8B 05 ?? ?? ?? ?? 89 3D ?? ?? ?? ??");

    vars.killRoom = 0;
    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old room, new room, special condition
        {"F_Ruins",            new object[] {false,  10,  11, 0}},
        {"F_FiveLights",       new object[] {false,  18,  19, 0}},
        {"F_Decibat",          new object[] {false,  25,  26, 0}},
        {"F_Dalv",             new object[] {false,  34,  37, 0}},
        {"F_GoldenPear",       new object[] {false,  -1,  29, 1}},
        {"F_GoldenPearExit",   new object[] {false,  29,  28, 0}},
        {"F_DarkRuins",        new object[] {false,  35,  43, 0}},
        {"F_Honeydew",         new object[] {false,  58,  59, 0}},
        {"F_GoldenCoffee",     new object[] {false,  -1,  63, 2}},
        {"F_GoldenCoffeeExit", new object[] {false,  63,  59, 0}},
        {"F_EnterMartlet",     new object[] {false,  70,  71, 0}},
        {"F_ExitMartlet",      new object[] {false,  71,  72, 0}},
        {"F_ElBailador",       new object[] {false,  -1, 109, 0}},
        {"F_FForCeroba",       new object[] {false, 180, 127, 0}},
        {"F_Starlo",           new object[] {false, 135, 136, 0}},
        {"F_GoldenCactus",     new object[] {false,  -1,  83, 3}},
        {"F_GoldenCactusExit", new object[] {false,  83,  82, 0}},
        {"F_GoldenBandana",    new object[] {false,  -1,  -1, 4}}, // Can be obtained in different rooms depending on the route
        {"F_Guardener",        new object[] {false, 191, 190, 0}},
        {"F_GreenhouseSkip",   new object[] {false, 190, 281, 0}},
        {"F_Axis",             new object[] {false, 204, 206, 0}},
        {"F_Flowey1",          new object[] {false, 234, 233, 0}},
        {"F_Zenith1",          new object[] {false,  -1, 260, 0}},
        {"F_Zenith2",          new object[] {false, 180, 221, 0}},
        {"F_NewHome",          new object[] {false, 259, 253, 0}},
        {"F_Ceroba1",          new object[] {false, 180, 246, 0}},
        {"F_Ceroba2",          new object[] {false, 180, 250, 0}},
        {"F_Ceroba3",          new object[] {false, 180, 255, 0}},
        {"F_Neutral",          new object[] {false,  -1, 235, 5}},
        {"F_Pacifist",         new object[] {false,  -1, 255, 6}}, // Special offset required
        {"F_FPacifist",        new object[] {false,  -1, 180, 7}},
        {"F_Genocide",         new object[] {false,  -1, 268, 8}},
        {"F_Rope",             new object[] {false,  -1,  13, 9}}
    };

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
            version = "v1.1";

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
                "This version of Undertale Yellow is currently not supported by the autosplitter.\nPlease wait until it receives an update.",
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
        return (old.room <= 3 && current.room >= 6 && old.startWaiter == 0 && settings["F_StartOnContinue"]);
}

reset
{
    if(current.room == 2 || current.room == 3)
        return (old.startWaiter == 0 && current.startWaiter == 1);

    else
        return (old.room <= 3 && current.room >= 6 && old.startWaiter == 0 && settings["F_StartOnContinue"]);       
}

onReset
{
    vars.offset.Reset();
    vars.tempVar = false;

    if(game != null)
    {
        foreach(string split in vars.splits.Keys) 
            vars.splits[split][0] = false;
        
        print("[Undertale Yellow] All splits have been reset to initial state");
    }
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);
    if(old.room != current.room)
    {
        if(old.room == 269 && current.room == 180 && settings["F_FPacifist"]) // Entered the Flawed Pacifist Asgore battle
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

    if(current.room == 255 && !vars.offset.IsRunning && (current.pacifistEndScene == 261 || current.pacifistEndScene2 == 261) && settings["F_Pacifist"]) 
        vars.offset.Start(); // Start the stopwatch after Ceroba faces down

    else if(current.room == 235 && current.neutralEndScene == 4 && current.dialogue == 1 && settings["F_Neutral"]) // Entered the cutscene at the end of Neutral
        vars.tempVar = true; // Added for the ending autosplit check because neutralEndScene takes random values in the Flowey battle and makes the split trigger
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
           (vars.splits[splitKey][oldRoom] != -1 && old.room != vars.splits[splitKey][oldRoom]) ||
           (vars.splits[splitKey][newRoom] != -1 && current.room != vars.splits[splitKey][newRoom])) continue;

        bool pass = false;
        switch((int)vars.splits[splitKey][condition])
        {
            case 0:
                pass = true;
                break;

            case 1: // F_GoldenPear
                pass = (vars.checkItem("G. Pear"));
                break;

            case 2: // F_GoldenCoffee
                pass = (vars.checkItem("G. Coffee"));
                break;

            case 3: // F_GoldenCactus
                pass = (vars.checkItem("G. Cactus"));
                break;

            case 4: // F_GoldenBandana
                pass = ((current.room == 167 || current.room == 275) && vars.checkItem("G. Bandana"));
                break;

            case 5: // F_Neutral
                pass = (vars.tempVar == true && old.neutralEndScene == 5 && current.neutralEndScene == 6);
                break;

            case 6: // F_Pacifist
                if(vars.offset.ElapsedMilliseconds >= 2250)
                {
                    vars.offset.Reset();
                    pass = true;
                }
                break;

            case 7: // F_FPacifist
                pass = (vars.tempVar == true && old.soulSpeed == 1 && current.soulSpeed == 0);
                break;

            case 8: // F_Genocide
                pass = (old.genoEndScene == 35 && (current.genoEndScene == 36 || current.genoEndScene == 37)); // Sometimes it goes to 36, sometimes 37 on the same frame
                break;

            case 9: // F_Rope
                pass = (old.ropeWaiter == 3 && current.ropeWaiter == 4);
                break;
        }

        if(pass)
        {   
            vars.splits[splitKey][done] = true;
            print("[Undertale Yellow] Split triggered (" + splitKey + ")");
            return true;
        }
    }
}
