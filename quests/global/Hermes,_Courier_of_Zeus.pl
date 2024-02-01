sub EVENT_SAY {
	my $progression_flag = plugin::Data($client, 3, "Progression");
	my $found = 0;
	foreach my $instance_version (1..10) {
		if (quest::GetInstanceID($zonesn, $instance_version)) {
			$found = quest::GetInstanceID($zonesn, $instance_version);
		}
	}
	
	if ($instanceid == 0) {
		if ($text=~/Hail/i) {
			if (!$found) {
				plugin::Whisper(
					"Hail $name, I am the Courier of Zeus.
					These devilish creatures around me are much stronger than they appear, but you must first enter the realm of the Gods."
				);
				for my $rank (1..10) {
					my $rank_string = plugin::Tier($rank);
					my $required_tier = ($rank + 9);
					my $rank_link = quest::saylink("rank $rank", 1, "Rank $rank_string Dungeon (Tier $required_tier+)");
					if ($progression_flag >= $required_tier) {
						plugin::Message("$rank. $rank_link");
					}
				}
			} else {
				my $enter_link = quest::saylink("enter", 1);
				my $delete_link = quest::saylink("delete", 1);
				plugin::Whisper(
					"Hail $name, I see you already have an instance.
					Would you like to $enter_link it?
					Or would you like to $delete_link it?"
				);
			}
		} elsif ($text=~/^Rank/i) {
			my $rank = substr($text, 5);
			my $rank_string = plugin::Tier($rank);
			my $send_link = quest::saylink("send $rank", 1, "sure");
			plugin::Whisper("Are you $send_link you want to enter Rank $rank_string?");
		} elsif ($text=~/Enter/i) {
			$client->MoveZoneInstance($found);
		} elsif ($text=~/Delete/i) {
			plugin::DeleteInstance($found);
		} elsif ($text=~/^Send/i) {
			my $rank = substr($text, 5);			
			plugin::CreateInstance("Group", $rank, $client->GetMoney(3, 0), $client->GetMoney(3, 0));
		}
	} else {
		if ($text=~/Hail/i) {
			my $leave_link = quest::saylink("leave", 1);
			plugin::Whisper(
				"Hail $name, I see you're in an instance.
				Would you like to $leave_link?"
			);
		} elsif ($text=~/Leave/i) {
			quest::zone($zonesn);
		}
	}
}