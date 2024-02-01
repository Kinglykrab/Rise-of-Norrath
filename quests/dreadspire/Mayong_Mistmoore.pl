sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 50000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 25000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 5000);
	$npc->ModifyNPCStat("max_hit", 7500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1500000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	quest::setnexthpevent(75);
	for my $i (0..quest::ChooseRandom(1..3)) {
		if (quest::ChooseRandom(1..100) > 85) {
			$npc->AddItem(108, 1);
		}
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 0) {
		quest::depopall(2000186);
		quest::depopall(2000267);
	}
}	

sub EVENT_HP {
	my %totem_spawns = (0 => [-64.15, 3444.35, 100.13, 509.5],
	1 => [-63.80, 3525.94, 100.13, 254.5],
	2 => [65.94, 3527.97, 100.13, 253.8],
	3 => [68.58, 3443.15, 100.13, 497.8]);
	if ($hpevent ~~ [25, 75]) {
		my $next_event = ($hpevent - 25);
		quest::setnexthpevent($next_event);
		foreach my $totem (sort {$a <=> $b} keys %totem_spawns) {		
			plugin::Spawn2(2000186, 1, @{$totem_spawns{$totem}});
		}
		$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1^35,1");
		quest::settimer("Totems", 1);
		quest::settimer("Damage", quest::ChooseRandom(5..15));
	} elsif ($hpevent == 50) {
		$npc->ModifyNPCStat("min_hit", 6250);
		$npc->ModifyNPCStat("max_hit", 8500);
		$npc->ModifyNPCStat($_, 2500000) for ("ac", "atk", "accuracy");
		quest::setnexthpevent(25);
		plugin::Spawn2(2000267, 1, 1.03, 3444.85, 100.13, 508.3);
		$npc->AddToHateList($entity_list->GetNPCByNPCTypeID(2000185), 100000000);
		my @hatelist = $npc->GetHateList();
		foreach my $hate_ent (@hatelist) {
			my $hate_entity = $hate_ent->GetEnt();
			if ($hate_entity->IsClient() || ($hate_entity->IsNPC() && $hate_entity->CastToNPC()->GetNPCTypeID() != 2000185)) {
				$npc->RemoveFromHateList($hate_entity);
			}
		}
		plugin::Emote("You dare face me, Ayonae?!? I have been granted power beyond your imagination!");
	}
}

sub EVENT_TIMER {
	 if ($timer eq "Totems") {
		quest::stoptimer("Totems");
		if (!plugin::Spawned(2000186)) {
			$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");			
			return;
		}
		quest::settimer("Totems", 1);		
	} elsif ($timer eq "Damage") {
		quest::stoptimer("Damage");
		my @hatelist = $npc->GetHateList();
		my @siphoned_array = ();
		foreach my $hate_ent (@hatelist) {
			my $energy_ent = $hate_ent->GetEnt()->CastToMob();
			if ($energy_ent->GetCleanName() !~ /Ayonae/i) {
				my $energy_hp = int($energy_ent->GetHP() / 3);
				$energy_ent->SetHP($energy_ent->GetHP() - $energy_hp);
				$npc->SetHP($npc->GetHP() + $energy_hp);
				if ($energy_ent->IsClient()) {
					plugin::ClientMessage($energy_ent, "Mayong Mistmoore has drained " . plugin::commify($energy_hp) . " health from you by draining your life energy.");
				}
				push @siphoned_array, $energy_ent->GetCleanName();
			}
		}
		plugin::ZoneAnnounce("Mayong Mistmoore drains the life energy from " . join(", ", @siphoned_array) . ".");
		quest::settimer("Damage", quest::ChooseRandom(5..15));
	}
}

sub EVENT_DEATH_COMPLETE {
	plugin::Emote("How dare you defy the corrupters Ayonae! You will fall to them, mark my words...");
	quest::signalwith(2000267, 1);
}