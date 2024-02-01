sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 95000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 16000);
	$npc->ModifyNPCStat("max_hit", 20000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "1^5,1^6,1^7,1^21,1");
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Repair", quest::ChooseRandom(5..15));
	}
}

sub EVENT_TIMER {
	if ($timer eq "Repair") {
		quest::stoptimer("Repair");
		my @hatelist = $npc->GetHateList();
			my @repair_array = ();
			foreach my $hate_ent (@hatelist) {
				my $repair_ent = $hate_ent->GetEnt()->CastToMob();
				my $repair_hp = int($repair_ent->GetHP() / 15);
				$repair_ent->SetHP($repair_ent->GetHP() - $repair_hp);
				$npc->SetHP($npc->GetHP() + $repair_hp);
				if ($repair_ent->IsClient()) {
					plugin::ClientMessage($repair_ent, "Bell Repair Bot has 'fixed' you causing " . plugin::commify($repair_hp) . " points of damage.");
				}
				push @repair_array, $repair_ent->GetCleanName();
			}
			plugin::ZoneAnnounce("Bell Repair Bot attempts to 'repair' " . join(", ", @repair_array) . ".");
		}
		quest::settimer("Repair", quest::ChooseRandom(5..15));
}


