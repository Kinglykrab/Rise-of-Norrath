sub EVENT_SAY {
	if ($ulevel == 70) {
		my $crystal_type = plugin::GetCrystalType(2);
		my $crystal_id = $crystal_type eq "Ebon" ? 40902 : 40903;
		my $crystal_link = quest::varlink($crystal_id);
		my $convert_id = $crystal_type eq "Ebon" ? 40903 : 40902;
		my $convert_link = quest::varlink($convert_id);
		my $transmogrify_link = quest::saylink("transmogrify", 1);
		if ($text=~/Hail/i) {
			plugin::Whisper(
				"Hail $name, I am the most powerful Enchanter known to the Centaurs.
				I can transmogrify 5 $convert_link into 1 $crystal_link. 
				Would you like to $transmogrify_link what you have now for $crystal_link?"
			);
		} elsif ($text=~/Transmogrify/i) {
			plugin::ConvertCrystals();
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}