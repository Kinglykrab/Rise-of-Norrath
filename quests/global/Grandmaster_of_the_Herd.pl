sub EVENT_SPAWN {
	plugin::AddBossLoot();
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 70000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 7000);
	$npc->ModifyNPCStat("max_hit", 8000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->CastSpell($_, $npc->GetID()) for (11597, 11997);
	quest::setnexthpevent(80);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		plugin::SpawnFormation(2000225, 4, 35);
		quest::settimer("Stun", quest::ChooseRandom(15..30));
	} else {
		quest::depopall(2000225);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Stun") {
		quest::stoptimer("Stun");
		my $stun_ent = $npc->GetHateRandom();
		$npc->CastSpell(9717, $stun_ent->GetID(), -1, -1, 0, 100000);
		$stun_ent->Stun(quest::ChooseRandom(5000..15000));
		if ($stun_ent->IsClient()) {
			plugin::ClientMessage($stun_ent, "You have been trampled!");
		}
		quest::settimer("Stun", quest::ChooseRandom(15..30));
	}
}

sub EVENT_HP {
	if ($hpevent ~~ [20, 40, 60, 80]) {
		my $next_event = ($hpevent - 10);
		quest::setnexthpevent($next_event);
		plugin::SpawnFormation(2000225, 4, 35);
	} elsif ($hpevent ~~ [10, 30, 50, 70]) {
		my $next_event2 = ($hpevent - 10);
		quest::setnexthpevent($next_event2);
		my %flee_locations = (0 => [265.10, -867.47, 179.55, $h],
		1 => [-295.56, -814.97, 191.29, $h],
		2 => [-642.60, -599.04, 194.01, $h],
		3 => [-1137.36, -460.52, 190.90, $h]);
		my $location = quest::ChooseRandom(0..3);
		$npc->GMMove($flee_locations{$location}[0], $flee_locations{$location}[1], $flee_locations{$location}[2], $flee_locations{$location}[3]);
		$npc->WipeHateList();
	}
}

sub EVENT_DEATH_COMPLETE {
	plugin::HandleBossDeath();
	quest::depopall(2000225);
}
