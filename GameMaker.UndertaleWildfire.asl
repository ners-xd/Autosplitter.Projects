// Undertale Wildfire Autosplitter by NERS

state("Undertale Wildfire", "Combat Demo v1.05")
{
    // Self
    double   menuSelection : 0xE17960, 0x98, 0x48, 0x10, 0x90, 0x0;      // obj_menu.selection
    string16 menuState     : 0xE26E88, 0x18, 0x88, 0x8,  0x0,  0x0, 0x0; // obj_menu.fsm state (SnowState)

    float playerX : 0xC07C20, 0x0, 0x4F0, 0x18, 0x58, 0x10, 0xF4; // obj_player.x 
}

startup
{
    refreshRate = 30;

    settings.Add("Combat_Demo", true, "Combat Demo");
    settings.CurrentDefaultParent = "Combat_Demo";
    settings.Add("C_Nochallenge", false, "No challenge");
    settings.Add("C_Trinketless", false, "Trinketless");
    settings.Add("C_StressHurts", false, "Stress Hurts");
    settings.Add("C_Patience",    false, "Patience");
    settings.Add("C_OneHitWonder", true, "One Hit Wonder");
    settings.CurrentDefaultParent = null;
}

init
{
    var module = modules.First();
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
    Func<int, string, IntPtr> scan = (o, sig) =>
    {
        IntPtr ptr = scanner.Scan(new SigScanTarget(o, sig) { OnFound = (p, s, addr) => addr + p.ReadValue<int>(addr) + 0x4 });
        if(ptr == IntPtr.Zero) throw new NullReferenceException("[Undertale Wildfire] Signature scanning failed");
        print("[Undertale Wildfire] Signature found at " + ptr.ToString("X"));
        return ptr;
    };
    vars.ptrRoomID = scan(9, "48 8B 05 ?? ?? ?? ?? 89 3D ?? ?? ?? ??");

    string hash;
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(modules.First().FileName)) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    switch(hash)
    {
        case "B99A7306BE170472FABC8554ABE577FD":
            version = "Combat Demo v1.05";
            vars.currentChallenge = 0;
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Wildfire is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.",
                "LiveSplit | Undertale Wildfire", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[Undertale Wildfire] Version: " + version + " (" + hash + ")");

    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old room, new room, special condition
        {"C_Nochallenge",  new object[] {false, -1, 7, 1}},
        {"C_Trinketless",  new object[] {false, -1, 7, 2}},
        {"C_StressHurts",  new object[] {false, -1, 7, 3}},
        {"C_Patience",     new object[] {false, -1, 7, 4}},
        {"C_OneHitWonder", new object[] {false, -1, 7, 5}}
    };
}

start
{
    switch(version)
    {
        case "Combat Demo v1.05":
            return (current.room == 3 && old.menuState == "challenges" && current.menuState == "fade_challenges" && old.menuSelection <= 1);
            // Checking for selections 0 and 1 because you can do Down+Z on the same frame while on Back and it counts as starting No challenge while selection is still 0
    }
}

reset
{
    switch(version)
    {
        case "Combat Demo v1.05":
            return (current.room == 3 && old.menuState == "challenges" && current.menuState == "fade_challenges" && old.menuSelection <= 1);
    }
}

onReset
{
    if(game != null)
    {
        foreach(string split in vars.splits.Keys) 
            vars.splits[split][0] = false;
        
        print("[Undertale Wildfire] All splits have been reset to initial state");
    }
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);

    if(version == "Combat Demo v1.05")
    {
        if(current.room == 3 && old.menuState == "challenges" && current.menuState == "fade_challenges")
            vars.currentChallenge = (old.menuSelection == 0 ? 1 : old.menuSelection); 
            // There is a global.challenge variable but it's 0 for both No challenge and Trinketless so it's not really reliable
            // Checking for selection 0 for the same reason mentioned in start{}
    }

    if(old.room != current.room)
        print("[Undertale Wildfire] Room: " + old.room + " -> " + current.room);
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
        int specialCondition = vars.splits[splitKey][condition];
        switch(specialCondition)
        {
            case 0:
                pass = true;
                break;

            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                pass = (current.playerX >= 969 && vars.currentChallenge == specialCondition);
                break;
        }

        if(pass)
        {   
            vars.splits[splitKey][done] = true;
            print("[Undertale Wildfire] Split triggered (" + splitKey + ")");
            return true;
        }
    }
}