sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my $peq_link = quest::saylink("#peqzone", 0);
		my $find_link = quest::saylink("#findzone", 0);
		my $commands_link = quest::saylink("#commands", 0);
		plugin::Whisper("Welcome, $name, to the Rise of Norrath!
		We are a custom-legit progression server that offers unlimited boxing.
		If you look around you can find starting armor and various NPCs to help you with either leveling or progressing through the tiers.
		Players have access to $peq_link and $find_link as well as a custom command list you can find using $commands_link.
		Server files are located on the server Discord.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}