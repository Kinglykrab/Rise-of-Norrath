sub EVENT_SPAWN {
	plugin::AddBossLoot();
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 62500000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 7000);
	$npc->ModifyNPCStat("max_hit", 8000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->CastSpell(12933, $npc->GetID());
	quest::setnexthpevent(50);
}

sub EVENT_SIGNAL {
	if ($signal == 1) {
		$npc->SetHP(300000000);
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer(quest::ChooseRandom("Bite", "Roar"), quest::ChooseRandom(15..30));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Bite");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Bite") {
		my @hatelist = $npc->GetHateList();
		quest::stoptimer("Bite");	
		my @Bite_array = ();
		foreach my $hate_ent (@hatelist) {
			my $bite_ent = $hate_ent->GetEnt()->CastToMob();
			my $bite_hp = int($bite_ent->GetHP() / 2);
			$bite_ent->SetHP($bite_ent->GetHP() - $bite_hp);
			if ($bite_ent->IsClient()) {
				plugin::ClientMessage($bite_ent, "Okahn lets loose a savage howl and bites YOU for " . plugin::commify($bite_hp) . " points of damage!");
			}
				push @Bite_array, $bite_ent->GetCleanName();
		}
		plugin::ZoneAnnounce("Okahn opens his massive jaws and bites " . join(", ", @Bite_array) . ".");
		quest::settimer("Roar", quest::ChooseRandom(15..30));
	}
	elsif ($timer eq "Roar") {		
		my @hatelist = $npc->GetHateList();
		quest::stoptimer("Roar");
		my @Roar_array = ();
		foreach my $hate_ent (@hatelist) {
			if ($hate_ent->GetEnt()->IsClient()) {
				my $roar_ent = $hate_ent->GetEnt()->CastToClient();
				$roar_ent->CastSpell(366, $roar_ent->GetID());
				plugin::ClientMessage($roar_ent, "You have been put to sleep.");
			}
		}
		quest::settimer("Bite", quest::ChooseRandom(15..30));		
	} elsif ($timer eq "Adds") {
		quest::stoptimer("Adds");
		$npc->SetEntityVariable("Adds", (!$npc->EntityVariableExists("Adds") ? 1 : ($npc->GetEntityVariable("Adds") + 1)));
		if (plugin::Spawned(2000211)) {
			if (!$npc->EntityVariableExists("Furious") || $npc->GetEntityVariable("Furious") == 0) {
				$npc->CastSpell(4674, $npc->GetID());
				$npc->SetEntityVariable("Furious", 1);
				if ($npc->EntityVariableExists("Adds") && $npc->GetEntityVariable("Adds") == 10) {
					$npc->SetEntityVariable($_, 0) for ("Adds", "Furious");
				}
			}
		}
		quest::settimer("Adds", 1);
	}
}

sub EVENT_HP {
	my %reflection_spawns = (0 => [1168.41, 1289.55, 194.66, 297.8],
	1 => [1184.08, 1273.70, 194.65, 325.0]);
	if ($hpevent == 50) {
		quest::settimer("Adds", 1);
		plugin::ZoneAnnounce("Okahn peers into a pool of blood and releases reflections of his inner rage!");
		foreach my $reflection (sort {$a <=> $b} keys %reflection_spawns) {
			plugin::Spawn2(2000211, 1, @{$reflection_spawns{$reflection}});
		}
		quest::signalwith(2000212, 2);
	}
}

sub EVENT_DEATH_COMPLETE {
	plugin::HandleBossDeath();
	plugin::Emote("Okahn, lets loose a final howl as he collapses the the ground.");
}