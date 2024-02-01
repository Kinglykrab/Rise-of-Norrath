#:: plugin::GetBeltRank($client);
#:: get Waist of Time rank
sub GetBeltRank {
	my $client = $_[0];
	return plugin::Data($client, 3, "BeltRank");
}

sub GetDelevelFlag {
	my $client = $_[0];
	return plugin::Data($client, 3, "Deleveled");
}

sub AddBeltRank {
	my $client = $_[0];
	my $current_rank = plugin::GetBeltRank($client);
	if($current_rank == 0) {
		quest::summonitem(200501);
	} else {
		quest::removeitem($current_rank+200500);
		quest::summonitem($current_rank+200501);
	}
	plugin::Data($client, 0, "Deleveled");
	plugin::Data($client, 1, "BeltRank", $current_rank+1);
	$current_rank++;
	plugin::GearAnnounce(200500+$current_rank);
}

sub Delevel {
	my $client = $_[0];
	if($client->GetLevel() == 70) {
		plugin::Data($client,1,"Deleveled",1);
		$client->SetLevel(1);
		$client->SetEXP(1,1);
	}
}