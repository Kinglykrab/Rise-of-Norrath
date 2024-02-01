sub EVENT_SIGNAL {
	if ($signal == 1) {
		quest::settimer("HealthCheck", 5);
	} elsif ($signal == 0) {
		quest::stoptimer("HealthCheck");
	}
}

sub EVENT_TIMER {
	if ($timer eq "HealthCheck") {
		quest::stoptimer("HealthCheck");
		my $Sister1 = $entity_list->GetNPCByNPCTypeID(2000177);
		my $Sister1HP = int($Sister1-> GetHPRatio());		

		my $Sister2 = $entity_list->GetNPCByNPCTypeID(2000178);
		my $Sister2HP = int($Sister2-> GetHPRatio());
		my $Sister2Min = ($Sister2HP - 15);
		my $Sister2Max = ($Sister2HP + 15);

		my $Sister3 = $entity_list->GetNPCByNPCTypeID(2000179);
		my $Sister3HP = int($Sister3-> GetHPRatio());
		my $Sister3Min = ($Sister3HP - 15);
		my $Sister3Max = ($Sister3HP + 15);
		if ($Sister1HP < $Sister2Min || $Sister1HP > $Sister2Max || $Sister1HP < $Sister3Min || $Sister1HP > $Sister3Max) {
			plugin::Emote("Initiating Sisters Protection protocol.");
			quest::depop_withtimer($_) for (2000177..2000180);
			plugin::Spawn2(2000181, 1, $x, $y, $z, $h);
		} else {
			quest::settimer("HealthCheck", 5);
		}
	}
}
