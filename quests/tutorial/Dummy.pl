sub EVENT_SAY {
	#quest::settimer("scale",5);
	quest::say("scaling");
|

#sub EVENT_TIMER {
	#if($timer eq "scale") {
	#	quest::say("scaling");
	#	#$npc->ModifyNPCStat("strikethrough", 100);
	#	quest::stoptimer("scale");
#	}
#}