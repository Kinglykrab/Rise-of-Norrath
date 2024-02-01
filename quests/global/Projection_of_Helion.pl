sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 85000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 7000);
	$npc->ModifyNPCStat("max_hit", 8000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->ModifyNPCStat("spellscale", 1600);
	quest::setnexthpevent(90);
}

sub EVENT_COMBAT {
	my %portal_spawns = (0 => [127.90, -523.33, 405.04, 52.8],
	1 => [213.10, -541.61, 404.07, 487.3]);
	if ($combat_state == 1) {
		foreach my $portal (sort {$a <=> $b} keys %portal_spawns) {
			plugin::Spawn2(2000235, 1, @{$portal_spawns{$portal}});
		}
	} else {
		$npc->BuffFadeAll();
		quest::depopall($_) for (2000235..2000238);
		quest::depopall($_) for (2000243);
	}
}

sub EVENT_HP {
	if ($hpevent ~~ [10, 20, 30, 40, 50, 60, 70, 80, 90]) {
		$npc->CastSpell(quest::ChooseRandom(4674, 4688), $npc->GetID());
		my $next_event = ($hpevent - 10);
		quest::settimer($_, 1) for ("DD", "DoT");
		quest::setnexthpevent($next_event);
		plugin::ZoneAnnounce("Projection of Helion whispers in your mind, 'Your mind is weak soon you too shall be corrupted...'");
		if ($hpevent == 50) {
			plugin::Spawn2(2000237, 1, 176.23, -436.52, 406.57, 263);
		}
	}
}

sub EVENT_DEATH_COMPLETE {
	plugin::ZoneAnnounce("Projection of Helion whispers in your mind, 'How naive of you to think this is where my corruption ends...'");
	quest::depopall($_) for (2000235..2000237);
}

sub EVENT_TIMER {
	if ($timer eq "DD") {
		quest::stoptimer("DD");	
		my $corruption_ent = $npc->GetHateRandom();
		$npc->CastSpell(5338, $corruption_ent->GetID(), 22, -1, -1, -1000);
	} elsif ($timer eq "DoT") {
		quest::stoptimer("DoT");
		my $corruption_ent = $npc->GetHateRandom();
		$npc->CastSpell(1619, $corruption_ent->GetID(), 22, -1, -1, -1000);
	}
}