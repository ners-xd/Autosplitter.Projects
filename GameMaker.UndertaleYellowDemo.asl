// Undertale Yellow Demo Autosplitter by NERS

state("Undertale Yellow", "Demo v1.1")
{
    // Static
    int room : 0x5CB860;

    // Global
    double tinyPuzzle : 0x3C9730, 0x34, 0x10, 0x1A8, 0x0;                  // global.tinypuzzle
    double pearFlag   : 0x3C9730, 0x34, 0x10, 0x184, 0x0, 0x4, 0x4, 0x130; // global.flag[19]

    // Self
    double startWaiter : 0x5CB89C, 0x84, 0x150, 0x34, 0x10, 0x70, 0x0; // obj_mainmenu.waiter
}

startup
{
    refreshRate = 30;

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
    if(current.room == 2 || current.room == 3)
        return (old.startWaiter == 0 && current.startWaiter == 1);   
}

reset
{
    if(current.room == 2 || current.room == 3)
        return (old.startWaiter == 0 && current.startWaiter == 1);      
}

onReset
{
    if(game != null)
    {
        foreach(string split in vars.splits.Keys) 
            vars.splits[split][0] = false;

        print("[Undertale Yellow Demo] All splits have been reset to initial state");
    }
}

update
{
    if(version == "Unknown")
        return false;

    if(old.room != current.room)
        print("[Undertale Yellow Demo] Room: " + old.room + " -> " + current.room);
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
