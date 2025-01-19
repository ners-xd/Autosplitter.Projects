// Undertale Kindred Spirits Autosplitter by NERS

state("utks-prologue", "Prologue v0.1.58")
{
    string32 ogg : 0xBED770, 0x88, 0x0, 0x10, 0x0, 0x48;
}

startup
{
    refreshRate = 30;

    settings.Add("Prologue", true, "Prologue");
    settings.CurrentDefaultParent = "Prologue";
    settings.Add("P_TekiLomax", false, "Exit Teki & Lomax room");
    settings.Add("P_Ending",     true, "Enter Sewers");
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
    IntPtr ptrRoomArray = scan(5, "74 0C 48 8B 05 ?? ?? ?? ?? 48 8B 04 D0");
    vars.ptrRoomID = scan(6, "48 ?? ?? ?? 3B 35 ?? ?? ?? ?? 41 ?? ?? ?? 49 ?? ?? E8 ?? ?? ?? ?? FF");

    vars.getRoomName = (Func<string>)(() =>
    {
        IntPtr arrayMain = game.ReadPointer(ptrRoomArray);
        if(arrayMain == IntPtr.Zero) return string.Empty;

        IntPtr arrayItem = game.ReadPointer(arrayMain + game.ReadValue<int>((IntPtr)vars.ptrRoomID) * 8);
        if(arrayItem == IntPtr.Zero) return string.Empty;
        return game.ReadString(arrayItem, 64);
    });

    string hash;
    using(var md5 = System.Security.Cryptography.MD5.Create())
        using(var fs = File.OpenRead(new FileInfo(module.FileName).DirectoryName + @"\data.win")) 
            hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));

    switch(hash)
    {   
        case "61CF51505FCEDFE686B36A136BA59CB4":
            version = "Prologue v0.1.58";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Kindred Spirits is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.\n\n" +
                "Supported version: v0.1.58.",
                "LiveSplit | Undertale Kindred Spirits", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[Undertale Kindred Spirits] Version: " + version + " (" + hash + ")");

    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old room, new room, special condition
        {"P_TekiLomax", new object[] {false, "room_rtown_dumpster", "room_thouse_fireplace", 0}},
        {"P_Ending",    new object[] {false, null,                  "room_slevel0_0",        1}}
    };
}

start
{
    switch(version)
    {
        case "Prologue v0.1.58":
            return (current.roomName == "room_introtitle" && old.ogg.StartsWith("mus_menu") && !current.ogg.StartsWith("mus_menu"));
    }
}

reset
{
    switch(version)
    {
        case "Prologue v0.1.58":
            return (current.roomName == "room_introtitle" && old.ogg.StartsWith("mus_menu") && !current.ogg.StartsWith("mus_menu"));
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
    current.roomName = vars.getRoomName();
    if(old.room != current.room)
        print("[Undertale Kindred Spirits] Room: " + old.room + " (" + old.roomName + ")" + " -> " + current.room + " (" + current.roomName + ")");
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
           (vars.splits[splitKey][oldRoom] != null && old.roomName != vars.splits[splitKey][oldRoom]) ||
           (vars.splits[splitKey][newRoom] != null && current.roomName != vars.splits[splitKey][newRoom])) continue;

        bool pass = false;
        switch((int)vars.splits[splitKey][condition])
        {
            case 0:
                pass = true;
                break;

            case 1:
                pass = (old.ogg != "mus_intronoise" && current.ogg == "mus_intronoise");
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
