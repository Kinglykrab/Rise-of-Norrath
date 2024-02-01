sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 37500000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 4500);
	$npc->ModifyNPCStat("max_hit", 6500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	if (quest::ChooseRandom(1..100) > 75) {
		$npc->AddItem(105, 1);
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::signalwith(2000180, 1);
		plugin::Emote("You dare challenge the might of the Three Sisters? With our power combined we will make quick work of you!");
	} elsif ($combat_state == 0) {
		quest::signalwith(2000180, 2);
	}
}

sub EVENT_DEATH_COMPLETE {
	quest::signalwith(2000229, 2);
}