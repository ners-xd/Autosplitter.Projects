// OFF (2008) Autosplitter by NERS
// Thanks to KyoshiCadre for all the room and event numbers

state("RPG_RT")
{
    int map         : 0xD2068, 0x4;
    int eventID     : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x1C;
    int eventPage   : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x14, 0x4, 0x4, 0x0, 0x10;
    int eventLine   : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x18;
    int battleID    : 0xD202C, 0x54;
    int battleEnded : 0xD2070, 0x7C, 0x14;
    int batterHP    : 0xD2008, 0xAC, 0x1C, 0x0, 0x14;
    int judgeHP     : 0xD2008, 0xAC, 0x1C, 0x14, 0x14;
    int item        : 0xD2070, 0x7C, 0x2B0;
}

state("Sauvegarde_RPG_RT")
{
    int map         : 0xD2068, 0x4;
    int eventID     : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x1C;
    int eventPage   : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x14, 0x4, 0x4, 0x0, 0x10;
    int eventLine   : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x18;
    int battleID    : 0xD202C, 0x54;
    int battleEnded : 0xD2070, 0x7C, 0x14;
    int batterHP    : 0xD2008, 0xAC, 0x1C, 0x0, 0x14;
    int judgeHP     : 0xD2008, 0xAC, 0x1C, 0x14, 0x14;
    int item        : 0xD2070, 0x7C, 0x2B0;
}

startup
{
    settings.Add("zone0",                false, "Zone 0");
    settings.Add("enter_mines",          false, "Enter Mines");
    settings.Add("mines",                false, "Mines");
    settings.Add("barn",                 false, "Barn");
    settings.Add("enter_postal_service", false, "Enter Postal Service");
    settings.Add("postal_service",       false, "Postal Service");
    settings.Add("alma_first_half",      false, "Alma First Half");
    settings.Add("alma_second_half",     false, "Alma Second Half");
    settings.Add("zone1",                false, "Zone 1");
    settings.Add("card_puzzle",          false, "Card Puzzle (Exit from the LEFT tile)");
    settings.Add("valerie",              false, "Valerie");
    settings.Add("zacharie_photo",       false, "Open The Zacharie Rollercoaster Photo");
    settings.Add("park",                 false, "Park");
    settings.Add("pure_zone1",           false, "Pure Zone 1");
    settings.Add("sugar",                false, "Sugar");
    settings.Add("residential",          false, "Residential");
    settings.Add("enter_japhet",         false, "Enter Japhet");
    settings.Add("zone2",                false, "Zone 2");
    settings.Add("area1",                false, "Area 1");
    settings.Add("area2",                false, "Area 2");
    settings.Add("area3",                false, "Area 3");
    settings.Add("elsen_fight",          false, "Elsen Fight");
    settings.Add("area4",                false, "Area 4");
    settings.Add("enoch",                false, "Enoch");
    settings.Add("chapter5",             false, "Chapter 5");
    settings.Add("chapter4",             false, "Chapter 4");
    settings.Add("chapter3",             false, "Chapter 3");
    settings.Add("exit_the_room",        false, "Exit The Room");
    settings.Add("pure_zone2",           false, "Pure Zone 2");
    settings.Add("pure_zone3",           false, "Pure Zone 3");
    settings.Add("chapter2",             false, "Chapter 2");
    settings.Add("chapter1",             false, "Chapter 1");
    settings.Add("ending",                true, "Ending");

    vars.tempVar = false;
    vars.offset = new Stopwatch();
    vars.splits = new Dictionary<string, Func<dynamic, dynamic, bool>>()
    {
        // org = original (equivalent to old), cur = current (can't use the same names)
        {"zone0",                (org, cur) => cur.map == 8 && cur.eventID == 1 && cur.eventPage == 2 && org.eventLine < 12 && cur.eventLine >= 12},
        {"enter_mines",          (org, cur) => org.map == 19 && cur.map == 20},
        {"mines",                (org, cur) => org.map == 23 && cur.map == 25},
        {"barn",                 (org, cur) => org.map == 28 && cur.map == 27},
        {"enter_postal_service", (org, cur) => cur.map == 34 && cur.eventID == 4 && cur.eventPage == 1 && org.eventLine < 47 && cur.eventLine >= 47},
        {"postal_service",       (org, cur) => org.map == 46 && cur.map == 47},
        {"alma_first_half",      (org, cur) => org.map == 56 && cur.map == 57},
        {"alma_second_half",     (org, cur) => cur.map == 68 && (cur.eventID == 3 || cur.eventID == 4) && cur.eventPage == 0 && org.eventLine < 4 && (cur.eventLine == 4 || cur.eventLine == 5)},
        {"zone1",                (org, cur) => org.map == 69 && cur.map == 70},
        {"card_puzzle",          (org, cur) => org.map == 114 && cur.map == 112 && cur.eventID == 167 && cur.eventPage == 4},
        {"valerie",              (org, cur) => org.map == 117 && cur.map == 116},
        {"zacharie_photo",       (org, cur) => org.item != 112 && cur.item == 112},
        {"park",                 (org, cur) => org.map == 136 && cur.map == 134},
        {"pure_zone1",           (org, cur) => cur.map == 101 && cur.eventID == 1 && cur.eventPage == 2 && org.eventLine < 12 && cur.eventLine >= 12},
        {"sugar",                (org, cur) => org.map == 152 && cur.map == 151},
        {"residential",          (org, cur) => org.map == 145 && cur.map == 115},
        {"enter_japhet",         (org, cur) => cur.map == 162 && org.battleID != 8 && cur.battleID == 8},
        {"zone2",                (org, cur) => org.map == 162 && cur.map == 70},
        {"area1",                (org, cur) => cur.map == 205 && cur.eventID == 5 && cur.eventPage == 0 && org.eventLine < 5 && cur.eventLine >= 5},
        {"area2",                (org, cur) => cur.map == 212 && cur.eventID == 5 && cur.eventPage == 0 && org.eventLine < 16 && cur.eventLine >= 16},
        {"area3",                (org, cur) => cur.map == 214 && cur.eventID == 3 && cur.eventPage == 0 && org.eventLine < 5 && cur.eventLine == 5},
        {"elsen_fight",          (org, cur) => org.map == 234 && cur.map == 213},
        {"area4",                (org, cur) => org.map == 235 && cur.map == 213},
        {"enoch",                (org, cur) => org.map == 213 && cur.map == 2},
        {"chapter5",             (org, cur) => cur.map == 293 && cur.eventID == 6 && cur.eventPage == 1 && org.eventLine < 1 && cur.eventLine >= 1 && !vars.tempVar},
        {"chapter4",             (org, cur) => cur.map == 293 && cur.eventID == 6 && cur.eventPage == 6 && org.eventLine < 1 && cur.eventLine >= 1},
        {"chapter3",             (org, cur) => cur.map == 293 && cur.eventID == 6 && cur.eventPage == 1 && org.eventLine < 1 && cur.eventLine >= 1 && vars.tempVar},
        {"exit_the_room",        (org, cur) => cur.map == 293 && cur.eventID == 1 && cur.eventPage == 2 && org.eventLine < 12 && cur.eventLine >= 12},
        {"pure_zone2",           (org, cur) => cur.map == 197 && cur.eventID == 1 && cur.eventPage == 2 && org.eventLine < 12 && cur.eventLine >= 12},
        {"pure_zone3",           (org, cur) => cur.map == 292 && cur.eventID == 1 && cur.eventPage == 2 && org.eventLine < 12 && cur.eventLine >= 12},
        {"chapter2",             (org, cur) => cur.map == 293 && cur.eventID == 6 && cur.eventPage == 3 && org.eventLine < 6 && cur.eventLine >= 6},
        {"chapter1",             (org, cur) => cur.map == 340 && cur.eventID == 1 && cur.eventPage == 6 && org.eventLine < 1 && cur.eventLine >= 1},
        {"ending",               (org, cur) => vars.offset.IsRunning && vars.offset.ElapsedMilliseconds > 150}
    };
    vars.completedSplits = new HashSet<string>();
}

