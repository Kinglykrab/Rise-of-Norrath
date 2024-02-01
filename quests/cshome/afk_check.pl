sub EVENT_SPAWN {
	my $spawngroup = $npc->GetSp2();
	if($spawngroup=~/276064|276065|276067/) {
		plugin::SetProx(15,15);
	}
	else {
		plugin::SetProx(50,50);
	}
	$npc->TempName("");
	$npc->SetBodyType(11);
}

sub EVENT_ENTER {
	#$npc->SignalClient($client,1);
}

sub EVENT_EXIT {
	#$npc->SignalClient($client,1);
}