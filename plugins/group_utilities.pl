sub GroupCount {
	my $client = plugin::val('client');
	my $entity_list = plugin::val('entity_list');
	my $group_count = 1;
	if ($client->GetGroup()) {
		for (my $member_index = 0; $member_index < 6; $member_index++) {
			my $group_member = $client->GetGroup()->GetMember($member_index);
			if (
				$group_member && 
				$group_member->IsClient() &&
				$group_member->GetID() != $client->GetID()
			) {
				$group_count++;
			}
		}
	} elsif ($client->GetRaid()) {
		for (my $member_index = 0; $member_index < 72; $member_index++) {
			my $raid_member = $client->GetRaid()->GetMember($member_index);
			if (
				$raid_member && 
				$raid_member->IsClient() &&
				$raid_member->GetID() != $client->GetID()
			) {
				$group_count++;
			}
		}
	}
	return $group_count;
}

sub ClientGroupCount {
	my $client = shift;
	my $entity_list = plugin::val('entity_list');
	my $group_count = 1;
	my @client_list = $entity_list->GetClientList();
	if ($client->GetGroup()) {
		my $group_id = $client->GetGroup()->GetID();
		foreach my $client_entity (@client_list) {
			if ($client_entity->GetGroup() && $client_entity->GetGroup()->GetID() == $group_id) {
				$group_count++;
			}
		}
	} elsif ($client->GetRaid()) {
		my $raid_id = $client->GetRaid()->GetID();
		foreach my $client_entity (@client_list) {
			if ($client_entity->GetRaid() && $client_entity->GetRaid()->GetID() == $raid_id) {
				$group_count++;
			}
		}
	}
	return $group_count;
}