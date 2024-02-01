sub EVENT_SAY {
	my $prestige_flag = plugin::Data($client, 3, "Prestige");
	my $progression_flag = plugin::Data($client, 3, "Progression");
	my $task_completed = $client->IsTaskCompleted(201);
	if ($ulevel == 70 && ($progression_flag == 20 || $status >= 80)) {
		if ($text=~/Hail/i) {
			if (!$task_completed && $prestige_flag == 0) {
				my $try_link = quest::saylink("try", 1);
				plugin::Whisper("Hail $name, I see you have finished the Tier Progression and would like to acquire a more powerful arsenal of weapons, armor, and spells.
				In order to Prestige you must first complete a rather treacherous task for me.
				Would you like to give it a $try_link?");
			} else {
				plugin::Whisper("Sorry $name, but I have no more tasks for you.");
			}
		} elsif ($text=~/Try/i) {
			if (!$task_completed) {
				quest::taskselector(201);
			}
		}
	} elsif ($ulevel < 70) {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	} elsif ( < 20) {
		plugin::Whisper("In order to Prestige, you must first complete the Tier Progression.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}