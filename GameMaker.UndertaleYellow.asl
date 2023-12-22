// Undertale Yellow Autosplitter by NERS

state("Undertale Yellow", "v1.1")
{
    // Static
    int room : 0xA3FCF4;

    // Self
    double startFade1       : 0x802990, 0x10,  0xD8,  0x48,  0x10,  0x0,  0x0;
    double startFade2       : 0x802990, 0x18,  0xD8,  0x48,  0x10,  0x0,  0x0;
    double neutralEndScene  : 0xA4F100, 0x1A0, 0x1A0, 0x198, 0x198, 0x48, 0x10, 0x60, 0x0;
    double pacifistEndScene : 0xA60DA0, 0x20,  0x1A0, 0x1A0, 0x48,  0x10, 0x60, 0x0;
    double soulSpeed        : 0xA60DA0, 0x0,   0x48,  0x10,  0x170, 0x380;
    double genoEndScene     : 0x802990, 0x860, 0x1C0, 0x1C0, 0x38,  0x48, 0x10, 0x60, 0x0;
    double ropeWaiter       : 0xA60DA0, 0x0,   0x198, 0x48,  0x10,  0xE0, 0x0;
}

state("Undertale Yellow", "Demo")
{
    // Static
    int room : 0x5CB860;

    // Global
    double tinyPuzzle : 0x3C95C0, 0x4C, 0xC,   0x478, 0x2A0;
    double pearFlag   : 0x3CB070, 0x38, 0x230, 0x92C, 0xB5C, 0xB70;

    // Self
    double startFade1 : 0x5CB8EC, 0x8, 0x84, 0x150, 0x34, 0x10, 0xA0, 0x0;
    double startFade2 : 0x5CB8EC, 0xC, 0x84, 0x150, 0x34, 0x10, 0xA0, 0x0;
}

startup
{
    refreshRate = 30;
    vars.barrier = false;

    settings.Add("F", true, "Full Game Splits");
    settings.CurrentDefaultParent = "F";

    settings.Add("F_Decibat",       false, "Exit Decibat room");
    settings.Add("F_Dalv",          false, "Exit Dalv room");
    settings.Add("F_GoldenPear",    false, "Obtain Golden Pear");
    settings.Add("F_DarkRuins",     false, "Exit Dark Ruins");
    settings.Add("F_Honeydew",      false, "Enter Honeydew Resort");
    settings.Add("F_GoldenCoffee",  false, "Obtain Golden Coffee");
    settings.Add("F_EnterMartlet",  false, "Enter Martlet room");
    settings.Add("F_ExitMartlet",   false, "Exit Martlet room");
    settings.Add("F_ElBailador",    false, "Exit El Bailador room");
    settings.Add("F_GoldenCactus",  false, "Obtain Golden Cactus");
    settings.Add("F_FForCeroba",    false, "End Feisty Four / Geno Ceroba battle");
    settings.Add("F_Starlo",        false, "Exit Starlo room");
    settings.Add("F_GoldenBandana", false, "Obtain Golden Bandana");
    settings.Add("F_Guardener",     false, "Exit Guardener room");
    settings.Add("F_Axis",          false, "Exit Axis room");
    settings.Add("F_Flowey1",       false, "End Flowey Phase 1");
    settings.Add("F_Zenith1",       false, "End Zenith Phase 1");
    settings.Add("F_Zenith2",       false, "End Zenith Phase 2");
    settings.Add("F_NewHome",       false, "Enter New Home");
    settings.Add("F_Neutral",        true, "Neutral Ending");
    settings.Add("F_Pacifist",       true, "True Pacifist Ending");
    settings.Add("F_FPacifist",      true, "Flawed Pacifist Ending");
    settings.Add("F_Genocide",       true, "Genocide Ending");
    settings.Add("F_Rope",           true, "Rope Ending");

    settings.CurrentDefaultParent = null;
    settings.Add("D", true, "Demo Splits");
    settings.CurrentDefaultParent = "D";

    settings.Add("D_Flowey",      false, "Exit Flowey room");
    settings.Add("D_Decibat",     false, "Exit Decibat room");
    settings.Add("D_WallNumbers", false, "Finish wall numbers");
    settings.Add("D_GoldenPear",  false, "Obtain Golden Pear");
    settings.Add("D_Ending",       true, "Ending");
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
        {"F_Decibat",       new object[] {false,  25,  26, 0}},
        {"F_Dalv",          new object[] {false,  34,  37, 0}},
        {"F_GoldenPear",    new object[] {false,  -1,  29, 1}},
        {"F_DarkRuins",     new object[] {false,  35,  43, 0}},
        {"F_Honeydew",      new object[] {false,  58,  59, 0}},
        {"F_GoldenCoffee",  new object[] {false,  -1,  63, 2}},
        {"F_EnterMartlet",  new object[] {false,  70,  71, 0}},
        {"F_ExitMartlet",   new object[] {false,  71,  72, 0}},
        {"F_ElBailador",    new object[] {false, 108, 109, 0}},
        {"F_GoldenCactus",  new object[] {false,  -1,  83, 3}},
        {"F_FForCeroba",    new object[] {false, 180, 127, 0}},
        {"F_Starlo",        new object[] {false, 135, 136, 0}},
        {"F_GoldenBandana", new object[] {false,  -1, 167, 4}},
        {"F_Guardener",     new object[] {false, 191, 190, 0}},
        {"F_Axis",          new object[] {false, 204, 206, 0}},
        {"F_Flowey1",       new object[] {false, 234, 233, 0}},
        {"F_Zenith1",       new object[] {false, 180, 260, 0}},
        {"F_Zenith2",       new object[] {false, 180, 221, 0}},
        {"F_NewHome",       new object[] {false, 259, 253, 0}},
        {"F_Neutral",       new object[] {false,  -1, 235, 5}},
        {"F_Pacifist",      new object[] {false,  -1, 255, 6}},
        {"F_FPacifist",     new object[] {false,  -1, 180, 7}},
        {"F_Genocide",      new object[] {false,  -1, 268, 8}},
        {"F_Rope",          new object[] {false,  -1,  13, 9}}
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

        case "37F685EAF7A6A8D84585D63957D96BA0":
            version = "Demo";

            vars.splits = new Dictionary<string, object[]>()
            {
                {"D_Flowey",      new object[] {false, 14, 16,  0}},
                {"D_Decibat",     new object[] {false, 24, 25,  0}},
                {"D_WallNumbers", new object[] {false, -1, 15, 10}},
                {"D_GoldenPear",  new object[] {false, -1, 40, 11}},
                {"D_Ending",      new object[] {false, 41, 56,  0}}
            };
            break;
    }

    print("[Undertale Yellow] Version: " + version + " (" + hash + ")");
}

