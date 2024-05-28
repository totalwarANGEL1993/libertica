-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --
-- ||||                          GLOBALES SKRIPT                         |||| --
-- ||||                    --------------------------                    |||| --
-- ||||                            Testmap 21                            |||| --
-- ||||                           totalwarANGEL                          |||| --
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| --

-- ========================================================================== --

if CONST_IS_IN_DEV then
    Script.Load("E:/Repositories/libertica/var/libertica/librarian.lua");
    Lib.Loader.PushPath("E:/Repositories/libertica/var/");
else
    Script.Load("maps/externalmap/qsb_t08_dialog/libertica/librarian.lua");
end
Lib.Require("comfort/global/ReplaceEntity");
Lib.Require("core/Core");
Lib.Require("module/quest/Quest");
Lib.Require("module/quest/QuestJornal");
Lib.Require("module/entity/NPC");
Lib.Require("module/information/BriefingSystem");
Lib.Require("module/information/CutsceneSystem");
Lib.Require("module/information/DialogSystem");
Lib.Require("module/settings/Sound");

-- ========================================================================== --

-- |||| JOURNAL |||| --

function QuestJournalTest()
    SetupQuest {
        Name        = "TestJornalQuest1",
        Suggestion  = "Look at your jornal",
        Receiver    = 1,

        Goal_NoChange(),
        Trigger_Time(0),
    }

    ShowJournalForQuest("TestJornalQuest1", true);
    AllowNotesForQuest("TestJornalQuest1", true);

    local Entry1 = CreateJournalEntry("Normal Tier entry");
    local Entry2 = CreateJournalEntry("Higher Tier entry");
    AddJournalEntryToQuest(Entry1, "TestJornalQuest1");
    AddJournalEntryToQuest(Entry2, "TestJornalQuest1");
    HighlightJournalEntry(Entry2, true);
end

-- |||| BRIEFING |||| --

-- > BriefingTest1([[foo]], 1)

function BriefingTest1(_Name, _PlayerID)
    local Briefing = {
        HideBorderPins = true,
        ShowSky = true,
    }
    local AP, ASP, AAN = AddBriefingPages(Briefing);

    -- Animations are created automatically because a position is given.
    ASP("Page 1", "This is a briefing with default animation.", true, "pos2");
    ASP("Page 2", "It works just as you are used to it.", false, "pos2");
    ASP("Page 3", "No fancy camera magic and everything in one line.", true, "pos4");
    ASP("Page 4", "Text is displayed until the player skips the page.", false, "pos4");

    Briefing.Starting = function(_Data)
    end
    Briefing.Finished = function(_Data)
    end
    StartBriefing(Briefing, _Name, _PlayerID)
end

-- > BriefingTest2([[foo]], 1)
function BriefingTest2(_Name, _PlayerID)
    local Briefing = {
        EnableBorderPins = false,
        EnableSky = true,
        EnableFoW = false,
    }
    local AP, ASP = AddBriefingPages(Briefing);

    ASP("SpecialNamedPage1", "Page 1", "This is a briefing. I have to say important things.");
    ASP("SpecialNamedPage2", "Page 2", "WOW! That is very cool.");

    Briefing.PageAnimation = {
        ["SpecialNamedPage1"] = {
            Clear = true,
            {30, {GetFrameVector("Pos1", 1500, "npc1", 250)},
                 {GetFrameVector("Pos2", 1500, "npc1", 0)}}
        },
    }

    Briefing.Starting = function(_Data)
    end
    Briefing.Finished = function(_Data)
    end
    StartBriefing(Briefing, _Name, _PlayerID)
end

-- > BriefingTest3([[foo]], 1)
function BriefingTest3(_Name, _PlayerID)
    local Briefing = {
        EnableBorderPins = false,
        EnableSky = true,
        EnableFoW = false,
    }
    local AP, ASP = AddBriefingPages(Briefing);

    ASP("SpecialNamedPage1", "Page 1", "This is a briefing. I have to say important things.", false, "hero");
    ASP("SpecialNamedPage2", "Page 2", "WOW! That is very cool.", false, "hero");

    Briefing.PageParallax = {
        ["SpecialNamedPage1"] = {
            {"C:/IMG/Paralax1.png", 60, 0, 0, 1, 1, 255, 0, 0, 1, 1, 255},
            {"C:/IMG/Paralax2.png", 60, 0, 0, 1, 1, 255, 0, 0, 1, 1, 255},
            {"C:/IMG/Paralax3.png", 60, 0, 0, 1, 1, 255, 0, 0, 1, 1, 255},
            {"C:/IMG/Paralax4.png", 60, 0, 0, 1, 1, 255, 0, 0, 1, 1, 255},
        },
        ["SpecialNamedPage2"] = {
            Clear = true
        },
    };

    Briefing.Starting = function(_Data)
    end
    Briefing.Finished = function(_Data)
    end
    StartBriefing(Briefing, _Name, _PlayerID)
end

