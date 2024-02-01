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
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Silence", quest::ChooseRandom(10..20));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Silence");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Silence") {
		quest::stoptimer("Silence");
		my $silence_ent = $npc->GetHateRandom();
		$npc->CastSpell(32442, $silence_ent->GetID(), -1, -1, 0, -100000);
		if ($silence_ent->IsClient()) {
			plugin::ClientMessage($silence_ent, "You begin to choke in a cloud of smog.");
		}
		quest::settimer("Silence", quest::ChooseRandom(10..20));
	}
}

sub EVENT_DEATH_COMPLETE {
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..65]) {
	plugin::ZoneAnnounce("The smoldering embers of Skysmoke, the Harbinger of Oroshar begin to burn once more!");
	plugin::Spawn2(2000203, 1, $x, $y, $z, $h);
	}
	elsif ($chance ~~ [66..100]) {
	plugin::ZoneAnnounce("Wisps of smoke are all the remain of Skysmoke, the Harbinger of Oroshar...");
	}
}