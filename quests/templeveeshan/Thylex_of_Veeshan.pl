sub EVENT_SAY {
	if($text=~/hail/i) {
		quest::say("You wish to [" . quest::saylink("call my master",1) . "]? It will be your last mistake.");
	} elsif($text eq "call my master") {
		if($status > 100) {
			quest::say("Starting event..");
			StartEvent();
		}
	}
}


sub StartEvent {
	plugin::Spawn2(2000463, 1, -739.80, 511.88, 122.41, 0.5);
	quest::depop_withtimer();
	
}