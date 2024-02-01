sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $forge_link = quest::saylink("forge", 1);
			plugin::Whisper("Hail $name, I am the Forgemaster. I can $forge_link many powerful armor pieces for you.");
		} elsif ($text=~/Forge/i) {
			my $progression_flag = plugin::Data($client, 3, "Progression");
			plugin::Message("= | Tier Armor Recipes");
			foreach my $tier (1..20) {
				my $tier_string = plugin::Tier($tier);
				my $tier_link = quest::saylink("tier $tier", 1, "Tier $tier_string");
				if ($progression_flag >= $tier || $tier == 1 || $status == 255) {
					plugin::Message("== | $tier. $tier_link");
				}
			}
		} elsif ($text=~/^Tier/i) {
			my $tier = substr($text, 5);
			plugin::Whisper("I see you're interested in recipes.");
			plugin::ListTierItems($tier);
		} elsif ($text=~/^Recipe/i) {
			my $recipe = substr($text, 7);
			plugin::Whisper(
				"So you've finally found an item you want to craft?
				First, make sure you have what I need."
			);
			plugin::ListTierRecipe($recipe);
		} elsif ($text=~/Upgrade/i) {
			my $cursor_slot = quest::getinventoryslotid("cursor");
			if($client->GetItemIDAt($cursor_slot) == -1) {	#Splose: Check item @ cursor
				my $recipe = substr($text, 8);
				plugin::UpgradeItem($recipe);
			} else {
				plugin::Whisper("How can I craft your augment when your hands are full?! Drop the item on your cursor!");
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}