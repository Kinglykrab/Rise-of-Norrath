sub EVENT_SPAWN {
	quest::settimerMS("texture",1);
}

sub EVENT_TIMER {
	if($timer eq "texture") {
		$npc->SetTexture(quest::ChooseRandom(1..3));
		quest::stoptimer("texture");
	}
}