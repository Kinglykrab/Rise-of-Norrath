sub EVENT_SAY {
	if($text=~/hail/i) {
		plugin::Whisper("Gather your allies and prepare for battle, $name. Let me know when you are [" . quest::saylink("Ready",1,"Ready") . "]");
	}
	if($text eq "ready") {
		plugin::Spawn2(2000309,1,535.72,0.04,3.33,364);
		quest::say("Good luck adventurers!");
		quest::depop_withtimer();
	}
}