sub EVENT_SPAWN {
	$npc->SetLevel(70);
	$npc->ModifyNPCStat("max_hp", 1000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 2500);
	$npc->ModifyNPCStat("max_hit", 3500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 100000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "1^5,1^6,1^7,1^21,1");
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Silence", 5);
	} elsif ($combat_state == 0) {
		quest::stoptimer("Silence");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Silence") {
		quest::stoptimer("Silence");
		my $silence_ent = $npc->GetHateRandom();
		$npc->CastSpell(12478, $silence_ent->GetID(), -1, -1, 0, 100000);
		if ($silence_ent->IsClient()) {
			plugin::ClientMessage($silence_ent, "A Sonic Bat has silenced you with its powerful scream.");
		}
		quest::settimer("Silence", 5);
	}
}
		