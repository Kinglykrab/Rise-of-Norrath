sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $need_link = quest::saylink("need", 1);
			my $produce_link = quest::saylink("produce", 1);
			plugin::Whisper(
				"Hail $name, I am the Master of the Trees.
				I control all the plant life in Norrath, but these Ferubian pests have been deforesting land.
				Eliminate them for me and gather what I need and I will produce you a fruit of great power.
				If you already have what I $need_link, I can $produce_link the fruit for you now."
			);
		} elsif ($text=~/Need/i) {
			plugin::FruitRanks();
		} elsif ($text=~/Produce/i) {
			my $cursor_slot = quest::getinventoryslotid("cursor");
			if($client->GetItemIDAt($cursor_slot) == -1) {	#Splose: Check item @ cursor
				plugin::ProduceFruit();
			} else {
				plugin::Whisper("How are you supposed to take this fruit when your hands are full?! Drop the item on your cursor!");
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}