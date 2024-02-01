sub EVENT_SAY {
	my %zones = (
		1 => "templeveeshan",
		2 => "akheva",
		3 => "bothunder",
		4 => "crushbone",
		5 => "frostcrypt",
		6 => "postorms",
		7 => "discord",
		8 => "anguish",
		9 => "codecay",
		10 => "crystallos",
		11 => "ashengate",
		12 => "atiiki",
		13 => "beholder",
		14 => "deadbone",
		15 => "mechanotus",
		16 => "redfeather",
		17 => "roost",
		18 => "shiningcity",
		19 => "mseru",
		20 => "sseru",
	);
	my $progression_flag = plugin::Data($client, 3, "Progression");
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			plugin::Whisper("The following zones are Tiers you have access to.");
			plugin::Message("= | Progression Zones List");
			foreach my $zone (sort {$a <=> $b} keys %zones) {
				my $zone_short_name = $zones{$zone};
				my $zone_long_name = plugin::Zone("LN", $zone_short_name);
				my $zone_link = quest::saylink("#peqzone $zones{$zone}", 0, $zone_long_name);
				if ($progression_flag >= $zone) {
					plugin::Message("== | $zone. $zone_link");
				}
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	my $progression_flag = plugin::Data($client, 3, "Progression");
	if ($item1 ~~ [200..219]) {
		my $item_tier = ($item1 - 200);
		my $item_tier_string = plugin::Tier($item_tier);
		my $after_tier = ($item_tier + 1);
		my $after_tier_string = plugin::Tier($after_tier);
		if (
			$item_tier == 0 ||
			(
				$progression_flag == $item_tier && 
				$item_tier < 4
			) ||
			(
				$progression_flag == $item_tier &&
				$item_tier >= 4 && 
				plugin::GearCheck($item_tier)
			)
		) {
			$itemcount{$item1} = 0;
			plugin::SetProgressionFlag($client, $after_tier);
			plugin::LogProgression($item1, $progression_flag, $after_tier);
			plugin::Whisper("You are now flagged for Tier $after_tier_string!");
			if ($client->Admin() != 255) {
				plugin::ServerAnnounce("$name has ascended to Tier $after_tier_string!");
			}
		} elsif (
			$progression_flag == $item_tier &&
			$item_tier >= 4 && 
			!plugin::GearCheck($item_tier)
		) {
			plugin::Whisper(
				"You must have a full set of Tier $item_tier gear to key for Tier $after_tier_string!"
			);
		} else {
			plugin::Whisper("You do not meet the requirements for Tier $after_tier_string!");
		}
	}
	plugin::return_items();
}	