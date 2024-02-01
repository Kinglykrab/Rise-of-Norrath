sub EVENT_CLICKDOOR {
	if($doorid == 2) {	#:: 1st to 2nd Island
		DoorTP($client,-970.83,1049.52,1350.25,509.3);
	}
	if($doorid == 18) {	#:: 2nd to 3rd Island
		DoorTP($client,-2232.96,2914.08,2643.36,0.3);
	}
	if($doorid == 14) {	#:: 3rd to 4th Island
		DoorTP($client,-2279.32,5295.77,3918.54,0.8);
	}
}



sub DoorTP {	#:: I will add logic for instances later
	my $client = shift;
	my ($x,$y,$z,$h) = (shift,shift,shift,shift);
	#$client->Message(15, "$x $y $z $h $zonesn");
	quest::movepc(quest::GetZoneID($zonesn),$x,$y,$z,$h);
}
