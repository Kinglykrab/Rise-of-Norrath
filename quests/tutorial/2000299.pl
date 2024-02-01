sub EVENT_SPAWN {
	quest::settimer("texture",5);
}

sub EVENT_TIMER {
	if($timer eq "texture") {
		$npc->SetTexture(quest::ChooseRandom(1..11));
		quest::stoptimer("texture");
		quest::settimer("texture",30);
	}
}