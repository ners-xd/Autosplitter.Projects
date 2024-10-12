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

state("utks-prologue", "Prologue v0.1.5-v0.1.54")
{
    int sound : 0xBDB9C8, 0x0, 0x14;

    double menuShake : 0xC07C58, 0x30, 0x1F90, 0x0, 0xB0, 0x48, 0x10, 0x40, 0x0;
}

state("utks-prologue", "Prologue v0.1.55/v0.1.56")
{
    int sound : 0xBDB9C8, 0x0, 0x14;

    double menuShake : 0xC07C58, 0x30, 0x1FD0, 0x0, 0xB0, 0x48, 0x10, 0x70, 0x0;
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
    IntPtr ptrRoomArray = scan(5, "74 0C 48 8B 05 ?? ?? ?? ?? 48 8B 04 D0");
    vars.ptrRoomID = scan(9, "48 8B 05 ?? ?? ?? ?? 89 3D ?? ?? ?? ??");

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
        case "8CFAD113EE503822CEBED4866DD45CE8":
            version = "Prologue v0.1.0";
            break;

        case "67CE8A88526EC9B35CA531F6C99772EE":
            version = "Prologue v0.1.4";
            break;

        case "390757428E23FC559C09A5857985FD52": // v0.1.5
        case "93DE78103C2F80FCF0965B5F2519DC64": // v0.1.51
        case "5BD83DD00DA90760A1B088824FB07350": // v0.1.52
        case "95F0F076730DBDFB083519D334470C31": // v0.1.53
        case "8A90A5F8940A4F9B716729D60D39FE54": // v0.1.54
            version = "Prologue v0.1.5-v0.1.54";
            break;
        
        case "C979EADA3C5BC7A6BBD9CDCCEA67990B": // v0.1.55
        case "AB954B95FC2E34C1F1217808836E98E7": // v0.1.56
            version = "Prologue v0.1.55/v0.1.56";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Kindred Spirits is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.\n\n" +
                "Supported versions: Prologue v0.1.0, v0.1.4-v0.1.55.",
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
        case "Prologue v0.1.0":
            return (current.roomName == "room_introtitle" && ((old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0) || (old.menuShake2 == 0 && current.menuShake2 > 0 && current.menuShake2 % 1 == 0)));

        case "Prologue v0.1.4":
        case "Prologue v0.1.5-v0.1.54":
        case "Prologue v0.1.55/v0.1.56":
            return (current.roomName == "room_introtitle" && old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0);
    }
}

reset
{
    switch(version)
    {
        case "Prologue v0.1.0":
            return (current.roomName == "room_introtitle" && ((old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0) || (old.menuShake2 == 0 && current.menuShake2 > 0 && current.menuShake2 % 1 == 0)));

        case "Prologue v0.1.4":
        case "Prologue v0.1.5-v0.1.54":
        case "Prologue v0.1.55/v0.1.56":
            return (current.roomName == "room_introtitle" && old.menuShake == 0 && current.menuShake > 0 && current.menuShake % 1 == 0);
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
                pass = (old.sound == 5 && (current.sound == 10 || current.sound == 11));
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
