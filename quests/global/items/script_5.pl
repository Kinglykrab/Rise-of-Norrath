sub EVENT_ITEM_CLICK {
	my @npc_list = $entity_list->GetNPCList();
	my $npc_count = 0;
	my $bucket_name = "Repop-Clicky";
	my $donator_check = plugin::GetCurrency($client, 11);
	my $clicky_check = plugin::Data($client, 3, $bucket_name);
	my $time_remaining = plugin::Data($client, 5, $bucket_name);
	my $time_string = plugin::ConvertTimeRemaining($time_remaining);
	if ($itemid == 200012 && $instanceid > 0) {
		if ($clicky_check == 0) {
			plugin::ClientMessage($client, "Repopping the whole zone.");
			plugin::Data($client, 2, $bucket_name, 1, "M15");
			quest::clearspawntimers();
			quest::repopzone();
		} else {
			plugin::ClientMessage($client, "You must wait $time_string after your last use to repop the zone again.");
		}
	} else {
		plugin::ClientMessage($client, "You must be in an instance to repop the zone!");
	}
}