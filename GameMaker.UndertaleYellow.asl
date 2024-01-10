// Undertale Yellow Autosplitter by NERS

state("Undertale Yellow", "v1.1")
{
    // Static
    int room : 0xA3FCF4;

    // Self
    double startFade1       : 0x802990, 0x10,  0xD8,  0x48,  0x10,  0x0,  0x0;
    double startFade2       : 0x802990, 0x18,  0xD8,  0x48,  0x10,  0x0,  0x0;
    double neutralEndScene  : 0xA4F100, 0x1A0, 0x1A0, 0x198, 0x198, 0x48, 0x10, 0x60,  0x0;
    double pacifistEndScene : 0xA60DA0, 0x20,  0x1A0, 0x1A0, 0x48,  0x10, 0x60, 0x0;
    double soulSpeed        : 0xA4F338, 0x28,  0x90,  0x168, 0x10,  0x48, 0x10, 0x490, 0x0;
    double genoEndScene     : 0x802990, 0x860, 0x1C0, 0x1C0, 0x38,  0x48, 0x10, 0x60,  0x0;
}

startup
{
    refreshRate   = 30;
    vars.offset   = -1;
    vars.killRoom = 0;
    vars.barrier  = false;
    vars.started  = false;

    settings.Add("F_KillCount", false, "Show kill count");
    settings.SetToolTip("F_KillCount", "A new row will appear on your layout with the current room and area kills.");

    settings.Add("F_FiveLights",     false, "Exit the five lights puzzle room");
    settings.Add("F_Decibat",        false, "Exit Decibat room");
    settings.Add("F_Dalv",           false, "Exit Dalv room");
    settings.Add("F_GoldenPear",     false, "Obtain Golden Pear");
    settings.Add("F_DarkRuins",      false, "Exit Dark Ruins");
    settings.Add("F_Honeydew",       false, "Enter Honeydew Resort");
    settings.Add("F_GoldenCoffee",   false, "Obtain Golden Coffee");
    settings.Add("F_EnterMartlet",   false, "Enter Martlet room");
    settings.Add("F_ExitMartlet",    false, "Exit Martlet room");
    settings.Add("F_ElBailador",     false, "Exit El Bailador room");
    settings.Add("F_GoldenCactus",   false, "Obtain Golden Cactus");
    settings.Add("F_FForCeroba",     false, "End Feisty Four / Genocide Ceroba battle");
    settings.Add("F_Starlo",         false, "Exit Starlo room");
    settings.Add("F_GoldenBandana",  false, "Obtain Golden Bandana");
    settings.Add("F_Guardener",      false, "Exit Guardener room");
    settings.Add("F_GreenhouseSkip", false, "Greenhouse Skip");
    settings.SetToolTip("F_GreenhouseSkip", "This autosplit triggers when you exit the room with the savepoint after Guardener\n(most common split location for Greenhouse Skip).");
    settings.Add("F_Axis",           false, "Exit Axis room");
    settings.Add("F_Flowey1",        false, "Flowey Flashback");
    settings.Add("F_Zenith1",        false, "Zenith Flashback");
    settings.Add("F_Zenith2",        false, "End Zenith battle");
    settings.Add("F_NewHome",        false, "Enter New Home");
    settings.Add("F_Ceroba1",        false, "Ceroba Flashback 1");
    settings.Add("F_Ceroba2",        false, "Ceroba Flashback 2");
    settings.Add("F_Ceroba3",        false, "End Pacifist Ceroba battle");
    settings.Add("F_Neutral",         true, "Neutral Ending");
    settings.Add("F_Pacifist",        true, "True Pacifist Ending");
    settings.Add("F_FPacifist",       true, "Flawed Pacifist Ending");
    settings.Add("F_Genocide",        true, "Genocide Ending");
    settings.Add("F_Rope",            true, "Rope Ending");

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
    vars.dontUpdate = new HashSet<int> { 180, 182, 185 }; // Battle Room, Shops, Death Screen
    vars.areas = new List<Tuple<int, int, int, int>>
    {
        // min room, max room, area, max kills per room
        Tuple.Create(13,  42,  1, 5), // Dark Ruins
        Tuple.Create(43,  72,  2, 5), // Snowdin
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
    vars.killRoom = 0;
}

init
{
    string hash;
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(modules.First().FileName)) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old room, new room, special condition
        {"F_FiveLights",     new object[] {false,  18,  19, 0}},
        {"F_Decibat",        new object[] {false,  25,  26, 0}},
        {"F_Dalv",           new object[] {false,  34,  37, 0}},
        {"F_GoldenPear",     new object[] {false,  -1,  29, 1}},
        {"F_DarkRuins",      new object[] {false,  35,  43, 0}},
        {"F_Honeydew",       new object[] {false,  58,  59, 0}},
        {"F_GoldenCoffee",   new object[] {false,  -1,  63, 2}},
        {"F_EnterMartlet",   new object[] {false,  70,  71, 0}},
        {"F_ExitMartlet",    new object[] {false,  71,  72, 0}},
        {"F_ElBailador",     new object[] {false, 108, 109, 0}},
        {"F_GoldenCactus",   new object[] {false,  -1,  83, 3}},
        {"F_FForCeroba",     new object[] {false, 180, 127, 0}},
        {"F_Starlo",         new object[] {false, 135, 136, 0}},
        {"F_GoldenBandana",  new object[] {false,  -1,  -1, 4}}, // Can be obtained in different rooms depending on the route
        {"F_Guardener",      new object[] {false, 191, 190, 0}},
        {"F_GreenhouseSkip", new object[] {false, 190, 281, 0}},
        {"F_Axis",           new object[] {false, 204, 206, 0}},
        {"F_Flowey1",        new object[] {false, 234, 233, 0}},
        {"F_Zenith1",        new object[] {false, 180, 260, 0}},
        {"F_Zenith2",        new object[] {false, 180, 221, 0}},
        {"F_NewHome",        new object[] {false, 259, 253, 0}},
        {"F_Ceroba1",        new object[] {false, 180, 246, 0}},
        {"F_Ceroba2",        new object[] {false, 180, 250, 0}},
        {"F_Ceroba3",        new object[] {false, 180, 255, 0}},
        {"F_Neutral",        new object[] {false,  -1, 235, 5}},
        {"F_Pacifist",       new object[] {false,  -1, 255, 6}}, // Special offset required
        {"F_FPacifist",      new object[] {false,  -1, 180, 7}},
        {"F_Genocide",       new object[] {false,  -1, 268, 8}},
        {"F_Rope",           new object[] {false,  13,   0, 0}}
    };

    switch(hash)
    {
        case "2610A3F58304DE377DA56C221FC68D6B":
            version = "v1.1";

            vars.checkItem = (Func<string, bool>)((itemName) => 
            {
                for(int i = 1; i <= 8; i++)
                    if(new DeepPointer(0xA60CB0, 0x0, 0x50, 0x390, 0x20, 0x90, (0x10 * i), 0x0, 0x0).DerefString(game, 32) == itemName) return true;
                
                return false;
            });
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Yellow is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.",
                "LiveSplit | Undertale Yellow", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }

    print("[Undertale Yellow] Version: " + version + " (" + hash + ")");
}

