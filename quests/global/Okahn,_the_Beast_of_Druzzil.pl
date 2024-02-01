sub EVENT_SPAWN {
	plugin::AddBossLoot();
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
	quest::setnexthpevent(50);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Bite", quest::ChooseRandom(15..30));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Bite");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Bite") {
		quest::stoptimer("Bite");
		my @hatelist = $npc->GetHateList();
		my @Bite_array = ();
		foreach my $hate_ent (@hatelist) {
			my $Bite_ent = $hate_ent->GetEnt()->CastToMob();
			my $Bite_hp = int($Bite_ent->GetHP() / 2.5);
			$Bite_ent->SetHP($Bite_ent->GetHP() - $Bite_hp);
			if ($Bite_ent->IsClient()) {
				plugin::ClientMessage($Bite_ent, "Okahn lets loose a savage howl and bites YOU for " . plugin::commify($Bite_hp) . " points of damage!");
			}
			push @Bite_array, $Bite_ent->GetCleanName();
		}
		plugin::ZoneAnnounce("Okahn opens his massive jaws and bites " . join(", ", @Bite_array) . ".");
		quest::settimer("Bite", quest::ChooseRandom(15..30));
	}
}

sub EVENT_HP {
	my %reflection_spawns = (0 => [1168.41, 1289.55, 194.66, 297.8],
	1 => [1184.08, 1273.70, 194.65, 325.0]);
	if ($hpevent == 50) {
		plugin::ZoneAnnounce("Okahn peers into a pool of blood and releases reflections of his inner rage!");
		foreach my $reflection (sort {$a <=> $b} keys %reflection_spawns) {
			plugin::Spawn2(2000211, 1, @{$reflection_spawns{$reflection}});
		}
		quest::signalwith(2000212, 2);
	}
}


sub EVENT_DEATH_COMPLETE {
	plugin::HandleBossDeath();
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..45]) {
		plugin::Emote("The strength of the wolf is the pack, I cannot be defeated!");
		plugin::Spawn2(2000192, 1, $x, $y, $z, $h);
	} elsif ($chance ~~ [46..100]) {
		plugin::ZoneAnnounce("Okahn, the Beast of Druzzil lets loose a final howl as he collapses the the ground.");
	}
}