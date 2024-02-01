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
	$npc->CastSpell(11597, $npc->GetID());
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
	plugin::HandleBossDeath();
}
