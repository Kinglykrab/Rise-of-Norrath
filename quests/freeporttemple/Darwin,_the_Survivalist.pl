sub EVENT_SAY {
	my $progression_flag = plugin::Data($client, 3, "Progression");
	my $prestige_flag = plugin::Data($client, 3, "Prestige");
	if ($ulevel == 70 && ($progression_flag == 20 || $prestige_flag > 0 || $status >= 80)) {
		if ($text=~/Hail/i) {
			my $craft_link = quest::saylink("craft", 1);
			plugin::Whisper("Hail $name, I am the Survivalist, I can $craft_link Prestige items.");
		} elsif ($text=~/Craft/i) {			
			plugin::Message("= | Prestige Item Recipes");
			foreach my $rank (1..9) {
				my $rank_link = quest::saylink("rank $rank", 1, "View Prestige Item +$rank Recipes");
				if ($progression_flag >= $rank || $rank == 1 || $status == 255) {
					plugin::Message("== | $rank. $rank_link");
				}
			}
		} elsif ($text=~/Rank/i) {
			my $rank = substr($text, 5);
			plugin::Whisper("I see you're interested in recipes.");
			plugin::ListPrestigeItems($rank);
		} elsif ($text=~/^Recipe/i) {
			my $recipe = substr($text, 7);
			plugin::Whisper(
				"So you've finally found an item you want to craft?
				First, make sure you have what I need."
			); 
			plugin::ListPrestigeRecipe($recipe);
		} elsif ($text=~/Upgrade/i) {
			my $recipe = substr($text, 8);
			plugin::UpgradePrestigeItem($recipe);
		}
	} elsif ($ulevel < 70) {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	} elsif ($progression_flag < 20) {
		plugin::Whisper("In order to Prestige, you must first complete the Tier Progression.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}