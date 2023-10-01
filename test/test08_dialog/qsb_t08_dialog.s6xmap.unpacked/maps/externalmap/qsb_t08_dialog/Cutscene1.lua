function Cutscene1()
    local Cutscene = {
        RestoreGameSpeed = false,
        HideBorderPins   = false,
        BigBars          = false,
        BarOpacity       = 1.000000,
        FastForward      = false,
    };
    local AP = AddCutscenePages(Cutscene);

    AP {
        Flight  = "c01",
        Title   = "",
        Text    = "",
        Action  = nil,
        FadeIn  = nil,
        FadeOut = nil,
    };
    AP {
        Flight  = "c02",
        Title   = "",
        Text    = "",
        Action  = nil,
        FadeIn  = nil,
        FadeOut = nil,
    };
    AP {
        Flight  = "c03",
        Title   = "",
        Text    = "",
        Action  = nil,
        FadeIn  = nil,
        FadeOut = nil,
    };


    Cutscene.Starting = nil;
    Cutscene.Finished = nil;

    return StartCutscene(Cutscene, "Cutscene1", 1);
end