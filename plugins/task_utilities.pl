sub HasTierTask {
	my (
		$client,
		$tier,
	) = (
		shift,
		shift,
	);
	my $task_check = 0;
	my $tier_task = ($tier + 500);
	if ($client->IsTaskActive($tier_task)) {
		$task_check = 1;
	}
	return $task_check;
}

sub UpdateTierTask {
	my (
		$client,
		$tier,
		$activity,
		$amount,
	) = (
		shift,
		shift,
		shift,
		shift,
	);
	if (!$client->GetGroup()) {
		my $tier_check = plugin::HasTierTask($client, $tier);
		my $tier_task = ($tier + 500);
		if ($tier_check) {
			$client->UpdateTaskActivity($tier_task, $activity, $amount);
		}
	} elsif ($client->GetGroup()) {
		foreach (my $member = 0; $member < 6; $member++) {
			if (
				$client->GetGroup()->GetMember($member) && 
				$client->GetGroup()->GetMember($member)->IsClient()
			) {
				my $group_member = $client->GetGroup()->GetMember($member)->CastToClient();
				my $tier_check = plugin::HasTierTask($group_member, $tier);
				my $tier_task = ($tier + 500);
				if ($tier_check) {
					$group_member->UpdateTaskActivity($tier_task, $activity, $amount);
				}
			}
		}
	}
}

#npctypespawn 2000459
#npcspawn add