start
{
    if(current.room == 2)
        return (current.startFade1 > 0.5 && current.startFade1 < 0.6);

    else if(current.room == 3)
        return (current.startFade2 > 0.5 && current.startFade2 < 0.6);   
}

reset
{
    if(vars.started == false)
        return false; // Fix for an issue where the timer would reset immediately after starting

    if(current.room == 2)
        return (current.startFade1 > 0.5 && current.startFade1 < 0.6);

    else if(current.room == 3)
        return (current.startFade2 > 0.5 && current.startFade2 < 0.6);       
}

onReset
{
    vars.offset  = -1;
    vars.barrier = false;
    vars.started = false;

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

    if(old.room != current.room)
    {
        if((old.room == 2 || old.room == 3) && current.room == 6)
            vars.started = true;

        if(old.room == 269 && current.room == 180) // Entered the Flawed Pacifist Asgore battle
            vars.barrier = true; // Added for the ending autosplit check because room 180 is used for every battle, so this is mainly just to be safe

        if(settings["F_KillCount"] && !vars.dontUpdate.Contains(current.room))
        {
            var tuple = ((List<Tuple<int, int, int, int>>)vars.areas).FirstOrDefault(t => current.room >= t.Item1 && current.room <= t.Item2);
            if(tuple != null)
            {
                /* 
                    Pretty much copy-pasted obj_rndenc_Other_4
                    I could have gotten a pointer path to global.kill_area_current, however more pointers = more chances for the paths to break for other people lol
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

                int room = (int)vars.killRoom, area = tuple.Item3, needed = tuple.Item4;
                double rKills = new DeepPointer(0x82FC70, 0x48, 0x10, 0x10E0, 0x0,  0x90, (0x10 * area), 0x90, (0x10 * room)).Deref<double>(game);
                double tKills = new DeepPointer(0x82FC70, 0x48, 0x10, 0x10E0, 0x10, 0x90, (0x10 * area)).Deref<double>(game);
                vars.setText(vars.killTextKey, ((needed - rKills) + "/" + needed + " | " + (20 - tKills) + "/20"));
            }
            else vars.setText(vars.killTextKey, "Invalid Area");
        }
        
        print("[Undertale Yellow] Room: " + old.room + " -> " + current.room);
    }

    if(current.room == 255 && vars.offset == -1 && current.pacifistEndScene == 261 && settings["F_Pacifist"]) 
        vars.offset = 46; // Split this many frames after Ceroba starts going down
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
                pass = (current.neutralEndScene == 6 || current.neutralEndScene == 7);
                break;

            case 6: // F_Pacifist
                if(vars.offset > 0)
                {
                    vars.offset --;
                    pass = false;
                }
                else if(vars.offset == 0)
                {
                    vars.offset = -1;
                    pass = true;
                }
                break;

            case 7: // F_FPacifist
                pass = (vars.barrier == true && old.soulSpeed == 1 && current.soulSpeed == 0);
                break;

            case 8: // F_Genocide
                pass = (current.genoEndScene == 36 || current.genoEndScene == 37);
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
