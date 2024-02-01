sub EVENT_SAY {
	if ($text=~/Hail/i) {
		plugin::Whisper("Hail $name, would you like to " . quest::saylink("list", 1) . " your instance lockouts?");
	} elsif ($text=~/List/i) {
		plugin::ListInstances($charid);
	}
}