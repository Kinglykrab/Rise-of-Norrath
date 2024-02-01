sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my $wares_link = quest::saylink("wares", 1);
		plugin::Whisper("Hail $name, would you like me to list my $wares_link?");
	} elsif ($text=~/Wares/i) {
		plugin::ViewDonatorMerchant("Misc");
	} elsif ($text=~/^Buy/i) {
		if($client->GetItemIDAt(33) == -1) {
			my (
				$merchant_type,
				$item_id,
			) = split(/ /, substr($text, 4));
			plugin::BuyDonatorItem($merchant_type, $item_id);
		} else {
			plugin::Whisper("You can't buy anything from me with your hands full! Drop the item on your cursor and try again.");
		}
	}
}