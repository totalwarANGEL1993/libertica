local source = {};
local copy = CopyTable(source);

StartBriefing({}, "Foo", 1);

Goal_NPC("foo", "bar");
Reward_DEBUG(true, true, true, true, false);

Goal_ActivateSeveralObjects("foo");