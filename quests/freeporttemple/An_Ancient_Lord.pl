sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $enter_link = quest::saylink("enter", 1);
			plugin::Whisper("Hail $name, would you you like to $enter_link the Void and fight the Ancient Prophet?");
		} elsif ($text=~/Enter/i) {
			plugin::Whisper("I wish you luck $name.");
			quest::zone("load2");
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}