sub Whisper {
	my $npc = plugin::val('npc');
	my $client = plugin::val('client');
	my $message = shift;
	$client->Message(315, $npc->GetCleanName() . " whispers, '$message'");
}

sub ClientMessage {
	my $client = shift;
	my $message = shift;
	$client->Message(315, $message);
}

sub ClientColorMessage {
	my (
		$client,
		$color,
		$message
	) = (
		shift,
		shift,
		shift,
	);
	$client->Message($color, $message);
}

sub Message {
	my $client = plugin::val('client');
	my $message = shift;
	$client->Message(315, $message);
}

sub TargetMessage {
	my $client = plugin::val('client');
	my $message = shift;
	$client->Message(18, $message);
}

sub Sentinel_GM {
	my $text = shift;
	my $STag = "[Sentinel] ::";
	quest::worldwidemessage(15,"$STag $text", 255);
}

sub GM {
	my $text = shift;
	quest::worldwidemessage(18, $text, 255);
}

sub ServerAnnounce {
	my $text = shift;
	quest::worldwidemessage(15, $text);
}

sub ZoneAnnounce {
	my $text = shift;
	quest::gmsay($text, 335, 0, 0, 0);
}

sub GearAnnounce {
	my $name = plugin::val('name');
	my $item = shift;
	quest::worldwidemessage(335, "Congratulations to $name on their " . quest::varlink($item) . "!");
}

sub GetNPCName {
	my $npc = plugin::val('npc');
	return $npc->GetCleanName();
}

sub Emote {
	my $npc = plugin::val('npc');
	my $text = shift;
	quest::gmsay($npc->GetCleanName() . " shouts, '$text'", 335, 0, 0, 0);	
}

sub ColorZoneEmote {
	my (
		$color,
		$text,
	) = (
		shift,
		shift,
	);
	quest::gmsay($text, $color, 0, 0, 0);	
}