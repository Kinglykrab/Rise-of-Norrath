sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 15000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 125) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 2000);
	$npc->ModifyNPCStat("max_hit", 3000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 62500) for ("ac", "atk");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	for my $i (0..quest::ChooseRandom(1..3)) {
		if (quest::ChooseRandom(1..100) > 75) {
			$npc->AddItem(102, 1);
		}
	}
	$npc->AddItem(185002, 1);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Sev", 1);
	} elsif ($combat_state == 0) {
		quest::stoptimer("Sev");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Sev") {
		quest::stoptimer("Sev");
		my $slow_ent = $npc->GetHateRandom();	
		$npc->CastSpell(quest::ChooseRandom(22149..22157), $slow_ent->GetID(), -1, -1, 0, 100000);
		plugin::ZoneAnnounce("Severilous uses his fangs to poison " . $slow_ent->GetCleanName() . ".");
		quest::settimer("Sev", quest::ChooseRandom(5..15));
	}
}