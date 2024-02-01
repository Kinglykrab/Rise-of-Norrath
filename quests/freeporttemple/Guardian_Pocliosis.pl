sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my %zones = (
			1 => "tutorialb",
			2 => "innothule",
			3 => "kurn",
			4 => "blackburrow",
			5 => "netherbian",
			6 => "warrens",
			7 => "mistmoore",
			8 => "gukbottom",
			9 => "karnor",
			10 => "kael",
			11 => "veksar",
			12 => "droga",
			13 => "sleeper",
		);
		plugin::Whisper("The following zones drop Defiant Armor, Weapons, and Accessories and are recommended for new players.");
		plugin::Message("= | Leveling Zones List");
		foreach my $zone (sort {$a <=> $b} keys %zones) {
			my $zone_short_name = $zones{$zone};
			my $zone_long_name = plugin::Zone("LN", $zone_short_name);
			my $zone_link = quest::saylink("#peqzone $zone_short_name", 0, $zone_long_name);
			plugin::Message("== | $zone. $zone_link");
		}
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}