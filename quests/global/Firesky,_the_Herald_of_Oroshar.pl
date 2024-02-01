sub EVENT_SPAWN {
	plugin::AddBossLoot();
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 70000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 8000);
	$npc->ModifyNPCStat("max_hit", 8500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Silence", quest::ChooseRandom(15..30));
	} elsif ($combat_state == 0) {
		quest::stoptimer("Silence");
	}
}

sub EVENT_TIMER {
	if ($timer eq "Silence") {
		quest::stoptimer("Silence");
		my $silence_ent = $npc->GetHateRandom();
		$npc->CastSpell(32442, $silence_ent->GetID(), -1, -1, 0, -100000);
		if ($silence_ent->IsClient()) {
			plugin::ClientMessage($silence_ent, "You begin to choke in a cloud of smog.");
		}
		quest::settimer("AoE", quest::ChooseRandom(15..30));
	} elsif ($timer eq "AoE") {
		quest::stoptimer("AoE");
		my $damage_ent = $npc->GetHateRandom();
		my $range = 100;
		if ($npc->CalculateDistance($damage_ent->GetX(), $damage_ent->GetY(), $damage_ent->GetZ()) <= $range) { #Within melee range
			my $aoe_hp = int($damage_ent->GetHP() / 4);
			$damage_ent->SetHP($damage_ent->GetHP() - $aoe_hp);
			if ($damage_ent->IsClient()) {
				plugin::ClientMessage($damage_ent, "Firesky, the Herald of Oroshar hits YOU for " . plugin::commify($aoe_hp) . " health as magma erupts all around him!");
			}
		} elsif ($npc->CalculateDistance($damage_ent->GetX(), $damage_ent->GetY(), $damage_ent->GetZ()) > $range) { #Out of melee range
			my $dd_hp = int($damage_ent->GetHP() / 3);
			$damage_ent->SetHP($damage_ent->GetHP() - $dd_hp);
			if ($damage_ent->IsClient()) {
				plugin::ClientMessage($damage_ent, "Firesky, the Herald of Oroshar hits YOU for " . plugin::commify($dd_hp) . " health as a massive meteor falls from the sky!");
			}
		}
		quest::settimer("Silence", quest::ChooseRandom(15..30));
	}	
}

sub EVENT_DEATH_COMPLETE {
	plugin::HandleBossDeath();
	my $chance = quest::ChooseRandom(1..100);
	if ($chance ~~ [1..45]) {
	plugin::ZoneAnnounce("The smoldering embers of Firesky, the Herald of Oroshar begin to burn once more!");
	plugin::Spawn2(2000204, 1, $x, $y, $z, $h);
	}
	elsif ($chance ~~ [46..100]) {
	plugin::ZoneAnnounce("Wisps of smoke are all the remain of Firesky, the Herald of Oroshar...");
	}
}
	
