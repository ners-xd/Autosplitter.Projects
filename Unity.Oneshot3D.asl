// Oneshot 3D Autosplitter by NERS

state("Oneshot 3D") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Oneshot 3D";
    vars.Helper.LoadSceneManager = true;
    vars.startedFromMenu = false;
}

update
{
    current.scene = vars.Helper.Scenes.Active.Index;
    if(old.scene == 2 && current.scene == 0) vars.startedFromMenu = true;
}

start
{
    return old.scene == 0 && current.scene == 3 && vars.startedFromMenu == true;
}

split
{  
    return old.scene == 4 && current.scene == 6;
}

reset
{
    return old.scene == 1 && current.scene == 2;
}

onReset
{
    vars.startedFromMenu = false;
}