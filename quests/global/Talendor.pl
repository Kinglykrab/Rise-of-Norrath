sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 15000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 100) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 2000);
	$npc->ModifyNPCStat("max_hit", 3000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 500000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	for my $i (0..quest::ChooseRandom(1..3)) {
		if (quest::ChooseRandom(1..100) > 75) {
			$npc->AddItem(103, 1);
		}
	}
	$npc->AddItem(185003, 1);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Talendor", 1);
	} elsif ($combat_state == 0) {
		quest::stoptimer("Talendor");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Talendor") {
		quest::stoptimer("Talendor");
		my $chance = quest::ChooseRandom(1..100);
		if ($chance ~~ [1..40]) {			
			my $fear_ent = $npc->GetHateRandom();
			$npc->CastSpell(24099, $fear_ent->GetID(), -1, -1, 0, 100000);
			plugin::ZoneAnnounce("Talendor instills great fear in his foes, he seems ready to strike.");
		} elsif ($chance ~~ [41..100]) {
			my @hatelist = $npc->GetHateList();
			my @siphoned_array = ();
			foreach my $hate_ent (@hatelist) {
				my $siphon_ent = $hate_ent->GetEnt()->CastToMob();
				my $siphon_hp = int($siphon_ent->GetHP() / 3);
				$siphon_ent->SetHP($siphon_ent->GetHP() - $siphon_hp);
				$npc->SetHP($npc->GetHP() + $siphon_hp);
				if ($siphon_ent->IsClient()) {
					plugin::ClientMessage($siphon_ent, "Talendor has drained " . plugin::commify($siphon_hp) . " health from you by drinking your blood.");
				}
				push @siphoned_array, $siphon_ent->GetCleanName();
			}
			plugin::ZoneAnnounce("Talendor siphons blood from " . join(", ", @siphoned_array) . ".");
		}
		quest::settimer("Talendor", quest::ChooseRandom(5..15));
	}
}