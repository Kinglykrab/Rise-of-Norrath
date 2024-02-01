sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 20000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 4500);
	$npc->ModifyNPCStat("max_hit", 6500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	for my $i (0..quest::ChooseRandom(1..3)) {
		if (quest::ChooseRandom(1..100) > 75) {
			$npc->AddItem(107, 1);
		}
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::setnexthpevent(80);
	} elsif ($combat_state == 0) {
		quest::depopall(2000183);
	}
}

sub EVENT_HP {
	my %guard_spawns = (0 => [6.06, 3240.01, 101.74, 255.0],
	1 => [-9.44, 3239.81, 101.74, 255.0]);
	if ($hpevent ~~ [20, 40, 60, 80]) {
		my $next_event = ($hpevent - 20);
		quest::setnexthpevent($next_event);
		foreach my $guard (sort {$a <=> $b} keys %guard_spawns) {
			plugin::Spawn2(2000183, 1, @{$guard_spawns{$guard}});
		}
		$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1^35,1");
		quest::settimer("Bodyguards", 1);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Bodyguards") {
		quest::stoptimer("Bodyguards");
		if (!plugin::Spawned(2000183)) {
			$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
			return;
		}
		quest::settimer("Bodyguards", 1);
	}
}

sub EVENT_DEATH_COMPLETE {
	quest::signalwith(2000229, 4);
}