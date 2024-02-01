sub EVENT_SPAWN {
	if ($instanceid == 0) {
		plugin::ServerAnnounce("The Great Wisp has spawned.");
	}
	for (my $i = 0; $i < quest::ChooseRandom(1..3); $i++) {
		if (quest::ChooseRandom(1..100) > 50) {
			$npc->AddItem(168000, 1);
		}
	}
	quest::setnexthpevent(90);
}

sub EVENT_HP {
	if ($hpevent ~~ [10, 20, 30, 40, 50, 60, 70, 80, 90]) {
		quest::settimer("Spawn_Check", 1);
		my $max_mobs = 2;
		if ($hpevent ~~ [70, 80]) {
			$max_mobs = 3;
		} elsif ($hpevent ~~ [40, 50, 60]) {
			$max_mobs = 4;
		} elsif ($hpevent ~~ [10, 20, 30]) {
			$max_mobs = 5;
		}
		plugin::ZoneAnnounce("A swarm of $max_mobs Lesser Wisps has spawned! You must kill them before The Great Wisp can die!");
		plugin::Spawn2(2000109, $max_mobs, $x, $y, $z, $h);
		quest::setnexthpevent($hpevent - 10);
		quest::setnextinchpevent($hpevent + 10);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Spawn_Check") {
		quest::stoptimer($timer);
		$npc->SetSpecialAbility(35, plugin::Spawned(2000109));
		quest::settimer("Spawn_Check", 1);
	}
}

sub EVENT_COMBAT {
	if ($combat_state == 0) {
		quest::depopall(2000109);
		$npc->SetSpecialAbility(35, 0);
		quest::setnexthpevent(90);
	}
}

sub EVENT_DEATH_COMPLETE {
	quest::depopall(2000109);
}