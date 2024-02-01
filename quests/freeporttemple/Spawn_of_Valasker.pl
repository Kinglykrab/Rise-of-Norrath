sub EVENT_SAY {
	if($text=~/hail/i) {
		plugin::Whisper("Would you like to [" . quest::saylink("teleport",1,"teleport") . "] to the GM Event?");
	}
	if($text eq "teleport") {
		quest::zone("dragoncrypt");
	}
}