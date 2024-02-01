sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 150000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 25500);
	$npc->ModifyNPCStat("max_hit", 28500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 22);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	quest::setnexthpevent(90);
	$npc->ModifyNPCStat("spellscale", 16000);
}

sub EVENT_HP {
	if ($hpevent ~~ [10, 20, 30, 40, 50, 60, 70, 80, 90]) {
		$npc->ModifyNPCStat("runspeed", 0);
		$npc->ModifyNPCStat("walkspeed", 0);
		my $next_event = ($hpevent - 10);
		quest::setnexthpevent($next_event);
		my $shadowstep_ent = $npc->GetHateRandom();
		$npc->GMMove($shadowstep_ent->GetX(), $shadowstep_ent->GetY(), $shadowstep_ent->GetZ(), 0);
		quest::settimer("Cleave", 5);
		quest::settimer("Move", 7);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Cleave") {
		quest::stoptimer("Cleave");
		my @hatelist = $npc->GetHateList();
		foreach $ent (@hatelist) {
			my $hate_ent = $ent->GetEnt();
			my $range = 50;
			if ($npc->CalculateDistance($hate_ent->GetX(), $hate_ent->GetY(), $hate_ent->GetZ()) <= $range) {
				my $cleave_hp = quest::ChooseRandom(50000..150000);
				$hate_ent->SetHP($hate_ent->GetHP() - $cleave_hp);
				if ($hate_ent->IsClient()) {
					plugin::ClientMessage($hate_ent, "Mephistopheles the Archfiend hits YOU for " . plugin::commify($cleave_hp) . " health with his massive scythe!");
				}
			}
		}
	}
	elsif ($timer eq "Move") {
		quest::stoptimer("Move");
		$npc->ModifyNPCStat("runspeed", 1.25);
		$npc->ModifyNPCStat("walkspeed", 0.45);
	}
}


