sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 20000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 4500);
	$npc->ModifyNPCStat("max_hit", 6500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	for my $i (0..quest::ChooseRandom(1..3)) {
		if (quest::ChooseRandom(1..100) > 75) {
			$npc->AddItem(106, 1);
		}
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Smash", quest::ChooseRandom(15..30));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Smash");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Smash") {
		quest::stoptimer("Smash");	
		my @hatelist = $npc->GetHateList();
		my @smash_array = ();
		foreach my $hate_ent (@hatelist) {
			my $smash_ent = $hate_ent->GetEnt()->CastToMob();
			my $smash_hp = int($smash_ent->GetHP() / 3);
			$smash_ent->SetHP($smash_ent->GetHP() - $smash_hp);
			$npc->SetHP($npc->GetHP() + $smash_hp);
			if ($smash_ent->IsClient()) {
				plugin::ClientMessage($smash_ent, "Hatchet winds up and swings both of his weapons at YOU for " . plugin::commify($smash_hp) . " points of damage!");
				}
				push @smash_array, $smash_ent->GetCleanName();
			}
			plugin::ZoneAnnounce("Hatchet winds up and swings both of his weapons at " . join(", ", @smash_array) . ".");
			quest::settimer("Smash", quest::ChooseRandom(15..30));
			}
}

sub EVENT_DEATH_COMPLETE {
	plugin::Emote("Don't you dare use my teleportation stone! The Lord of Dreadspire must not be disturbed!");
	plugin::Spawn2(2000189,1, -0.53, 156.53, -1352.00, 254.3);
	quest::signalwith(2000229, 3);
}


