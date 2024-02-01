sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 15625000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 4500);
	$npc->ModifyNPCStat("max_hit", 5000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Bite", quest::ChooseRandom(15..30));
	} elsif ($combat_state == 0) {
		quest::depopall(2000211);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Bite") {
		quest::stoptimer("Bite");	
		my @hatelist = $npc->GetHateList();
		my @Bite_array = ();
		foreach my $hate_ent (@hatelist) {
			my $Bite_ent = $hate_ent->GetEnt()->CastToMob();
			my $Bite_hp = int($Bite_ent->GetHP() / 5);
			$Bite_ent->SetHP($Bite_ent->GetHP() - $Bite_hp);
			$npc->SetHP($npc->GetHP() + $Bite_hp);
			if ($Bite_ent->IsClient()) {
				plugin::ClientMessage($Bite_ent, "a Savage Reflection lets loose a savage howl and bites YOU for " . plugin::commify($Bite_hp) . " points of damage!");
			}
			push @Bite_array, $Bite_ent->GetCleanName();
		}
		plugin::ZoneAnnounce("a Savage Reflection opens it's massive jaws and bites " . join(", ", @Bite_array) . ".");
		quest::settimer("Bite", quest::ChooseRandom(15..30));
	}
}
