sub EVENT_SAY {
	my $found = 0;
	if($text=~/hail/i) {
		if (quest::GetInstanceID($zonesn, 1)) {
			$found = quest::GetInstanceID($zonesn, 1);
			$client->MoveZoneInstance($found);
		}
		if (!$found) {
			quest::say("Would you like to " . quest::saylink("create",1,"create") . " an instance?");
		}
	}
	
	if($text=~/create/i) {
		plugin::CreateInstance("Group", 1, $client->GetMoney(3, 0), $client->GetMoney(3, 0));
	}
}