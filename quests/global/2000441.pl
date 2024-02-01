sub EVENT_SPAWN {
	my $client = $entity_list->GetClientByID($npc->GetSwarmOwner());
	plugin::CloneAppearance($client, $npc);
}