start
{
    if(current.map == 9 && current.eventID == 1 && current.eventPage == 1 && old.eventLine < 27 && current.eventLine >= 27)
    {
        print("[OFF] Timer automatically started");
        return true;
    }
}

reset
{
    if(current.map == 9 && current.eventID == 1 && current.eventPage == 1 && old.eventLine < 2 && current.eventLine >= 2)
    {
        print("[OFF] Timer automatically reset");
        return true;
    }
}

onReset
{
    vars.tempVar = false;
    vars.offset.Reset();
    vars.completedSplits.Clear();
    print("[OFF] All splits have been reset to initial state");
}

update
{
    if(old.map != current.map)
    {
        print("[OFF] Map: " + old.map + " -> " + current.map);

        if(old.map == 331 && current.map == 293 && !vars.tempVar) // Finished Chapter 3 (exited the inverted corridor)
            vars.tempVar = true;
    }

    // battleEnded becomes 1 when "Adversaries purified" first appears, but time ends when the text fully scrolls
    else if(settings["ending"] && current.map == 347 && !vars.offset.IsRunning && old.battleEnded == 0 && current.battleEnded == 1 && ((current.battleID == 2 && current.batterHP > 0) || (current.battleID == 5 && current.judgeHP > 0)))
        vars.offset.Start();
}

split
{
    // The event pointers sometimes contain garbage values, so this is for safety
    if(current.eventLine < 0 || current.eventLine > 100)
        return false;

    foreach(var split in vars.splits)
    {
        if(!settings[split.Key] || 
           vars.completedSplits.Contains(split.Key) ||
           !split.Value(old, current)) continue;

        vars.offset.Reset();
        vars.completedSplits.Add(split.Key);
        print("[OFF] Split triggered (" + split.Key + ")");
        return true;
    }
}

