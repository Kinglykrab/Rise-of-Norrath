sub EVENT_SPAWN {
	quest::setnexthpevent(50);
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 15000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 150) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 2000);
	$npc->ModifyNPCStat("max_hit", 3000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 75000) for ("ac", "atk");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	for my $i (0..quest::ChooseRandom(1..3)) {
		if (quest::ChooseRandom(1..100) > 75) {
			$npc->AddItem(101, 1);
		}
	}
	$npc->AddItem(185001, 1);
}

sub EVENT_HP {
	if ($hpevent == 50) {
		if (!$npc->EntityVariableExists("Invul") || $npc->GetEntityVariable("Invul") < 3) {
			$npc->SetEntityVariable("Invul", ($npc->EntityVariableExists("Invul") ? ($npc->GetEntityVariable("Invul") + 1) : 1));
			$npc->SetHP(int($npc->GetMaxHP() * .75));
			plugin::ZoneAnnounce("Lady Vox heals herself and begins to cast an incantation.");
			quest::setnexthpevent(50);
		}
		quest::stoptimer("Vox");
		quest::settimer("Vox", quest::ChooseRandom(5..15));
		quest::settimer("Debuff", quest::ChooseRandom(7..15));
		$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^19,1^20,1^21,1");
		plugin::ZoneAnnounce("Lady Vox's scales glow with imbued permafrost.");
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Vox", 1);
	} elsif ($combat_state == 0) {
		quest::stoptimer("Vox");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Vox") {
		quest::stoptimer("Vox");
		my @hatelist = $npc->GetHateList();
		my @vaccum_array = ();
		foreach my $hate_ent (@hatelist) {
			my $vacuum_ent = $hate_ent->GetEnt()->CastToMob();
			push @vacuum_array, $vacuum_ent->GetCleanName();
			quest::shout(@vacuum_array);
			my $vacuum_hp = int($vacuum_ent->GetHP() / quest::ChooseRandom(2..6));
			$vacuum_ent->SetHP($vacuum_ent->GetHP() - $vacuum_hp);
			$npc->SetHP($npc->GetHP() + ($npc->GetHP() / quest::ChooseRandom(3..6)));
			if ($vacuum_ent->IsClient()) {
				plugin::ClientMessage($vacuum_ent, "Lady Vox has sucked the air from your lungs, causing you to lose " . plugin::commify($vacuum_hp) . " health.");
			}
		}
		plugin::ZoneAnnounce("Lady Vox uses her wings to suck the air from the room, causing damage to " . join(", ", @vacuum_array) . ".");
		quest::settimer("Vox", quest::ChooseRandom(5..15));
	} elsif ($timer eq "Debuff") {
		quest::stoptimer("Debuff");
		$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
		quest::settimer("Vox", quest::ChooseRandom(5..15));
	}
}