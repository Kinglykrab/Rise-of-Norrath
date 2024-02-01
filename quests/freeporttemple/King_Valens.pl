sub EVENT_SAY {
	my $crystal_id = plugin::GetCrystalType(2) eq "Ebon" ? 40902 : 40903;
	my $crystal_link = quest::varlink($crystal_id);
	if ($text=~/Hail/i) {
		my $need_link = quest::saylink("need", 1);
		plugin::Whisper(
			"Hail $name, I am the King of the Centaurs.
			I have been imbued with Divine Power and I am now capable of withdrawing the power from within someone to its 	fullest extent.
			In order to find enough $crystal_link to strengthen our army, you must venture in to the Plane of Tactics.
			If you return to me with what I need, you will become much more powerful.
			If you already have what I $need_link, I can exchange it for you."
		);
	} elsif ($text=~/Need/i) {
		my $craft_link = quest::saylink("craft", 1, "Craft");
		my $emblem_link = quest::varlink(plugin::ProgressionEmblems());
		plugin::Message("= | Rank One Requirements");
		plugin::Message("== | 500 $crystal_link, 25 $emblem_link, 25 AA Points, 1,000,000 Platinum");
		plugin::Message("=== | $craft_link");
	} elsif ($text=~/Craft/i) {
		my $cursor_slot = quest::getinventoryslotid("cursor");
		if($client->GetItemIDAt($cursor_slot) == -1) {
			plugin::BuySource();
		} else {
			plugin::Whisper("How can I craft your powersource when your hands are full?! Drop the item on your cursor!");
		}
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}