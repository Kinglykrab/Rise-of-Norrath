sub EVENT_SPAWN {
	$npc->SetLevel(80);
	$npc->ModifyNPCStat("max_hp", 50000000);
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
		my $next_event = ($hpevent - 20);
		quest::setnexthpevent($next_event);
		plugin::SpawnFormation(2000225, 4, 35);
	}
}

sub EVENT_DEATH_COMPLETE {
	quest::depopall(2000225);
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..65]) {
		plugin::ZoneAnnounce("Master of the Herd shouts, 'I am the herd! You cannot kill me.'");
		plugin::Spawn2(2000197, 1, $x, $y, $z, $h);
	} elsif ($chance ~~ [66..100]) {
		plugin::ZoneAnnounce("Master of the Herd falls to the ground and takes one last massive breath.");
	}
}

