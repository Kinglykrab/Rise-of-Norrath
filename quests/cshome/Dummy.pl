sub EVENT_SPAWN {
	quest::settimer("scale",5);
	
}

sub EVENT_TIMER {
	if($timer eq "scale") {
		quest::say("scaling");
		$npc->ModifyNPCStat("accuracy", 1500);
		quest::stoptimer("scale");
	}
}