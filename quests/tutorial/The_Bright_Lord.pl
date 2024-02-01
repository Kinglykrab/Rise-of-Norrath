sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $enter_link = quest::saylink("enter", 1);
			plugin::Whisper("Hail $name, would you like to $enter_link the Theater and vanquish the Bard?");
		} elsif ($text=~/Enter/i) {
			plugin::Whisper("I wish you luck $name.");
			quest::zone("freeporttheater");
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}