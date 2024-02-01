sub EVENT_SAY {
	if ($ulevel == 70) {
		plugin::Whisper("I can exchange your Epic for a different kind if you have more than one kind of Epic.");
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::ExchangeEpic();
	plugin::return_items();
}