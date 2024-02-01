sub EVENT_SPAWN {
	$npc->AddCash(0, 0, 0, quest::ChooseRandom(2000..5000));
	$npc->SetSpecialAbility($_, 1) for (quest::ChooseRandom(12..17), 21);
	$npc->ModifyNPCStat($_, 1500) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 45) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 500);
	$npc->ModifyNPCStat("max_hit", 750);
	$npc->ModifyNPCStat("avoidance", 50);
	$npc->ModifyNPCStat($_, 20000) for ("ac", "atk", "accuracy");
	quest::settimerMS("hp",1);
}

sub EVENT_TIMER {
	if($timer eq "hp") {
		quest::stoptimer("hp");
		$npc->ModifyNPCStat("max_hp", 500000);
		$npc->SetHP($npc->GetMaxHP());
	}
}