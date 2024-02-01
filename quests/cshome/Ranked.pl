sub EVENT_SAY {
	my $rank = plugin::GetBeltRank($client);
	my $delevel_flag = plugin::GetDelevelFlag($client);
	#plugin::RankUpBelt($client);
	if($text=~/hail/i) {
		if($delevel_flag) {
			if($ulevel == 70) {
				plugin::Whisper("You are back so soon.. Are you ready for your [" . quest::saylink("reward",1) . "]?");
			} else {
				plugin::Whisper("Welcome back, $name. I see you are still on the path of wisdom.. Perhaps you would like a [" . quest::saylink("list",1) . "] of places where you can find this ancient knowledge?");
			}
		} elsif($ulevel >= 70) {
			if($rank == 0) {
				plugin::Whisper("Finally.. someone with great [" . quest::saylink("power",1) . "]! How I would love to add a $class to my collection.");
			} else {
				plugin::Whisper("Back for some more.. eh? If you'd like to [" . quest::saylink("start",1) . "] our journey again let me know.");
			}
		}
	} elsif($text eq "reward" && $delevel_flag && $ulevel == 70) {
		plugin::Whisper("Your power grows!");
		plugin::AddBeltRank($client);
	} elsif ($text eq "power" && $delevel_flag == 0) {
		#plugin::Whisper("Ah.. A $class.. How I would love to add one of those to my [" . quest::saylink("collection",1) . "]");
		plugin::Whisper("What you can do now is nothing compared to what we could do together.. The things we could [" . quest::saylink("accomplish",1) . "]");
	} elsif ($text eq "accomplish" && $delevel_flag == 0) {
		plugin::Whisper("The price is simple. You must give me a piece of your soul.. You will start your journey anew.. but this time you will retain your skills.
		The reward will be much greater than the price. The decision is yours. Tell me if you wish to [" . quest::saylink("start",1) . "] our journey.");
		$client->Message(315, "WARNING: This will de-level your character to level one.");
	} elsif ($text eq "start" && $delevel_flag == 0) {			
		plugin::Popup("Waist of Time Info",
		"Welcome $name. Your current rank is: $rank <br> <br>
		You may de-level by pressing 'yes'. WARNING: This action is irreversible. <br> <br>
		",1,27);
	} elsif ($text eq "list") {
		plugin::Whisper("ZONELIST");
	}
}