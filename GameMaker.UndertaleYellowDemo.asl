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

    vars.splits = new Dictionary<string, Func<dynamic, dynamic, bool>>()
    {
        // org = original (equivalent to old), cur = current (can't use the same names)
        {"D_Flowey",      (org, cur) => org.room == 14 && cur.room == 16},
        {"D_Decibat",     (org, cur) => org.room == 24 && cur.room == 25},
        {"D_WallNumbers", (org, cur) => cur.room == 15 && org.tinyPuzzle == 1 && cur.tinyPuzzle == 0},
        {"D_GoldenPear",  (org, cur) => cur.room == 40 && org.pearFlag == 0 && cur.pearFlag == 1},
        {"D_Ending",      (org, cur) => org.room == 41 && cur.room == 56}
    };
    vars.completedSplits = new HashSet<string>();
}

init
{
    string hash = "Invalid hash";
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(modules.First().FileName)) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    if(hash == "37F685EAF7A6A8D84585D63957D96BA0")
    {
        version = "Demo v1.1";
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
    vars.completedSplits.Clear();
    print("[Undertale Yellow Demo] All splits have been reset to initial state");
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
    foreach(var split in vars.splits)
    {
        if(!settings[split.Key] || 
           vars.completedSplits.Contains(split.Key) ||
           !split.Value(old, current)) continue;

        if(split.Key != "D_Ending") // Don't mark D_Ending as done because it's triggered multiple times in All Endings
            vars.completedSplits.Add(split.Key);
        
        print("[Undertale Yellow Demo] Split triggered (" + split.Key + ")");
        return true;
    }
}