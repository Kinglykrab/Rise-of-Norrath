sub EVENT_SPAWN {
	quest::settimer("Check", 1);
}

sub EVENT_SIGNAL {
	if ($signal ~~ [1..4]) {
		$npc->SetEntityVariable("Signal_$signal", 1);
	}
}

sub EVENT_TIMER {
	if ($timer eq "Check") {
		quest::stoptimer("Check");
		my $count = 0;
		for my $signal (1..4) {
			if ($npc->EntityVariableExists("Signal_$signal") && $npc->GetEntityVariable("Signal_$signal") == 1) {
				$count++;
			}
		}
		if ($count == 4) {
			$npc->SetEntityVariable("Signal_" . $_, 0) for (1..4);
			plugin::Spawn2(2000184, 1, -1.12, 3543.67, 104.5, 251.5);
			plugin::ZoneAnnounce("Mayong Mistmoore senses his minions death and appears in the tower.");
		} else {
			quest::settimer("Check", 1);
		}
	}
}