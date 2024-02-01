sub EVENT_SAY {
	my $rank = plugin::GetBeltRank($client);
	my $delevel_flag = plugin::GetDelevelFlag($client);
	if($delevel_flag) {
		if($text=~/hail/i) {
			if($ulevel == 70) {
				if($rank == 0) {
					plugin::Whisper("You are back so soon.. Are you ready for your [" . quest::saylink("reward",1) . "]?");
				} else {
				plugin::Whisper("You are back! Are you ready to infuse your [" . quest::saylink("belt",1) . "] with the knowledge you have earned?");
				}
			} else {
				plugin::Whisper("Perhaps you would like a [" . quest::saylink("list",1) . "] of places where you can find this ancient knowledge?");
			}
		} elsif($text eq "list") {
			plugin::Whisper("ZONELIST");
		} elsif($text eq "reward") {
			plugin::Whisper("Congratulations, $name. This is the first of many!");
			quest::summonitem(200501);
			plugin::AddBeltRank($client);
		}
		$client->Message(15, "You are currently de-leveled");
	} elsif($ulevel >= 70) {
		if($rank == 0) {
			if($text=~/hail/i) {
				if($rank == 0) {
					plugin::Whisper("Finally.. someone with great [" . quest::saylink("power",1) . "]!");
				} else {
					plugin::Whisper("Back for some more.. eh? If you'd like to start our journey again just [" . quest::saylink("tell",1) . "] me.");
				}
			} elsif ($text eq "power") {
				#plugin::Whisper("Ah.. A $class.. How I would love to add one of those to my [" . quest::saylink("collection",1) . "]");
				plugin::Whisper("What you can do now is nothing compared to what we could do together.. The things we could [" . quest::saylink("accomplish",1) . "]");
			} elsif ($text eq "accomplish") {
				plugin::Whisper("The price is simple. You must give me a piece of your soul.. You will start your journey anew.. but this time you will retain your skills.
				The reward will be much greater than the price. The decision is yours. [" . quest::saylink("tell",1) . "] me if you wish to continue.");
				$client->Message(315, "WARNING: This will de-level your character to level one.");
			} elsif ($text eq "tell") {			
				plugin::Popup("Waist of Time Info",
				"Welcome $name. Your current rank is: $rank <br> <br>
				You may de-level by pressing 'yes'. WARNING: This action is irreversible. <br> <br>
				",1,27);
			}
		} else {
			plugin::Whisper("Back for more, eh? Would you like to start [" . quest::saylink("working",1) . "] on another rank?");
		}
	} else {
		plugin::Whisper("You must be level 70 to start this journey. Come back when you are more experienced.");	
	}
}

