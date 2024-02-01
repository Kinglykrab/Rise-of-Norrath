sub EVENT_SPELL_EFFECT_CLIENT {

	my $randmob = plugin::Treasure_Spawn();
	my %prog_zones_loot = plugin::TierLootHash();
	my @prog_zones = keys %prog_zones_loot;
	$client->Message(15, "CASTED ON YOU");
	
	foreach my $zone (@prog_zones) {
		$client->Message(15, "$zone");
	}
	
	
	if(quest::ChooseRandom(100) >= 10) { 
		if($client->Admin() > 100) {
			#$client->Message(15, "Random Mob: $randmob");
			#quest::spawn2($randmob,0,0,$client->GetX(),$client->GetY(),$client->GetZ(),$client->GetHeading()/2);
			#$entity_list->GetNPCByNPCTypeID($randmob)->AddToHateList($client,1);
			#$entity_list->GetNPCByNPCTypeID($randmob)->Shout("a");
			#SetEntityVariable("client",$client->GetEnt()
		}
	}
	
}