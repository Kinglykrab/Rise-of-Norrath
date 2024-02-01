sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 57500000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 6500);
	$npc->ModifyNPCStat("max_hit", 7500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Charm", quest::ChooseRandom(10..20));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Charm");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Charm") {
		quest::stoptimer("Charm");
		my $charm_ent = $npc->GetHateRandom();
		$npc->CastSpell(912, $charm_ent->GetID(), 22, -1, -1, 10000);
		if ($charm_ent->IsClient()) {
			plugin::ClientMessage($charm_ent, "The Manifestation of Ravenglass calls to you in your mind, beckoning you to his command.");
		}
		quest::settimer("Charm", quest::ChooseRandom(15..30));
	}
}


sub EVENT_DEATH_COMPLETE {
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..45]) {
		plugin::Emote("The undead never truly die, we always rise again.");
		plugin::Spawn2(2000194, 1, $x, $y, $z, $h);
	} elsif ($chance ~~ [46..100]) {
		plugin::ZoneAnnounce("The soul of Ravenglass leaves the manifestation.");
	}
}