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
		$npc->ModifyNPCStat("runspeed", 0);
		$npc->ModifyNPCStat("walkspeed", 0);
		plugin::Emote("My corruption will spread to every inch of this plane!");
		plugin::ZoneAnnounce("Xanzerok, the Earth Root begins to sow corruption through his roots...");
		quest::settimer("Root", 20);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Root") {
		my @hatelist = $npc->GetHateList();
		quest::stoptimer("Root");
		foreach my $hate_ent (@hatelist) {
			if ($hate_ent->GetEnt()->IsClient()) {
				my $root_ent = $hate_ent->GetEnt()->CastToClient();
				$root_ent->CastSpell(5722, $root_ent->GetID());
				plugin::ClientMessage($root_ent, "You have been rooted.");
			}
			quest::settimer("Root", 20);
		}
	}
}

sub EVENT_DEATH_COMPLETE {
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..45]) {
		plugin::Emote("Xanzerok, the Earth Root, siphons the planes life force to emerge once again, more powerful!");
		plugin::Spawn2(2000200, 1, $x, $y, $z, $h);
	} elsif ($chance ~~ [46..100]) {
		plugin::Emote("Xanzerok, the Earth Root attempts to siphon energy from the ground around him but the space is barren from the recent conflict.");
	}
}








