sub EVENT_SPAWN {
	plugin::AddBossLoot();
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 70000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 7000);
	$npc->ModifyNPCStat("max_hit", 8000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 15);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->ModifyNPCStat("spellscale", 2000);
	$npc->CastSpell(20162, $npc->GetID());
	quest::setnexthpevent(90);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Lightning", quest::ChooseRandom(10..20));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Lightning");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Lightning") {
		quest::stoptimer("Lightning");
		my $Lightning_ent = $npc->GetHateRandom();
		$npc->CastSpell(26709 , $Lightning_ent->GetID(), -1, -1, 0, 100000);
		if ($Lightning_ent->IsClient()) {
			plugin::ClientMessage($Lightning_ent, "Cataclysm, the Terror of the Sky calls down a bolt of lightning, stunning you!");
		}
		quest::settimer("Lightning", quest::ChooseRandom(10..20));
	}
}

sub EVENT_HP {
	if ($hpevent ~~ [10, 20, 30, 40, 50, 60, 70, 80, 90]) {
		if ($hpevent == 50) {
			$npc->ModifyNPCStat("min_hit", 8000);
			$npc->ModifyNPCStat("max_hit", 9000);
			$npc->ModifyNPCStat("spellscale", 2500);
			plugin::ZoneAnnounce("The wind picks up violently as Cataclysm, the Terror of the Sky becomes super charged!");
		}
		my $next_event = ($hpevent - 10);
		quest::setnexthpevent($next_event);
		my @hatelist = $npc->GetHateList();
		foreach my $hate_ent (@hatelist) {
			my $boulder_ent = $hate_ent->GetEnt()->CastToMob();
			my $boulder_hp = int($boulder_ent->GetHP() / 2);
			$boulder_ent->SetHP($boulder_ent->GetHP() - $boulder_hp);
			$npc->SetHP($npc->GetHP() + $boulder_hp);
			if ($boulder_ent->IsClient()) {
				plugin::ClientMessage($boulder_ent, "Cataclysm, the Terror of the Sky expels a boulder from within her maelstrom and hits YOU for " . plugin::commify($boulder_hp) . " points of damage.");
			}
		}
	}
}

sub EVENT_DEATH_COMPLETE {
	plugin::HandleBossDeath();
	plugin::ZoneAnnounce("With a flicker of static the maelstrom becomes inanimate.");
}