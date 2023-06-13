// Boson X Autosplitter by NERS

state("bosonx")
{
    byte    started       : 0x11DB24, 0x54, 0xBC, 0x2C;
    string8 percentageStr : 0x11D918, 0x48, 0x10, 0x800, 0x10, 0x8, 0x4E4, 0x2C;

    int frames : "gameoverlayrenderer.dll", 0x107CD8;
}

startup
{
    print("[Boson X] Autosplitter starting up");

    settings.Add("100percent", true, "Split on reaching 100% completion on each stage");
    settings.Add("200percent", true, "Split on reaching 200% completion on each stage");

    vars.framesOnStart = 0;
}

init
{
    int mms = modules.First().ModuleMemorySize; // 1204224 for v1.2.5
    print("[Boson X] Game detected - module memory size: " + mms);
}

update
{
    try { current.percentage = Double.Parse(current.percentageStr); }
    catch(Exception e) {} // this is just to avoid errors when the string is a random value (when you're not in a stage or you're dead)

    if(current.started == (old.started + 1)) // just started a stage
        vars.framesOnStart = current.frames;
}

start
{
    // add a delay because you start in the air and timer starts when you touch the ground
    return vars.framesOnStart > 0 && current.frames >= vars.framesOnStart + 60;
}

split
{
    return
        (settings["100percent"] && current.percentage >= 100.00 && current.percentage <= 105.00 && old.percentage < 100.00) ||
        (settings["200percent"] && current.percentage >= 200.00 && current.percentage <= 205.00 && old.percentage < 200.00);
}

onReset
{
    vars.framesOnStart = 0;
}
