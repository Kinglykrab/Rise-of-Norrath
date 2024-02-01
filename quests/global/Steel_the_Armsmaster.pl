sub EVENT_SAY {
	if ($text=~/Hail/i) {
		plugin::Whisper("Hail $name, would you like to purchase?");
		plugin::Message("= | " . quest::saylink($_, 1)) for ("Epic 1.5","Epic 2.0","Epic 3.0");	
	} elsif ($text eq "Epic 1.5") {
		plugin::ViewDonatorMerchant("Epic 1.5");
		$merchanttype = "Epic 1.5";
	} elsif ($text eq "Epic 2.0") {
		plugin::ViewDonatorMerchant("Epic 2.0");
		$merchanttype = "Epic 2.0";
	} elsif ($text eq "Epic 3.0") {
		plugin::ViewDonatorMerchant("Epic 3.0");
		$merchanttype = "Epic 3.0";
	} elsif ($text=~/^Buy/i) {
		my $cursor_slot = quest::getinventoryslotid("cursor");
		if($client->GetItemIDAt($cursor_slot) == -1) {
			my (
				$merchant_type,
				$item_id,
			) = ($merchanttype,
				split(/ /, substr($text, 13)));
			#split(/ /, substr($text, 4));
			
			#quest::say("$merchant_type : $item_id");
			plugin::BuyDonatorItem($merchant_type, $item_id);
		} else {
			plugin::Whisper("You can't buy anything from me with your hands full! Drop the item on your cursor and try again.");
		}
	}
}