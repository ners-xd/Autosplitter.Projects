// Undertale Yellow Demo Autosplitter by NERS

state("Undertale Yellow", "Demo v1.1")
{
    // Static
    int room : 0x5CB860;

    // Global
    double tinyPuzzle : 0x3C9730, 0x34, 0x10, 0x1A8, 0x0;
    double pearFlag   : 0x3C9730, 0x34, 0x10, 0x184, 0x0, 0x4, 0x4, 0x130;

    // Self
    double startFade1 : 0x5CB8EC, 0x8, 0x84, 0x150, 0x34, 0x10, 0xA0, 0x0;
    double startFade2 : 0x5CB8EC, 0xC, 0x84, 0x150, 0x34, 0x10, 0xA0, 0x0;
}

startup
{
    refreshRate  = 30;
    vars.started = false;

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

    if(hash == "37F685EAF7A6A8D84585D63957D96BA0")
    {
        version = "Demo v1.1";

        vars.splits = new Dictionary<string, object[]>()
        {
            // Object variables in order: done, old room, new room, special condition
            {"D_Flowey",      new object[] {false, 14, 16, 0}},
            {"D_Decibat",     new object[] {false, 24, 25, 0}},
            {"D_WallNumbers", new object[] {false, -1, 15, 1}},
            {"D_GoldenPear",  new object[] {false, -1, 40, 2}},
            {"D_Ending",      new object[] {false, 41, 56, 0}}
        };
    }
    else
    {
        version = "Unknown";

        MessageBox.Show
        (
            "This version of Undertale Yellow is not supported by the autosplitter.\nPlease use Demo version 1.1.",
            "LiveSplit | Undertale Yellow Demo", MessageBoxButtons.OK, MessageBoxIcon.Warning
        );
    }

    print("[Undertale Yellow Demo] Hash: " + hash);
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
    vars.started = false;

    if(game != null)
    {
        foreach(string split in vars.splits.Keys) 
            vars.splits[split][0] = false;
    }
        
    print("[Undertale Yellow Demo] All splits have been reset to initial state");
}

update
{
    if(version == "Unknown")
        return false;

    if(old.room != current.room)
    {
        if((old.room == 2 || old.room == 3) && current.room == 5)
            vars.started = true;

        print("[Undertale Yellow Demo] Room: " + old.room + " -> " + current.room);
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
           (current.room != vars.splits[splitKey][newRoom])) continue;

        bool pass = false;
        switch((int)vars.splits[splitKey][condition])
        {
            case 0:
                pass = true;
                break;

            case 1: // D_WallNumbers
                pass = (old.tinyPuzzle == 1 && current.tinyPuzzle == 0);
                break;

            case 2: // D_GoldenPear
                pass = (old.pearFlag == 0 && current.pearFlag == 1);
                break;
        }

        if(pass)
        {
            if(splitKey != "D_Ending") // Don't mark D_Ending as done because it's triggered multiple times in All Endings
                vars.splits[splitKey][done] = true;

            print("[Undertale Yellow Demo] Split triggered (" + splitKey + ")");
            return true;
        }
    }
}
