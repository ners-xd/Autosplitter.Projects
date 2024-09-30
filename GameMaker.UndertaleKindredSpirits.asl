// Undertale Kindred Spirits Autosplitter by NERS

state("UNDERTALE KINDRED SPIRITS", "Prologue v0.1.0")
{
    int sound : 0xBDB9C8, 0x0, 0x14; // The ID of the current sound that's playing (highest priority)

    // Self
    double menuShake  : 0xE3A210, 0x1F0, 0x88,   0x10, 0x48, 0x10, 0xD0, 0x0;       // obj_intromenu0.tab_info.instr.shake_timer
    double menuShake2 : 0xC07C58, 0x30,  0x1810, 0x0,  0xB0, 0x48, 0x10, 0xD0, 0x0; // This one only works when pressing Reset, the one above only works when pressing Start Game, unsure why v0.1.0 has this issue
}

state("UNDERTALE KINDRED SPIRITS", "Prologue v0.1.4")
{
    int sound : 0xBDB9C8, 0x0, 0x14;

    double menuShake : 0xC07C58, 0x30, 0x1870, 0x0, 0xB0, 0x48, 0x10, 0x130, 0x0;
}

startup
{
    refreshRate = 30;

    settings.Add("Prologue", true, "Prologue");
    settings.CurrentDefaultParent = "Prologue";
    settings.Add("P_TekiLomax", false, "Exit Teki & Lomax room");
    settings.Add("P_Ending",     true, "Ending");
    settings.CurrentDefaultParent = null;
}

init
{
    var module = modules.First();
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
    Func<int, string, IntPtr> scan = (o, sig) =>
    {
        IntPtr ptr = scanner.Scan(new SigScanTarget(o, sig) { OnFound = (p, s, addr) => addr + p.ReadValue<int>(addr) + 0x4 });
        if(ptr == IntPtr.Zero) throw new NullReferenceException("[Undertale Kindred Spirits] Signature scanning failed");
        print("[Undertale Kindred Spirits] Signature found at " + ptr.ToString("X"));
        return ptr;
    };
    vars.ptrRoomID = scan(9, "48 8B 05 ?? ?? ?? ?? 89 3D ?? ?? ?? ??");

    string hash;
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(new FileInfo(module.FileName).DirectoryName + @"\data.win")) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    switch(hash)
    {
        case "8CFAD113EE503822CEBED4866DD45CE8":
            version = "Prologue v0.1.0";
            break;

        case "67CE8A88526EC9B35CA531F6C99772EE":
            version = "Prologue v0.1.4";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Kindred Spirits is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.\n\n" +
                "Supported versions: Prologue v0.1.0, v0.1.4.",
                "LiveSplit | Undertale Kindred Spirits", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[Undertale Kindred Spirits] Version: " + version + " (" + hash + ")");

    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old room, new room, special condition
        {"P_TekiLomax", new object[] {false, 13, 14, 0}},
        {"P_Ending",    new object[] {false, -1, 30, 1}}
    };
}

start
{
    switch(version)
    {
        case "Prologue v0.1.0":
            return (current.room == 28 && ((old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0) || (old.menuShake2 == 0 && current.menuShake2 > 0 && current.menuShake2 % 1 == 0)));

        case "Prologue v0.1.4":
            return (current.room == 28 && old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0);
    }
}

reset
{
    switch(version)
    {
        case "Prologue v0.1.0":
            return (current.room == 28 && ((old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0) || (old.menuShake2 == 0 && current.menuShake2 > 0 && current.menuShake2 % 1 == 0)));

        case "Prologue v0.1.4":
            return (current.room == 28 && old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0);
    }
}

onReset
{
    if(game != null)
    {
        foreach(string split in vars.splits.Keys) 
            vars.splits[split][0] = false;
        
        print("[Undertale Kindred Spirits] All splits have been reset to initial state");
    }
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);
    if(old.room != current.room)
        print("[Undertale Kindred Spirits] Room: " + old.room + " -> " + current.room);
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

            case 1:
                pass = (old.sound == 5 && current.sound == 10);
                break;
        }

        if(pass)
        {   
            vars.splits[splitKey][done] = true;
            print("[Undertale Kindred Spirits] Split triggered (" + splitKey + ")");
            return true;
        }
    }
}
