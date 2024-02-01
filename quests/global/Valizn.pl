sub EVENT_SAY {
	my $tier_flag = plugin::Data($client, 3, "Progression");
	my $next_tier_flag = (plugin::ProgressionZone(1) + 1);
	if ($tier_flag < $next_tier_flag) {
		if ($text=~/Hail/i) {
			my $access_link = quest::saylink("access", 1);
			my $next_tier = plugin::Tier(plugin::ProgressionZone(1) + 1);
			plugin::Whisper("Hail $name, are you looking for $access_link to Tier $next_tier?");
		} elsif ($text=~/Access/i) {
			my $task_id = (500 + plugin::ProgressionZone(1));
			if (
				!$client->IsTaskActive($task_id) && 
				!$client->IsTaskCompleted($task_id)
			) {
				quest::taskselector($task_id);
				plugin::Whisper("Here's your task, come back to me when you have completed it.");
			} elsif (
				$client->IsTaskActive($task_id) && 
				!$client->IsTaskCompleted($task_id)
			) {
				plugin::Whisper("It seems you have this task already.");
			} elsif (
				!$client->IsTaskActive($task_id) && 
				$client->IsTaskCompleted($task_id)
			) {
				plugin::Whisper("It seems you have completed this task already.");
			}
		}
	} else {
		plugin::Whisper("You are already flagged.");
	}
}