sub EVENT_ITEM_CLICK {
	my @npc_list = $entity_list->GetNPCList();
	my $npc_count = 0;
	my $donator_check = plugin::GetCurrency($client, 11);
	my $clicked_check = plugin::Data($client,5,"AggroClicky");
	if ($itemid ~~ [701, 200000] && $instanceid > 0) {
		if(!$clicked_check) {
			if ($donator_check >= 10) {
				plugin::TakeCurrency($client, 11, 10);
				foreach my $npc_entity (@npc_list) {
					if ($npc_entity->GetLevel() < 255 && $npc_count < 100) {
						$npc_entity->AddToHateList($client, 1);
						$npc_count++;
					}
				}
				plugin::ClientMessage($client, "Pulling the whole zone, brace yourself.");
				plugin::Data($client, 2, "AggroClicky", 1, 600); 
			} else {
				plugin::ClientMessage($client, "You must have 10 Reborn Tokens to zone pull.");
			}
		} else {
			plugin::ClientMessage($client, "You must wait " . plugin::ConvertTimeRemaining($clicked_check) . " minutes after your last use to zone pull again.");
		}
	} else {
		plugin::ClientMessage($client, "You must be in an instace to zone pull!");
	}
}