// OFF Autosplitter by NERS
// Thanks to KyoshiCadre for all the room and event numbers

state("RPG_RT")
{
    int map         : 0xD2068, 0x4;
    int eventID     : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x1C;
    int eventPage   : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x14, 0x4, 0x4, 0x0, 0x10;
    int eventLine   : 0xD202C, 0x4, 0x8, 0x4, 0x0, 0x18;
    int ch3Ended    : 0xD2014, 0x60;
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
    int ch3Ended    : 0xD2014, 0x60;
    int battleID    : 0xD202C, 0x54;
    int battleEnded : 0xD2070, 0x7C, 0x14;
    int batterHP    : 0xD2008, 0xAC, 0x1C, 0x0, 0x14;
    int judgeHP     : 0xD2008, 0xAC, 0x1C, 0x14, 0x14;
    int item        : 0xD2070, 0x7C, 0x2B0;
}

startup
{
    settings.Add("zone0", false, "Zone 0");
    settings.Add("enter_mines", false, "Enter Mines");
    settings.Add("mines", false, "Mines");
    settings.Add("barn", false, "Barn");
    settings.Add("enter_postal_service", false, "Enter Postal Service");
    settings.Add("postal_service", false, "Postal Service");
    settings.Add("alma_first_half", false, "Alma First Half");
    settings.Add("alma_second_half", false, "Alma Second Half");
    settings.Add("zone1", false, "Zone 1");
    settings.Add("card_puzzle", false, "Card Puzzle");
    settings.Add("valerie", false, "Valerie");
    settings.Add("zacharie_photo", false, "Open Zacharie's Photo");
    settings.Add("park", false, "Park");
    settings.Add("pure_zone1", false, "Pure Zone 1");
    settings.Add("sugar", false, "Sugar");
    settings.Add("residential", false, "Residential");
    settings.Add("enter_japhet", false, "Enter Japhet");
    settings.Add("zone2", false, "Zone 2");
    settings.Add("area1", false, "Area 1");
    settings.Add("area2", false, "Area 2");
    settings.Add("area3", false, "Area 3");
    settings.Add("elsen_fight", false, "Elsen Fight");
    settings.Add("area4", false, "Area 4");
    settings.Add("enoch", false, "Enoch");
    settings.Add("chapter5", false, "Chapter 5");
    settings.Add("chapter4", false, "Chapter 4");
    settings.Add("chapter3", false, "Chapter 3");
    settings.Add("exit_the_room", false, "Exit The Room");
    settings.Add("pure_zone2", false, "Pure Zone 2");
    settings.Add("pure_zone3", false, "Pure Zone 3");
    settings.Add("chapter2", false, "Chapter 2");
    settings.Add("chapter1", false, "Chapter 1");
    settings.Add("ending", false, "Ending");

    vars.offset = new Stopwatch();
    vars.splits = new Dictionary<string, object[]>()
    {
        // Object variables in order: done, old map, new map, event id, event page, minimum event line, battle id, ch3 end state
        {"zone0",                new object[] {false,  -1,   8,  1,  2, 12, -1, -1}},
        {"enter_mines",          new object[] {false,  19,  20, -1, -1, -1, -1, -1}},
        {"mines",                new object[] {false,  23,  25, -1, -1, -1, -1, -1}},
        {"barn",                 new object[] {false,  28,  27, -1, -1, -1, -1, -1}},
        {"enter_postal_service", new object[] {false,  -1,  34,  4,  1, 47, -1, -1}},
        {"postal_service",       new object[] {false,  46,  47, -1, -1, -1, -1, -1}},
        {"alma_first_half",      new object[] {false,  56,  57, -1, -1, -1, -1, -1}},
        {"alma_second_half",     new object[] {false,  -1,  68,  4,  0,  4, -1, -1}},
        {"zone1",                new object[] {false,  69,  70, -1, -1, -1, -1, -1}},
        {"card_puzzle",          new object[] {false, 114, 112, -1, -1, -1, -1, -1}},
        {"valerie",              new object[] {false, 117, 116, -1, -1, -1, -1, -1}},
        {"zacharie_photo",       new object[] {false, 999,  -1, -1, -1, -1, -1, -1}}, // Handled manually in split{}
        {"park",                 new object[] {false, 136, 134, -1, -1, -1, -1, -1}},
        {"pure_zone1",           new object[] {false,  -1, 101,  1,  2, 12, -1, -1}},
        {"sugar",                new object[] {false, 152, 151, -1, -1, -1, -1, -1}},
        {"residential",          new object[] {false, 145, 115, -1, -1, -1, -1, -1}},
        {"enter_japhet",         new object[] {false,  -1, 162,  5, 11, 60,  8, -1}},
        {"zone2",                new object[] {false, 162,  70, -1, -1, -1, -1, -1}},
        {"area1",                new object[] {false,  -1, 205,  5,  0,  5, -1, -1}},
        {"area2",                new object[] {false,  -1, 212,  5,  0, 16, -1, -1}},
        {"area3",                new object[] {false,  -1, 214,  3,  0,  5, -1, -1}},
        {"elsen_fight",          new object[] {false, 234, 213, -1, -1, -1, -1, -1}},
        {"area4",                new object[] {false, 235, 213, -1, -1, -1, -1, -1}},
        {"enoch",                new object[] {false, 213,   2, -1, -1, -1, -1, -1}},
        {"chapter5",             new object[] {false,  -1, 293,  6,  1,  0, -1,  0}},
        {"chapter4",             new object[] {false,  -1, 293,  6,  6,  0, -1, -1}},
        {"chapter3",             new object[] {false,  -1, 293,  6,  1,  0, -1, 10}},
        {"exit_the_room",        new object[] {false,  -1, 293,  1,  2, 12, -1, -1}},
        {"pure_zone2",           new object[] {false,  -1, 197,  1,  2, 12, -1, -1}},
        {"pure_zone3",           new object[] {false,  -1, 292,  1,  2, 12, -1, -1}},
        {"chapter2",             new object[] {false,  -1, 293,  6,  3,  6, -1, -1}},
        {"chapter1",             new object[] {false,  -1, 340,  1,  6,  1, -1, -1}},
        {"ending",               new object[] {false, 999,  -1, -1, -1, -1, -1, -1}} // Handled manually in split{}
    };
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
    vars.offset.Reset();
    foreach(string split in vars.splits.Keys) 
        vars.splits[split][0] = false;

    print("[OFF] All splits have been reset to initial state");
}

