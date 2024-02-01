sub EVENT_SIGNAL {
	if($signal == 1 || $signal == 2 || $signal == 3) {
		my %elements = (
			1	=>	"Fire",
			2	=>	"Disease",
			3	=>	"Void"
		);
		
		$client->SetEntityVariable("Element","" . $elements{$signal} . "");
		#$client->Message(15, "Signal Received: $signal: " . $client->GetEntityVariable("Element") . "");
		plugin::ColorZoneEmote(15, "" . $client->GetCleanName() . " has been cursed by " . $client->GetEntityVariable("Element") . "!");
		quest::settimer("Elements",18);
	}
	elsif($signal == 4) {
		plugin::ColorZoneEmote(15, "" . $client->GetCleanName() . " has cleared their elements!");
		$client->SetEntityVariable("Element","null");
		$client->SpellFinished(42422,$client,-1);
		quest::stoptimer("Elements");
	}
	elsif($signal == 5) {
		$client->SetEntityVariable("Element","null");
		quest::stoptimer("Elements");
	}
}

sub EVENT_TIMER {

	my %signals = (
		"Fire"		=>	10,
		"Disease"	=>	11,
		"Void"		=>	12
	);

	if($timer eq "Elements") {
		quest::stoptimer("Elements");
		if($client->GetEntityVariable("Element") ne "null") {
			#$client->Message(15, "YOU SHOULD BE DEAD NOW");
			plugin::ColorZoneEmote(15, "The elements coalesce and overload around " . $client->GetCleanName() . "");
			quest::signalwith(2000309,$signals{$client->GetEntityVariable("Element")},1);
		}
	}
}