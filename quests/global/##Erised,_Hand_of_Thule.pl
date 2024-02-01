sub EVENT_SPAWN {
##	#$npc->SetLevel(quest::ChooseRandom(90..93));
	$npc->AddCash(0, 0, 0, quest::ChooseRandom(25000..45000));
	quest::settimerMS("HP",1);
	#$npc->ModifyNPCStat("max_hp", 1500000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->SetSpecialAbility($_, 1) for (quest::ChooseRandom(12..17), 21);
	$npc->ModifyNPCStat($_, 2500) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 65) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 5000);
	$npc->ModifyNPCStat("max_hit", 12500);
	$npc->ModifyNPCStat("avoidance", 85);
	$npc->ModifyNPCStat("accuracy", 100);
	$npc->ModifyNPCStat($_, 50000) for ("ac", "atk");
	if (plugin::SpawnCount(998000..998032, 998035) == 0) {
		$npc->SetSpecialAbility($_, 1) for (24, 35);
		quest::settimer("Invul", 5);
	}
	
	$npc->AddItem(168002);
	if (quest::ChooseRandom(1..100) > 90) {
		$npc->AddItem(168002);
		if (quest::ChooseRandom(1..100) > 90) {
			$npc->AddItem(168002);
			if (quest::ChooseRandom(1..100) > 90) {
				$npc->AddItem(168002);
			}
		}
	}
	quest::setnexthpevent(90);
}



sub EVENT_COMBAT {
	if($combat_state == 0) {
		quest::depopall(2000127);
		$npc->SetHP($npc->GetMaxHP());
		quest::setnexthpevent(90);
		quest::worldwidemessage(15, "" . $npc->GetCleanName() . " just wrecked some noobs. Resetting.",100);
	}
}

sub EVENT_HP {
	if ($hpevent ~~ [1..100]) {
		my $roll = quest::ChooseRandom(0, 1, 2);
		my $next_hp = quest::ChooseRandom(($hpevent - quest::ChooseRandom(6..10))..($hpevent - quest::ChooseRandom(1..5)));
		plugin::ZoneAnnounce("Erised, Hand of Thule bellows, '" . quest::ChooseRandom("You dare challenge me? I am Erised, the creation of the mighty Thule Himself.", "You are not worth of time, feel the wrath of Thule.", "You have merely scratched the surface of power, allow me to demonstrate full power.", "Don't think I'm going down easily, the Gods have reigned for millenia. A puny mortal such as yourself is nothing in comparison.") . "'");
		if ($roll == 0) {
			$npc->SetSpecialAbility($_, 1) for (5..7);
			quest::settimer("Debuff", 30);
		} elsif ($roll == 1) {	
			$npc->SetSpecialAbility($_, 1) for (3..7, 25);
			quest::settimer("Debuff", 10);
		} elsif ($roll == 2) {
			plugin::ZoneAnnounce("Erised, Hand of Thule splits into four and attacks from all sides.");
			plugin::Spawn2(2000127, 3, $x, $y, $z, $h);
			$npc->SetSpecialAbility($_, 1) for (24, 35);
			quest::settimer("Adds", 10);
		}
		quest::setnexthpevent($next_hp);
	}
}

sub EVENT_TIMER {
	if($timer eq "HP") {
		quest::stoptimer("HP");
		$npc->ModifyNPCStat("max_hp", 6500000);
		$npc->SetHP($npc->GetMaxHP());
	}
	if ($timer eq "Debuff") {
		quest::stoptimer("Debuff");
		$npc->SetSpecialAbility($_, 0) for (3..7, 24, 25, 35);
	} elsif ($timer eq "Invul") {
		quest::stoptimer("Invul");
		if (plugin::SpawnCount(998000..998032, 998035) == 0) {
			$npc->SetSpecialAbility($_, 0) for (3..7, 24, 25, 35);
		} else {
			quest::settimer("Invul", 5);
		}
	} elsif ($timer eq "Adds") {
		quest::stoptimer("Adds");
		if (plugin::SpawnCount(2000127) == 0) {
			$npc->SetSpecialAbility($_, 0) for (3..7, 24, 25, 35);			
		} else {
			quest::settimer("Adds", 10);
		}
	}
}