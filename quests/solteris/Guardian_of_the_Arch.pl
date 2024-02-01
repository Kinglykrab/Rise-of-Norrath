sub EVENT_SPAWN {
	plugin::SetProx(30,200,1);
}

sub EVENT_ENTER {
	
	quest::shout("" . $client->GetCleanName() . "");
	
}