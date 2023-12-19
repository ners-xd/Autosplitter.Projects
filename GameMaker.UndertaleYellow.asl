// Undertale Yellow Autosplitter by NERS

state("Undertale Yellow", "v1.1")
{
    // Static
    int room : 0xA3FCF4;

    // Global
    double dialogueOpen : 0x82FC70, 0x48, 0x10, 0x90, 0x5D0; // Maybe will be needed? Maybe not? I don't know but it sounds useful so I'm keeping it for now lol

    // Self
    double startFade1      : 0x802990, 0x10,  0xD8,  0x48,  0x10,  0x0,  0x0;
    double startFade2      : 0x802990, 0x18,  0xD8,  0x48,  0x10,  0x0,  0x0;
    double neutralEndScene : 0x802990, 0x758, 0x8,   0xE0,  0x1A0, 0x48, 0x10, 0x60, 0x0;
    double genoEndScene    : 0x802990, 0x860, 0x1C0, 0x1C0, 0x38,  0x48, 0x10, 0x60, 0x0;
    double ropeWaiter      : 0xA60DA0, 0x0,   0x198, 0x48,  0x10,  0xE0, 0x0;
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

    settings.Add("F", true, "Full Game Splits");
    settings.CurrentDefaultParent = "F";

    settings.Add("F_Neutral",   true, "Neutral Ending");
    // settings.Add("F_Pacifist",  true, "True Pacifist Ending");   To do
    // settings.Add("F_FPacifist", true, "Flawed Pacifist Ending"); To do
    settings.Add("F_Genocide",  true, "Genocide Ending");
    settings.Add("F_Rope",      true, "Rope Ending");

    settings.CurrentDefaultParent = null;
    settings.Add("D", true, "Demo Splits");
    settings.CurrentDefaultParent = "D";

    settings.Add("D_Flowey",      true, "Exit Flowey Room");
    settings.Add("D_Decibat",     true, "Exit Decibat Room");
    settings.Add("D_WallNumbers", true, "Wall Numbers");
    settings.Add("D_GoldenPear",  true, "Golden Pear");
    settings.Add("D_Ending",      true, "Ending");
}

init
{
    string hash;
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(modules.First().FileName)) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    switch(hash)
    {
        case "2610A3F58304DE377DA56C221FC68D6B":
            version = "v1.1";

            vars.splits = new Dictionary<string, object[]>()
            {
            // Object variables in order: done, old room, new room, special condition
            {"F_Neutral",   new object[] {false, -1, 235, 1}},
            // {"F_Pacifist",  new object[] {false, -1, -1, 2}}, // obj_newhome_03_dialogue_postfight_flowey.message_current == 8
            // {"F_FPacifist", new object[] {false, -1, -1, 3}}, // obj_heart_battle_fighting_parent.walk_speed <= 0
            {"F_Genocide",  new object[] {false, -1, 268, 4}},
                {"F_Rope",      new object[] {false, -1, 13,  5}}
            };
            break;

        case "37F685EAF7A6A8D84585D63957D96BA0":
            version = "Demo";

            vars.splits = new Dictionary<string, object[]>()
            {
                {"D_Flowey",      new object[] {false, 14, 16,   0}},
                {"D_Decibat",     new object[] {false, 24, 25,   0}},
                {"D_WallNumbers", new object[] {false, -1, 15,  69}}, // comedy
                {"D_GoldenPear",  new object[] {false, -1, 40, 420}}, // gold
                {"D_Ending",      new object[] {false, 41, 56,   0}}
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
    foreach(string split in vars.splits.Keys) 
        vars.splits[split][0] = false;
        
    print("[Undertale Yellow] All splits have been reset to initial state");
}

update
{
    if(old.room != current.room) 
        print("[Undertale Yellow] Room: " + old.room + " -> " + current.room);
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

            case 1: // F_Neutral
                pass = (old.neutralEndScene == 4 && current.neutralEndScene == 5);
                break;

            case 4: // F_Genocide
                pass = (old.genoEndScene == 35 && current.genoEndScene == 36);
                break;

            case 5: // F_Rope
                pass = (old.ropeWaiter == 1 && current.ropeWaiter == 2);
                break;

            case 69: // D_WallNumbers
                pass = (old.tinyPuzzle == 1 && current.tinyPuzzle == 0);
                break;

            case 420: // D_GoldenPear
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
