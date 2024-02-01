sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 50000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 7000);
	$npc->ModifyNPCStat("max_hit", 8000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 15);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->ModifyNPCStat("spellscale", 2000);
}  

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Lightning", quest::ChooseRandom(10..20));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Lightning");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Lightning") {
		quest::stoptimer("Lightning");
		my $Lightning_ent = $npc->GetHateRandom();
		$npc->CastSpell(26709 , $Lightning_ent->GetID(), -1, -1, 0, 100000);
		if ($Lightning_ent->IsClient()) {
			plugin::ClientMessage($Lightning_ent, "Sundersky, the Sire of Storms calls down a bolt of lightning, stunning you!");
		}
		quest::settimer("Lightning", quest::ChooseRandom(10..20));
	}
}

sub EVENT_DEATH_COMPLETE {
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..65]) {
	plugin::ZoneAnnounce("Sundersky, begins to gather electricity from the air around him and is reborn!");
	plugin::Spawn2(2000206, 1, $x, $y, $z, $h);
	}
	elsif ($chance ~~ [66..100]) {
	plugin::ZoneAnnounce("With a flicker of static the maelstrom becomes inanimate.");
	}
}