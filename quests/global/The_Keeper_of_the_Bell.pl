sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 250000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 23500);
	$npc->ModifyNPCStat("max_hit", 27500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 19);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
}
sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::setnexthpevent(90);
	}
	elsif ($combat_state == 0) {
		quest::depopall(2000283);
		$npc->SetHP($npc->GetMaxHP());
	}
}

sub EVENT_HP {
if ($hpevent ~~ [10, 20, 30, 40, 50, 60, 70, 80, 90]) {
	my $next_event = ($hpevent - 10);
	quest::setnexthpevent($next_event);
	plugin::SpawnFormation(2000283, 4, 5);
	plugin::ZoneAnnounce("Bots! We have work to do!");
	}
}

sub EVENT_DEATH_COMPLETE {
	plugin::ZoneAnnounce("The Keeper of the Bell whispers with his last breath, 'I have failed her but you will not!'");
	plugin::ZoneAnnounce("With a sharp blast of his instrument you hear the nearby trapdoor click");
	plugin::ZoneAnnounce("The Keeper of the Bell whispers once more, 'Go... Save her...'");
	plugin::Spawn2(2000284, 1, 63.24, -1.44, 3.76, 384);
}




