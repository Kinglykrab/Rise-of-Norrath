sub EVENT_ITEM_CLICK {
	my $token_id = 200011;
	my $loot_check = plugin::Data($client, 3, "Loot-Clicky");
	my $loot_remaining = plugin::ConvertTimeRemaining(plugin::Data($client, 5, "Loot-Clicky"));
	if ($itemid == $token_id) {
		if(!$loot_check) {
			plugin::ClientMessage($client, "Enabling Double Loot for 30 minutes.");
			plugin::Data($client, 2, "Loot-Clicky", 2, "M30");
		} else {
			plugin::ClientMessage($client, "You must wait $loot_remaining after your last use to use a Loot Token again.");
		}
		quest::removeitem($token_id, 1);
	}
}