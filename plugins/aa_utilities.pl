# plugin::AddAAPoints($client, $amount);
sub AddAAPoints {
	my (
		$client,
		$amount,
	) = (
		shift,
		shift,
	);
	my $end = ($client->GetAAPoints() + $amount);
	$client->SetAAPoints($end);
	plugin::ClientMessage($client, "You recieve " . plugin::commify($amount) . " AA Points, you now have " . plugin::commify($end) . " AA Points."); 
}

# plugin::TakeAAPoints($client, $amount);
sub TakeAAPoints {
	my (
		$client,
		$amount,
	) = (
		shift,
		shift,
	);
	my $current = $client->GetAAPoints();
	if ($current >= $amount) {
		my $end = ($current - $amount);
		$client->SetAAPoints($end);
		plugin::ClientMessage($client, "You lose " . plugin::commify($amount) . " AA Points, you now have " . plugin::commify($end) . " AA Points.");
	}
}