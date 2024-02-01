sub EVENT_SAY {
	if ($text=~/Hail/i) {
		plugin::Whisper("Hail $name, would you like to purchase?");
		plugin::Message("= | " . quest::saylink($_, 1)) for ("Charm","Major");
	} elsif ($text eq "Charm") {
		plugin::ViewDonatorMerchant("Charm");
		$merchanttype = "Charm";
	} elsif ($text eq "Major") {
		plugin::ViewDonatorMerchant("Major");
		$merchanttype = "Major";
	} elsif ($text=~/^Buy/i) {
		my $cursor_slot = quest::getinventoryslotid("cursor");
		if($client->GetItemIDAt($cursor_slot) == -1) {
			my (
				$merchant_type,
				$item_id,
			) = ($merchanttype,
				split(/ /, substr($text, 10)));
			plugin::BuyDonatorItem($merchant_type, $item_id);
		} else {
			plugin::Whisper("You can't buy anything from me with your hands full! Drop the item on your cursor and try again.");
		}
	}
}