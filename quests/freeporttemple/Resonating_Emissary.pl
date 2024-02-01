sub EVENT_SAY {
	my $prestige_flag = plugin::Data($client, 3, "Prestige");
	if (($ulevel == 70 && $prestige_flag == 1) || $status == 255) {
		if ($text=~/Hail/i) {
			my $aid_link = quest::saylink("aid", 1);
			plugin::Whisper(
				"Hail $name, My queen, Ayonae Ro has uncovered some strange happenings within Dreadspire Keep.
				She fears this anomally could threaten the entire world. Will you $aid_link The Maestra?"
			);
		} elsif ($text=~/Aid/i) {
			quest::taskselector(202);
		}
	} elsif ($ulevel < 70) {
		plugin::Whisper("I only speak to the most elite of soldiers.");;
	} elsif ($prestige_flag < 1) {
		plugin::Whisper("If you would like to become my champion you must prove yourself by becoming a dragon slayer.");;
	} elsif ($prestige_flag > 1) {
		plugin::Whisper("You have already proven yourself worthy.");;
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}