update
{
    if(old.map != current.map)
        print("[OFF] Map: " + old.map + " -> " + current.map);
}

split
{
    if(settings["zacharie_photo"] && old.item != 112 && current.item == 112)
    {
        vars.splits["zacharie_photo"][0] = true;
        print("[OFF] Split triggered (zacharie_photo)");
        return true;
    }

    else if(settings["ending"] && current.map == 347 && current.battleEnded == 1)
    {
        if(!vars.offset.IsRunning && ((current.battleID == 2 && current.batterHP > 0) || (current.battleID == 5 && current.judgeHP > 0)) && old.battleEnded == 0)
        {
            vars.offset.Start();
        }
        else if(vars.offset.ElapsedMilliseconds >= 150)
        {
            vars.offset.Reset();
            vars.splits["ending"][0] = true;
            print("[OFF] Split triggered (ending)");
            return true;
        }
    }

    int done      = 0,
        oldMap    = 1,
        newMap    = 2,
        reqID     = 3,
        reqPage   = 4,
        minLine   = 5,
        reqBattle = 6,
        reqCh3    = 7;

    foreach(string splitKey in vars.splits.Keys)
    {
        if((!settings[splitKey] || vars.splits[splitKey][done]) ||
           (vars.splits[splitKey][oldMap] != -1 && old.map != vars.splits[splitKey][oldMap]) ||
           (vars.splits[splitKey][newMap] != -1 && current.map != vars.splits[splitKey][newMap]) ||
           (vars.splits[splitKey][reqID] != -1 && current.eventID != vars.splits[splitKey][reqID]) ||
           (vars.splits[splitKey][reqPage] != -1 && current.eventPage != vars.splits[splitKey][reqPage]) ||
           (vars.splits[splitKey][minLine] != -1 && (current.eventLine < vars.splits[splitKey][minLine] || current.eventLine > 60)) || // The event pointers sometimes become garbage values, so this is for safety
           (vars.splits[splitKey][reqBattle] != -1 && current.battleID != vars.splits[splitKey][reqBattle]) ||
           (vars.splits[splitKey][reqCh3] != -1 && current.ch3Ended != vars.splits[splitKey][reqCh3])) continue;

        if(splitKey == "alma_second_half" && current.eventLine != 4 && current.eventLine != 5) // Condition for this one because the line goes to 9 if you press No
            return false;

        vars.splits[splitKey][done] = true;
        print("[OFF] Split triggered (" + splitKey + ")");
        return true;
    }
}
