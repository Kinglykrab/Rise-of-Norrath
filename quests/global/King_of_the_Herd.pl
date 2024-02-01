sub EVENT_SPAWN {
	plugin::AddBossLoot();
	$npc->SetLevel(80);
	$npc->ModifyNPCStat("max_hp", 62500000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 5500);
	$npc->ModifyNPCStat("max_hit", 6500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->ModifyNPCStat("texture", 2);
	quest::setnexthpevent(80);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		plugin::SpawnFormation(2000225, 4, 35);
	} else {
		quest::depopall(2000225);
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
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..45]) {
		plugin::ZoneAnnounce("King of the Herd says, 'I am the herd! You cannot kill me.'");
		plugin::Spawn2(2000198, 1, $x, $y, $z, $h);
	} elsif ($chance ~~ [46..100]) {
		plugin::ZoneAnnounce("King of the Herd falls to the ground and takes one last massive breath.");
	}
}

