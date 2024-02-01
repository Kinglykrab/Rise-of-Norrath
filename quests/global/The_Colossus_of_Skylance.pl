sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 62500000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 7000);
	$npc->ModifyNPCStat("max_hit", 8000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->ModifyNPCStat("spellscale", 5000);
	quest::setnexthpevent(80);
}

sub EVENT_HP {
	if ($hpevent ~~ [20, 40, 60, 80]) {
		my $next_event = ($hpevent - 20);
		plugin::SpawnFormation(2000234, 4, 20);
		quest::setnexthpevent($next_event);
		$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1^35,1");
		quest::settimer("Runes", 1);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Runes") {
		quest::stoptimer("Runes");
		if (!plugin::Spawned(2000234)) {
			$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
		} else {
			quest::settimer("Runes", 1);
		}
	}
}

sub EVENT_DEATH_COMPLETE {
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..45]) {
		plugin::Emote("Re-organizing stone structure for maximum effectiveness against threats.");
		plugin::Spawn2(2000209, 1, -42.22, 468.78, 415.49, 312.5);
	} elsif ($chance ~~ [46..100]) {
		plugin::Emote("Re-organization impossible, initiating terminal procedures.");
	}
}