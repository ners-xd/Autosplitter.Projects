// Undertale Kindred Spirits Autosplitter by NERS

state("utks-prologue", "Prologue v0.1.6")
{
    double start : 0x76CA40, 0x48, 0x10, 0x6C0, 0x10; // global.temp_startgame
}

startup
{
    refreshRate = 30;
    vars.offset = new Stopwatch();

    settings.Add("Prologue", true, "Prologue");
    settings.CurrentDefaultParent = "Prologue";
    settings.Add("P_TekiLomax", false, "Exit Teki & Lomax battle room");
    settings.Add("P_Ending",     true, "Enter Sewers");

    vars.splits = new Dictionary<string, Func<dynamic, dynamic, bool>>()
    {
        // org = original (equivalent to old), cur = current (can't use the same names)
        {"P_TekiLomax", (org, cur) => org.roomName == "room_rtown_dumpster" && cur.roomName == "room_thouse_fireplace"},
        {"P_Ending",    (org, cur) => cur.roomName == "room_slevel0_0" && vars.offset.IsRunning && vars.offset.ElapsedMilliseconds >= 5000}
    };
    vars.completedSplits = new HashSet<string>();
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

    string hash = "Invalid hash";
    string dataFile = new FileInfo(module.FileName).DirectoryName + @"\data.win";
    if(File.Exists(dataFile))
    {
        using(var md5 = System.Security.Cryptography.MD5.Create())
            using(var fs = File.OpenRead(dataFile))
                hash = string.Concat(md5.ComputeHash(fs).Select(b => b.ToString("X2")));
    }
    switch(hash)
    {   
        case "15C7B846456B1C83EDEF8C3B4FB48AFC":
            version = "Prologue v0.1.6";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Kindred Spirits is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.\n\n" +

                "Make sure the data file is named \"data.win\".\n" +
                "Supported version: Prologue v0.1.6.",
                "LiveSplit | Undertale Kindred Spirits", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[Undertale Kindred Spirits] Version: " + version + " (" + hash + ")");
}

start
{
    return (current.roomName == "room_introtitle" && old.start == 0 && current.start == 1);
}

reset
{
    return (current.roomName == "room_introtitle" && old.start == 0 && current.start == 1);
}

onReset
{
    vars.completedSplits.Clear();
    vars.offset.Reset();
    print("[Undertale Kindred Spirits] All splits have been reset to initial state");
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);
    current.roomName = vars.getRoomName();

    if(old.room != current.room)
    {
        print("[Undertale Kindred Spirits] Room: " + old.room + " (" + old.roomName + ")" + " -> " + current.room + " (" + current.roomName + ")");

        if(old.roomName == "room_rtown_sewerentry" && current.roomName == "room_slevel0_0" && !vars.offset.IsRunning)
            vars.offset.Start();
    }
}

split
{
    foreach(var split in vars.splits)
    {
        if(!settings[split.Key] || 
           vars.completedSplits.Contains(split.Key) ||
           !split.Value(old, current)) continue;

        vars.offset.Reset();
        vars.completedSplits.Add(split.Key);
        print("[Undertale Kindred Spirits] Split triggered (" + split.Key + ")");
        return true;
    }
}
