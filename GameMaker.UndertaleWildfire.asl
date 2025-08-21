// Undertale Wildfire Autosplitter by NERS

state("Undertale Wildfire", "Combat Demo v1.12")
{
    double   menuSelection : 0x9FC478, 0x90, 0x48, 0x10, 0x20, 0x0;      // obj_menu.selection
    string16 menuState     : 0xA0A430, 0x18, 0x88, 0x8,  0x0,  0x0, 0x0; // obj_menu.fsm state (SnowState)

    float playerX : 0x76C770, 0x0, 0x4B0, 0x18, 0x70, 0x10, 0xF4; // obj_player.x 
}

startup
{
    refreshRate = 30;
    vars.currentChallenge = 0;

    settings.Add("Combat_Demo", true, "Combat Demo");
    settings.CurrentDefaultParent = "Combat_Demo";
    settings.Add("C_Nochallenge", false, "No challenge");
    settings.Add("C_Trinketless", false, "Trinketless");
    settings.Add("C_StressHurts", false, "Stress Hurts");
    settings.Add("C_Patience",    false, "Patience");
    settings.Add("C_OneHitWonder", true, "One Hit Wonder");

    vars.splits = new Dictionary<string, Func<dynamic, dynamic, bool>>()
    {
        // org = original (equivalent to old), cur = current (can't use the same names)
        {"C_Nochallenge",  (org, cur) => cur.roomName == "rm_trail_anser_quigley" && cur.playerX >= 969 && vars.currentChallenge == 1},
        {"C_Trinketless",  (org, cur) => cur.roomName == "rm_trail_anser_quigley" && cur.playerX >= 969 && vars.currentChallenge == 2},
        {"C_StressHurts",  (org, cur) => cur.roomName == "rm_trail_anser_quigley" && cur.playerX >= 969 && vars.currentChallenge == 3},
        {"C_Patience",     (org, cur) => cur.roomName == "rm_trail_anser_quigley" && cur.playerX >= 969 && vars.currentChallenge == 4},
        {"C_OneHitWonder", (org, cur) => cur.roomName == "rm_trail_anser_quigley" && cur.playerX >= 969 && vars.currentChallenge == 5}
    };
    vars.completedSplits = new HashSet<string>();
}

init
{
    var module = modules.First();

    // Thanks to Jujstme and Ero for this (finding room names)
    var scanner = new SignatureScanner(game, module.BaseAddress, module.ModuleMemorySize);
    Func<int, string, IntPtr> scan = (o, sig) =>
    {
        IntPtr ptr = scanner.Scan(new SigScanTarget(o, sig) { OnFound = (p, s, addr) => addr + p.ReadValue<int>(addr) + 0x4 });
        if(ptr == IntPtr.Zero) throw new NullReferenceException("[Undertale Wildfire] Signature scanning failed");
        print("[Undertale Wildfire] Signature found at " + ptr.ToString("X"));
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
        case "B4E7CF47487D009E18B9ACC3851EB888":
            version = "Combat Demo v1.12";
            break;

        default:
            version = "Unknown";

            MessageBox.Show
            (
                "This version of Undertale Wildfire is not supported by the autosplitter.\nIf you are playing an older version, update your game.\nIf not, please wait until the autosplitter receives an update.\n\n" +

                "Make sure the data file is named \"data.win\".\n" +
                "Supported version: Combat Demo v1.12.",
                "LiveSplit | Undertale Wildfire", MessageBoxButtons.OK, MessageBoxIcon.Warning
            );
            break;
    }
    print("[Undertale Wildfire] Version: " + version + " (" + hash + ")");
}

exit
{
    vars.currentChallenge = 0;
}

start
{
    if(version.StartsWith("Combat Demo"))
        return (current.roomName == "rm_menu" && old.menuState == "challenges" && current.menuState == "fade_challenges" && old.menuSelection <= 1);
        // Checking for selections 0 and 1 because you can do Down+Z on the same frame while on Back and it counts as starting No challenge while selection is still 0
}

reset
{
    if(version.StartsWith("Combat Demo"))
        return (current.roomName == "rm_menu" && old.menuState == "challenges" && current.menuState == "fade_challenges" && old.menuSelection <= 1);
}

onReset
{
    vars.completedSplits.Clear();
    print("[Undertale Wildfire] All splits have been reset to initial state");
}

update
{
    if(version == "Unknown")
        return false;

    current.room = game.ReadValue<int>((IntPtr)vars.ptrRoomID);
    current.roomName = vars.getRoomName();

    if(version.StartsWith("Combat Demo"))
    {
        if(current.roomName == "rm_menu" && old.menuState == "challenges" && current.menuState == "fade_challenges")
            vars.currentChallenge = (old.menuSelection == 0 ? 1 : old.menuSelection); 
            // There is a global.challenge variable but it's 0 for both No challenge and Trinketless so it's not really reliable
            // Checking for selection 0 for the same reason mentioned in start{}
    }

    if(old.room != current.room)
        print("[Undertale Wildfire] Room: " + old.room + " (" + old.roomName + ")" + " -> " + current.room + " (" + current.roomName + ")");
}

split
{
    foreach(var split in vars.splits)
    {
        if(!settings[split.Key] || 
           vars.completedSplits.Contains(split.Key) ||
           !split.Value(old, current)) continue;

        vars.completedSplits.Add(split.Key);
        print("[Undertale Wildfire] Split triggered (" + split.Key + ")");
        return true;
    }
}