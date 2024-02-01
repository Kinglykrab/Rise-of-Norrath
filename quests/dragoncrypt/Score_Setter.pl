sub EVENT_SAY {
	my $rank = $npc->GetNPCTypeID()-2000312;
		quest::settimer("depop",300);
		quest::say("" . plugin::Data($client, 3, "GMEventOne-HighScore") . " :: $rank");
	
	if(plugin::Data($client, 3, "GMEventOne-HighScore") < $rank) {
		plugin::Data($client, 1, "GMEventOne-HighScore", $rank);
		$npc->SignalClient($client,5);
		quest::worldwidemessage(15, "" . $client->GetCleanName() . " has defeated a mighty foe! (Rank: $rank)");
	}
	else {
		plugin::Whisper("You have already attained rank: $rank!");
	}
}

sub EVENT_TIMER {
	if($timer eq "Depop") {
		quest::stoptimer("Depop");
		quest::depopall($_) for (2000313..2000318);
	}
}