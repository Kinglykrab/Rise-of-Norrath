sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $emblem_link = quest::varlink(plugin::ProgressionEmblems());
			my $exchange_link = quest::saylink("exchange", 1);
			plugin::Whisper("Hail $name, I am the Grandmaster of Alchemy. 
			You may exchange 10 of any Class Shard for 1 $emblem_link.
			Would you like to $exchange_link what you have now for $emblem_link?");
		} elsif ($text=~/Exchange/i) {
			plugin::ExchangeShard();
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}