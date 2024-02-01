sub EVENT_SPAWN {
	plugin::AddBossLoot();
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 85000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 7000);
	$npc->ModifyNPCStat("max_hit", 8000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	$npc->ModifyNPCStat("spellscale", 5000);
	$npc->CastSpell(20161, $npc->GetID());
	quest::setnexthpevent(80);
}

sub EVENT_COMBAT {
	if ($combat_state == 1) {
		quest::settimer("Quake", quest::ChooseRandom(15..30));
	}
}
	

sub EVENT_HP {
	if ($hpevent ~~ [20, 40, 60, 80]) {
		my $next_event1 = ($hpevent - 10);
		plugin::SpawnFormation(2000234, 4, 20);
		quest::setnexthpevent($next_event1);
		$npc->CastSpell(4688, $npc->GetID());
		$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1^35,1");
		quest::settimer("Runes", 1);
	} elsif ($hpevent ~~ [10, 30, 50, 70]) {
		my $next_event2 = ($hpevent - 10);
		$npc->BuffFadeAll();
		quest::setnexthpevent($next_event2);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Runes") {
		quest::stoptimer("Runes");
		if (!plugin::Spawned(2000234)) {
			$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
		} else {
			quest::settimer("Runes", 1);
		}
	} elsif ($timer eq "Quake") {
		quest::stoptimer("Quake");	
		my $quake_ent = $npc->GetHateRandom();
		$npc->CastSpell(8154, $quake_ent->GetID(), 22, -1, -1, 10000);
		quest::settimer("Quake", quest::ChooseRandom(15..30));
	}
}


sub EVENT_DEATH_COMPLETE {
	plugin::HandleBossDeath();
	plugin::Emote("Re-organization impossible, initiating terminal procedures.");
}