-- > BriefingTest4([[foo]], 1)
function BriefingTest4(_Name, _PlayerID)
    local Briefing = {
        EnableBorderPins = false,
        EnableSky = true,
        EnableFoW = false,
    }
    local AP, ASP = AddBriefingPages(Briefing);

    ASP("Page 1", "Gleich kommt der Fader...", false, "hero");

    AP {
        Name = "FadingPage",
        Title = "Page 2",
        Text = "Wussshhh...!",
        Position = "hero",
        DialogCamera = true,
        BarOpacity = 0;
        Duration = 3,
    }
    AP {
        Name = "DarkPage",
        Position = "hero",
        DialogCamera = true,
        Duration = 3,
        FaderAlpha = 1,
    }

    ASP("Page 4", "Das war aber cool...", false, "hero");

    Briefing.PageParallax = {
        ["FadingPage"] = {
            Foreground = true,
            {"C:/IMG/Fader1.png", 3,
             {0.5, 0, 1, 1, 255},
             {0, 0, 0.5, 1, 255}},
        },
        ["DarkPage"] = {
            Clear = true
        },
    };

    Briefing.Starting = function(_Data)
    end
    Briefing.Finished = function(_Data)
    end
    StartBriefing(Briefing, _Name, _PlayerID)
end

-- |||| CUTSCENE |||| --

-- > CutsceneTest([[Foo]], 1)
function CutsceneTest(_Name, _PlayerID)
    local Cutscene = {};
    local AF = AddCutscenePages(Cutscene);

    AF {
        Flight  = "c01",
        Title   = "Flight 1",
        Text    = "What is the first rule of a cutscene?",
        FadeIn  = 3,
    };
    AF {
        Flight  = "c02",
        Title   = "Flight 2",
        Text    = "They are NOT supposed to display huge chuncks of text!",
    };
    AF {
        Flight  = "c03",
        Title   = "Flight 3",
        Text    = "Keep the text small and simple, stupid!",
        FadeOut = 3,
    };

    Cutscene.Finished = function()
    end
    StartCutscene(Cutscene, _Name, _PlayerID)
end

-- > CutsceneBriefingTest([[Foo]], 1)
function CutsceneBriefingTest(_Name, _PlayerID)
    local Briefing = {
        EnableBorderPins = false,
        EnableSky = true,
        EnableFoW = false,
    }
    local AP, ASP = AddBriefingPages(Briefing);

    Briefing.PageAnimation = {
        ["Page1"] = {
            {30, {GetFrameVector("pos1", 1750, "hero", 500)},
                 {GetFrameVector("pos2", 1500, "hero", 500)},
                 {GetFrameVector("pos3", 1250, "Pos1", 500)},
                 {GetFrameVector("pos4", 1150, "Pos1", 500)},
            },
        },
    };

    AP {
        Name = "Page1",
        Title = "Page 1",
        Text = "This is page 1 of the pseudo cutscene.",
    }

    AP {
        Name = "Page2",
        Title = "Page 2",
        Text = "This is page 2 of the pseudo cutscene.",
    }

    Briefing.Starting = function(_Data)
    end
    Briefing.Finished = function(_Data)
    end
    StartBriefing(Briefing, _Name, _PlayerID)
end

-- |||| DIALOG |||| --

-- > CreateTestNPCDialogQuest()
function CreateTestNPCDialogQuest()
    ReplaceEntity("npc1", Entities.U_KnightSabatta);

    SetupQuest {
        Name        = "TestNpcQuest3",
        Suggestion  = "Speak to this npc.",
        Receiver    = 1,

        Goal_NPC("npc1", "-"),
        Reward_Dialog("TestDialog", "CreateTestNPCDialogBriefing"),
        Trigger_Time(0),
    }

    SetupQuest {
        Name        = "TestNpcQuest9",
        Suggestion  = "Sometimes it just work's!",
        Receiver    = 1,

        Goal_InstantSuccess(),
        Trigger_Dialog("TestDialog", 1, 0),
    }
end

function CreateTestNPCDialogBriefing(_Name, _PlayerID)
    local Dialog = {
        DisableFow = true,
        DisableBoderPins = true,
        RestoreGameSpeed = true,
        RestoreCamera = true,
    };
    local AP, ASP = AddDialogPages(Dialog);

    TestOptionVisibility = true;

    AP {
        Name         = "StartPage",
        Text         = "This is a test!",
        Actor        = 1,
        Position     = "npc1",
        DialogCamera = true,
        MC           = {
            {"Continue testing", "ContinuePage"},
            {"Remove answer",
             function()
                TestOptionVisibility = false;
                return "ContinuePage";
             end,
             function() return not TestOptionVisibility; end},
            {"Stop testing", "EndPage"}
        }
    }

    AP {
        Name         = "ContinuePage",
        Text         = "Splendit, it seems to work as intended.",
        Actor        = 1,
        Position     = "hero",
        DialogCamera = true,
    }

    AP {
        Text         = "We can show large texts with portrait... {cr}{cr}Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
        Actor        = 2,
        Position     = "npc1",
        DialogCamera = true,
    }
    AP {
        Text         = "... or without portrait... {cr}{cr}Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
        Position     = "npc1",
        DialogCamera = true,
    }
    AP {
        Text         = "And with auto skip after some seconds... {cr}{cr}Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.",
        Actor        = 2,
        Position     = "npc1",
        Duration     = 12,
        DialogCamera = true,
    }
    AP("StartPage");

    AP {
        Name         = "EndPage",
        Text         = "Well, then we end this mess!",
        Position     = "npc1",
        DialogCamera = true,
    }

    Dialog.Starting = function(_Data)
    end
    Dialog.Finished = function(_Data)
    end
    StartDialog(Dialog, _Name, _PlayerID);
end

-- ========================================================================== --

function GameCallback_Lib_LoadingFinished()
    ActivateDebugMode(true, true, true, true, false);
    SetPlayerPortrait(1);

    RequestAlternateSound();
    RequestDialogAlternateGraphics();
end

