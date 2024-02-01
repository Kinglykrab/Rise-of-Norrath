sub EVENT_SPAWN {
	plugin::AddBossLoot();
	$npc->SetLevel(80);
	$npc->ModifyNPCStat("max_hp", 65000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 5500);
	$npc->ModifyNPCStat("max_hit", 6500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "1,1,2,20000,100^3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->ModifyNPCStat("texture", 2);
	$npc->ModifyNPCStat("spellscale", 50000);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		$npc->ModifyNPCStat("runspeed", 0);
		$npc->ModifyNPCStat("walkspeed", 0);
		plugin::Emote("My corruption will spread to every inch of this plane!");
		plugin::ZoneAnnounce("Xanzerok, the Lifekeeper begins to sow corruption through his roots...");
		quest::settimer("Root", 20);
		quest::settimer("DoT", 60);
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
	elsif ($timer eq "DoT") {
		my @hatelist = $npc->GetHateList();
		quest::stoptimer("DoT");
		foreach my $hate_ent (@hatelist) {
			if ($hate_ent->GetEnt()->IsClient()) {
				my $root_ent = $hate_ent->GetEnt()->CastToClient();
				if ($root_ent->GetMana() > 0) {
					my $root_mp = int($root_ent->GetMana() / 3);
					$root_ent->SetMana($root_ent->GetMana() - $root_mp);
					plugin::ClientMessage($root_ent, "Xanzerok has drained " . plugin::commify($root_mp) . " mana from you!");
				}
				$root_ent->CastSpell(5722, $root_ent->GetID());
				plugin::ClientMessage($root_ent, "Xanzerok, calls a swarm of ants to attack you!");
			}
		}
		quest::settimer("DoT", 60);
	}	
}

sub EVENT_DEATH_COMPLETE {
	plugin::HandleBossDeath();
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..45]) {
		plugin::Emote("Xanzerok, the Earth Root's seedlings burst from the ground and are carried by the wind to unknown locations.");
		plugin::Spawn2(2000244, 1, $x, $y, $z, $h);
	} elsif ($chance ~~ [46..100]) {
		plugin::Emote("Xanzerok, the Lifekeeper attempts to siphon energy from the ground around him, but the space is barren from the recent conflict.");
	}
}