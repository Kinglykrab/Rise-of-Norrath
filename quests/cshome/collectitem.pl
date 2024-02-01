sub EVENT_SAY {
#quest::collectitems(32557, 2);	
quest::say("your count is " . quest::countitem(32557) . "");
}