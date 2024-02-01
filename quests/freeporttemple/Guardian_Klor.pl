sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my $bound_link = quest::saylink("bound", 1);
		plugin::Whisper("Would you like to be $bound_link here?");
	} elsif ($text=~/Bound/i) {
		quest::rebind(386, 0.29, -80.85, 36.38);
		plugin::Whisper("You have been bound here.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}