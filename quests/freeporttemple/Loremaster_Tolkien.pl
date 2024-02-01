sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $forge_link = quest::saylink("forge", 1);
			plugin::Whisper("Hail $name, I am the Loremaster. I can $forge_link mighty Epic weapons for you.");
		} elsif ($text=~/Forge/i) {		
			plugin::Message("= | Epic Recipes");
			foreach my $epic_rank ("Epic 1.5", "Epic 2.0") {
				my $rank_link = quest::saylink($epic_rank, 1, "View $epic_rank Recipe");
				plugin::Message("== | $epic_rank. $rank_link");
			}
		} elsif ($text=~/^Epic/i) {
			my $epic_rank = $text;
			plugin::Whisper("I see you're interested in recipes.");
			plugin::ListEpicItems($epic_rank);
		} elsif ($text=~/^Recipe/i) {
			my $recipe = substr($text, 7);
			plugin::Whisper(
				"So you've finally found an item you want to craft?
				First, make sure you have what I need."
			);
			plugin::ListEpicRecipe($recipe);
		} elsif ($text=~/^Craft/i) {
			my $cursor_slot = quest::getinventoryslotid("cursor");
			if($client->GetItemIDAt($cursor_slot) == -1) {	#Splose: Check item @ cursor
				my $recipe = substr($text, 6);
				plugin::UpgradeEpic($recipe);
			} else {
				plugin::Whisper("How can I craft your armor when your hands are full?! Drop the item on your cursor!");
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}