// OneShot: The Pancake Episode Autosplitter by NERS

state("oneshot_pancakes")
{
    int igtFrames : 0x460C50, 0x10, 0x10, 0x1EC;

    int room      : "x64-vcruntime140-ruby250.dll", 0x20B0C0, 0x10, 0x718, 0x0, 0x8, 0x18, 0x0, 0x18, 0x10;
    int eventID   : "x64-vcruntime140-ruby250.dll", 0x20B0C0, 0x10, 0x718, 0x0, 0x8, 0x18, 0x0, 0x18, 0x18;
    int eventLine : "x64-vcruntime140-ruby250.dll", 0x20B0C0, 0x10, 0x718, 0x0, 0x8, 0x18, 0x0, 0x18, 0x60;    
    
    string32 sound : 0x460C50, 0x10, 0x48, 0x40, 0x8, 0x488, 0x80, 0x10, 0x0;
}

init
{
    if(timer.CurrentTimingMethod == TimingMethod.RealTime && timer.CurrentPhase == TimerPhase.NotRunning)
    {
        var message = MessageBox.Show
        (
            "LiveSplit uses a Load Remover for this game. Would you like to change the current timing method to Game Time instead of Real Time?",
            "LiveSplit | OneShot: The Pancake Episode", MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if(message == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

update
{
    current.room = (current.room >> 1);
    current.eventID = (current.eventID >> 1);
    current.eventLine = (current.eventLine >> 1);
}

start
{
    return (current.room == 0 && old.sound != @"Audio/SE/title_decision.wav" && current.sound == @"Audio/SE/title_decision.wav");
}

reset
{
    return (current.room == 0 && old.sound != @"Audio/SE/title_decision.wav" && current.sound == @"Audio/SE/title_decision.wav");
}

split
{
    return (current.room == 53 && current.eventID == 23 && current.eventLine >= 334 && current.eventLine <= 339);
}

gameTime
{
    return TimeSpan.FromSeconds(current.igtFrames / 60.0d);
}