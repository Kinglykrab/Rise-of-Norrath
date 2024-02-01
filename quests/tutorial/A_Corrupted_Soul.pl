sub EVENT_SAY {
	my @zones = (
		"poair",
		"poinnovation",
		"pojustice",
		"ponightmare",
		"potorment",
		"growthplane",
	);
	my $index = 1;
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $zones_link = quest::saylink("zones", 1);
			plugin::Whisper(
				"Hail $name, You must fight in the following realms in order to forge a Corrupted Weapon.
				In order to fight in these $zones_link you must have completed your Epic 2.0 and be flagged for Tier 10!"
			);
		} elsif ($text=~/Zones/i) {
			plugin::Message("= | Corrupted Weapon Zones List");
			foreach my $zone (@zones) {
				my $zone_long_name = plugin::Zone("LN", $zone);
				my $zone_link =quest::saylink("#peqzone $zone", 0, $zone_long_name);
				plugin::Message("== | $index. $zone_link");
				$index++;
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}