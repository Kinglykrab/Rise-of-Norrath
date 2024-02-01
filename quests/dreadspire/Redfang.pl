sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 20000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 4000);
	$npc->ModifyNPCStat("max_hit", 6000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 500000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	for my $i (0..quest::ChooseRandom(1..3)) {
		if (quest::ChooseRandom(1..100) > 75) {
			$npc->AddItem(104, 1);
		}
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::setnexthpevent(75);
	} elsif ($combat_state == 0) {
		quest::depopall(2000173);
	}
}

sub EVENT_HP {
	if ($hpevent ~~ [25, 50, 75]) {
		my $next_event = ($hpevent - 25);
		quest::setnexthpevent($next_event);
		plugin::Spawn2(2000173, 3, $x, $y, $z, $h);
	}
}

sub EVENT_DEATH_COMPLETE {
	quest::signalwith(2000229, 1);
}