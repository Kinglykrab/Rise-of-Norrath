sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $smelt_link = quest::saylink("smelt", 1);
			plugin::Whisper("Hail $name, I am the Son of Zeus.
			With my Godly power I can $smelt_link mighty weapons unlike any other.");
		} elsif ($text=~/Smelt/i) {
			plugin::Message("= | Corrupted Weapon Recipes");
			foreach my $rank (1..10) {
				my $real_rank = plugin::Tier($rank);
				my $rank_link = quest::saylink("rank $rank", 1, "View Rank $real_rank Recipes");
				plugin::Message("== | $rank. $rank_link");
			}
		} elsif ($text=~/^Rank/i) {
			my $rank = substr($text, 5);
			plugin::Whisper("I see you're interested in recipes.");
			plugin::ListWeaponItems($rank);
		} elsif ($text=~/^Recipe/i) {
			my $recipe = substr($text, 7);
			plugin::Whisper(
				"So you've finally found an item you want to craft?
				First, make sure you have what I need."
			);
			plugin::ListWeaponRecipe($recipe);
		} elsif ($text=~/Craft/i) {
			my $cursor_slot = quest::getinventoryslotid("cursor");
			if($client->GetItemIDAt($cursor_slot) == -1) {
				my $recipe = substr($text, 6);
				plugin::UpgradeWeapon($recipe);
			} else {
				plugin::Whisper("How can I craft your weapon when your hands are full?! Drop the item on your cursor!");
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}