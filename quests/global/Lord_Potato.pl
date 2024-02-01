sub EVENT_SPAWN {
	$npc->SetLevel(255);
}

sub EVENT_ITEM {
	if (plugin::check_handin(\%itemcount, 187002 => 1)) {
		if($client->GetInstanceID() == 0) {
			plugin::PotatoPass($client, $zonesn);
		} else {
			plugin::Whisper("Whoa there big guy! You can't give this to me while you're already in an instance.. can't you see I'm workin' here?");
			quest::summonitem(187002);
		}
	}
    plugin::return_items(\%itemcount);
}

sub EVENT_SAY {
	my %instance_cost_types = plugin::InstanceCostTypes();
	my %instance_types = plugin::InstanceTypes();
	my $instance_cost_platinum = 25000;
	foreach my $expansion (sort {$instance_cost_types{$a}[0] <=> $instance_cost_types{$b}[1]} keys %instance_cost_types) {
		my ($expansion_cost, @expansion_zones_array) = ($instance_cost_types{$expansion}[0], @{$instance_cost_types{$expansion}[1]});
		if ($zonesn ~~ @expansion_zones_array) {
			$instance_cost_platinum = $expansion_cost;
		}
	}
	
	my $char_instance_id = quest::GetInstanceIDByCharID($zonesn, $instanceversion, $client->CharacterID());
	my $instance_leader_name = plugin::ServerData(3, "Instance-Leader-$char_instance_id");
	my $char_leader_check = ($char_instance_id > 0 ? ($instance_leader_name eq $name ? 1 : 0) : 0);
	my $leader_message = ($char_leader_check ? "and you are the leader." : "but you are not the leader.");
	my $char_instance_type = ($char_instance_id > 0 ? plugin::ServerData(3, "Instance-Type-$char_instance_id") : 0);
	my $char_lockout_check = 0;
	my $char_lockout_timer = 0;
	foreach my $type (0..2) {
		if (plugin::Data($client, 3, "Instance-Lockout-$type-$zonesn")) {
			$char_lockout_check = 1;
			$char_lockout_timer = plugin::TimeRemaining(plugin::Data($client, 4, "Instance-Lockout-$type-$zonesn"));
			last;
		}
	}
	
	my $char_group_check = $client->GetGroup();
	my $char_raid_check = $client->GetRaid();
	my $char_option_type = plugin::GetOptions($char_group_check, $char_raid_check);
	my $instance_type_name = "";
	foreach my $key (sort {$instance_types{$a}[3] <=> $instance_types{$b}[3]} keys %instance_types) {
		my $instance_type = $instance_types{$key}[3];
		if ($char_instance_type == $instance_type) {
			$instance_type_name = $key;
		}
	}

	if ($instanceid == 0) {
		if ($text=~/Hail/i) {
			if (!$char_instance_id && !$char_lockout_check) {
				plugin::Whisper("Hail $name, would you like to " . quest::saylink("make", 1) . " an instance?");
				plugin::Message("= | Warning: Deleting your instance prematurely will incur a lockout.");
			} elsif (!$char_instance_id && $char_lockout_check) {
				plugin::Whisper("Sorry $name, you still have $char_lockout_timer remaining until you can make another instance in " . plugin::Zone("LN", $zonesn) . ".");
			} elsif ($char_instance_id) {
				plugin::Whisper("I see you have a $instance_type_name instance, $leader_message");
				plugin::ListOptions($char_leader_check, $char_option_type);
			}
		} elsif ($text=~/Create/i) {
			my $instance_type = substr($text, 7);
			if ($instance_type eq "Group") {
				$instance_cost_platinum *= 1.5;
			} elsif ($instance_type eq "Raid") {
				$instance_cost_platinum *= 3;
			}
			$instance_cost_platinum = int($instance_cost_platinum);
			my (
				$before_platinum,
				$after_platinum
			) = (
				$client->GetMoney(3, 0),
				($client->GetMoney(3, 0) - $instance_cost_platinum)
			);
			my $instance_cost_platinum_string = plugin::commify($instance_cost_platinum);
			if (!$char_instance_id && !$char_lockout_check) {
				if (plugin::TakePlatinum($client, $instance_cost_platinum)) {
					plugin::CreateInstance($instance_type, 0, $before_platinum, $after_platinum);
				} else {
					plugin::Whisper("You cannot afford an instance, it costs $instance_cost_platinum_string Platinum.");
				}
			} elsif (!$char_instance_id && $char_lockout_check) {
				plugin::Whisper("Sorry $name, you still have $char_lockout_timer remaining until you can make another instance in " . plugin::Zone("LN", $zonesn) . ".");
			} elsif ($char_instance_id) {
				my $leave_string = (
					$char_leader_check ? 
					"delete" : 
					"leave"
				);
				plugin::Whisper(
					"I see you already have a $instance_type_name instance for this zone.
					You'll have to $leave_string it before creating a new instance."
				);
			}
		} elsif ($text=~/Enter/i) {
			my $instance_type = substr($text, 7);
			if ($char_instance_id != 0) {
				plugin::LogInstance(
					"Enter", 
					$char_instance_id, 
					$instance_type_name, 
					$instanceversion
				);				
				$client->MoveZoneInstance($char_instance_id);
			} else {
				plugin::Whisper("You don't have a $instance_type Instance for this zone.");
			}
		} elsif ($text=~/Make/i) {
			my $char_instance_id = quest::GetInstanceIDByCharID(
				$zonesn, 
				$instanceversion, 
				$charid
			);
			my $instance_leader_name = plugin::ServerData(3, "Instance-Leader-$char_instance_id");
			my $char_leader_check = ($char_instance_id > 0 ? ($instance_leader_name eq $client->GetCleanName() ? 1 : 0) : 0);
			my $char_guild_check = (quest::getguildidbycharid($charid) > 0 ? 1 : 0);
			my $char_group_check = $client->GetGroup();
			my $char_raid_check = $client->GetRaid();
			plugin::ListOptions($char_leader_check, plugin::GetOptions($char_group_check, $char_raid_check));
		}
	} else {
		if ($text=~/Hail/i) {
			plugin::Whisper("I see you are in an instance, $leader_message");
			plugin::ListOptions($char_leader_check, $char_option_type);
		}
	}
	
	if ($text=~/Delete/i) {
		if ($char_leader_check) {
			plugin::LogInstance("Delete", $char_instance_id, $instance_type_name, $instanceversion);
			plugin::Whisper("Deleting your instance.");
			plugin::DeleteInstance($char_instance_id);
		} else {
			plugin::Message($char_leader_check);
			plugin::Whisper("Only the leader of an instance can delete the instance, you must leave the instance.");		
		}
	} elsif ($text=~/Leave/i) {
		if (!$char_leader_check) {
			plugin::LogInstance("Leave", $char_instance_id, $instance_type_name, $instanceversion);
			plugin::Whisper("Leaving your instance.");
			plugin::RemoveFromInstance($char_instance_id, $name);
		} else {
			plugin::Whisper("The leader of an instance cannot leave, you must delete the instance.");	
		}
	}
}