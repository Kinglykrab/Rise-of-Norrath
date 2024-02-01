sub EVENT_SPAWN {
	$npc->SetFlyMode(1);
	

	

	

	#$npc->TempName(" ");
	#$npc->SetBodyType(11);
	

	
	
	plugin::SetProx(15,55);
}

sub EVENT_SIGNAL {
	if($signal == 2) {
		#quest::shout("got it: $signal");
		my %random = (
		"276177"		=>	["11512","Fire"],
		"276178"		=>	["11519","Disease"],
		"276179"		=>	["11518","Void"]	
		);
		
		$npc->WearChange(7, $random{$npc->GetSp2()}[0]);
		$npc->TempName("" . $random{$npc->GetSp2()}[1] . "");
	}
	else {
		$npc->WearChange(7,0);
		$npc->TempName(" ");
	}
}

sub EVENT_ENTER {
	my %random = (
	"276177"		=>	["11512","Fire"],
	"276178"		=>	["11519","Disease"],
	"276179"		=>	["11518","Void"]	
	);
	
	my $element = $client->GetEntityVariable("Element");
	
	#quest::shout("$element");
	
	if($element ne "null" && ($element eq $random{$npc->GetSp2()}[1])) {
		
		$npc->SignalClient($client,4);
	
	}
	else {
		if($entity_list->GetNPCByNPCTypeID(2000309)) {
			quest::signalwith(2000309,15,1);
		}
	}

}