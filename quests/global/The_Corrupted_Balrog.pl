sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 250000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 25500);
	$npc->ModifyNPCStat("max_hit", 28500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 17);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	quest::setnexthpevent(99);
}

sub EVENT_HP {
	my %coords = (0 => [-60, 60],
	1 => [-60, 60]);
	if ($hpevent ~~ [9, 19, 29, 39, 49, 59, 69, 79, 89, 99]) {
		my $next_event = ($hpevent - 10);
		quest::setnexthpevent($next_event);
		foreach my $spawn (1..4) {
			plugin::Spawn2(2000286, 1, quest::ChooseRandom($coords{0}[0]..$coords{0}[1]), quest::ChooseRandom($coords{1}[0]..$coords{1}[1]), -495.87, 0);
		}
		plugin::ZoneAnnounce("Spawning rocks at the top of tower.");
	}
}