start
{
    if(current.room == 2)
        return old.startFade1 == 0.5 && current.startFade1 > 0.5 && current.startFade1 < 0.6;

    else if(current.room == 3)
        return old.startFade2 == 0.5 && current.startFade2 > 0.5 && current.startFade2 < 0.6;   
}

reset
{
    if(current.room == 2)
        return old.startFade1 == 0.5 && current.startFade1 > 0.5 && current.startFade1 < 0.6;

    else if(current.room == 3)
        return old.startFade2 == 0.5 && current.startFade2 > 0.5 && current.startFade2 < 0.6;       
}

onReset
{
    vars.barrier = false;
    foreach(string split in vars.splits.Keys) 
        vars.splits[split][0] = false;
        
    print("[Undertale Yellow] All splits have been reset to initial state");
}

update
{
    if(old.room != current.room)
    {
        if(old.room == 269 && current.room == 180) vars.barrier = true;
        print("[Undertale Yellow] Room: " + old.room + " -> " + current.room);
    }
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
                pass = (vars.checkItem("G. Bandana"));
                break;

            case 5: // F_Neutral
                pass = (current.neutralEndScene == 6 || current.neutralEndScene == 7); // Technically the extra or checks aren't really necessary for the endings but I just want to be extra safe
                break;

            case 6: // F_Pacifist
                pass = (current.pacifistEndScene == 260 || current.pacifistEndScene == 261);
                break;

            case 7: // F_FPacifist
                pass = (vars.barrier == true && old.soulSpeed == 1 && current.soulSpeed == 0); // Sometimes this split would trigger in any random battle so I added the extra variable
                break;

            case 8: // F_Genocide
                pass = (current.genoEndScene == 36 || current.genoEndScene == 37);
                break;

            case 9: // F_Rope
                pass = (current.ropeWaiter == 2 || current.ropeWaiter == 3);
                break;

            case 10: // D_WallNumbers
                pass = (old.tinyPuzzle == 1 && current.tinyPuzzle == 0);
                break;

            case 11: // D_GoldenPear
                pass = (old.pearFlag == 0 && current.pearFlag == 1);
                break;
        }

        if(pass)
        {
            if(splitKey != "D_Ending") // Don't mark D_Ending as done because it's triggered multiple times in All Endings
                vars.splits[splitKey][done] = true;

            print("[Undertale Yellow] Split triggered (" + splitKey + ")");
            return true;
        }
    }
}
