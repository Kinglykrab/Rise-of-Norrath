# plugin::CreateInstance($type, $instance_version, $before_platinum, $after_platinum);
sub CreateInstance {
    my $client = plugin::val('client');
	my $name = plugin::val('name');
    my $zone_id = plugin::val('zoneid');
    my $zone_short_name = plugin::Zone("SN", $zone_id);
	my (
		$type,
		$instance_version,
		$before_platinum,
		$after_platinum
	) = (
		ucfirst(shift),
		shift,
		shift,
		shift
	);
    # Type => [Instance Duration, Bucket Duration, Lockout Duration, Instance Type]
    my %instance_types = plugin::InstanceTypes();
    my (
		$char_instance_duration,
		$char_bucket_duration,
		$char_lockout_duration,
		$char_instance_type
	) = @{$instance_types{$type}};
    my $char_instance_id = quest::CreateInstance($zone_short_name, $instance_version, $char_instance_duration);
    # Instance Data Buckets
    plugin::ServerData(2, "Instance-Leader-$char_instance_id", $name, $char_bucket_duration);
    plugin::ServerData(2, "Instance-Type-$char_instance_id", $char_instance_type, $char_bucket_duration);
    # Lockout Data Bucket
    plugin::Data($client, 2, "Instance-Lockout-$char_instance_type-$zone_short_name", 1, $char_lockout_duration);
	plugin::LogInstance("Create", $char_instance_id, $type, $instance_version, $before_platinum, $after_platinum);
    $client->MoveZoneInstance($char_instance_id);
}

# plugin::CreateCustomInstance($zonesn, $type, $instance_version, $before_platinum, $after_platinum);
sub CreateCustomInstance {
    my $client = plugin::val('client');
	my $name = plugin::val('name');
	my (
		$zone_short_name,
		$type,
		$instance_version,
		$before_platinum,
		$after_platinum
	) = (
		shift,
		ucfirst(shift),
		shift,
		shift,
		shift
	);
    my $zone_id = plugin::Zone("ID", $zone_short_name);
    # Type => [Instance Duration, Bucket Duration, Lockout Duration, Instance Type]
    my %instance_types = plugin::InstanceTypes();
    my (
		$char_instance_duration,
		$char_bucket_duration,
		$char_lockout_duration,
		$char_instance_type
	) = @{$instance_types{$type}};
    my $char_instance_id = quest::CreateInstance($zone_short_name, $instance_version, $char_instance_duration);
    # Instance Data Buckets
    plugin::ServerData(2, "Instance-Leader-$char_instance_id", $name, $char_bucket_duration);
    plugin::ServerData(2, "Instance-Type-$char_instance_id", $char_instance_type, $char_bucket_duration);
    # Lockout Data Bucket
    plugin::Data($client, 2, "Instance-Lockout-$char_instance_type-$zone_short_name", 1, $char_lockout_duration);
	plugin::LogInstance("Create", $char_instance_id, $type, $instance_version, $before_platinum, $after_platinum);
    $client->MoveZoneInstance($char_instance_id);
}

# plugin::ClearLockouts();
sub ClearLockouts {
	my $client = plugin::val('client');
	my $zone_short_name = plugin::val('zonesn');
	my $zone_long_name = plugin::Zone("LN", $zone_short_name);
	my $potato_link = quest::varlink(187002);
	foreach my $type (0..2) {
		plugin::Data($client, 0, "Instance-Lockout-$type-$zone_short_name");
	}
	plugin::Whisper("Your lockouts have been reset for $zone_long_name, thank you for using the $potato_link.");
}
	
# plugin::LeaveInstance($instance_id);
sub LeaveInstance {
	my $client = plugin::val('client');
	my $instance_id = shift;
	my $leader_bucket = plugin::ServerData(3, "Instance-Leader-$instance_id");
	my $leader_name = quest::getcharnamebyid($leader_bucket);
	if ($leader_name ne "") {
		quest::RemoveFromInstance($instance_id);
		quest::zone("freeporttemple");
	} else {
		plugin::Message("= | Instance Leave Failed");
		plugin::Message("== | Invalid instance data, failed to leave.");
	}
}

# plugin::JoinInstance($instance_id);
sub JoinInstance {
	my $client = plugin::val('client');
	my $character_id = $client->CharacterID();
	my (
		$instance_id,
	) = (
		shift,
	);
	my $instance_check = quest::CheckInstanceByCharID($instance_id, $character_id);
	if ($instance_check) {
		plugin::Message("= | Joining instance $instance_id.");
		$client->MoveZoneInstance($instance_id);
	} else {
		plugin::Message("= | Failed to join instance $instance_id, you are not in this instance.");
	}
}

# plugin::DeleteInstance($instance_id);
sub DeleteInstance {
	my $client = plugin::val('client');
	my $zone_id = plugin::val('zoneid');
	my $zone_short_name = plugin::val('zonesn');
	my $instance_id = shift;
	my $leader_bucket = plugin::ServerData(3, "Instance-Leader-$instance_id");
	if ($leader_bucket ne "") {
		quest::RemoveAllFromInstance($instance_id);
		quest::DestroyInstance($instance_id);
		quest::zone("$zone_short_name");
	} else {
		plugin::Message("= | Instance Delete Failed");
		plugin::Message("== | Invalid instance data, failed to delete.");
	}
}

# plugin::GetOptions($char_group_check, $char_raid_check, $char_guild_check);
sub GetOptions {
	my (
		$char_group_check,
		$char_raid_check
	) = (
		shift,
		shift,
	);
	my $options = 0;
	if ($char_group_check) {
		$options = 1;
		if ($char_raid_check) {
			$options = 2;
		}
	} else {
		if ($char_raid_check) {
			$options = 3;
		}
	}
	return $options;
}

# plugin::HandleInstanceInvite();
sub HandleInstanceInvite {
	use JSON qw(decode_json);
	my $client = plugin::val('client');
	my $character_id = plugin::val('charid');
	my %instance_invite_types = plugin::InstanceInviteTypes($character_id);
	my $invite_bucket = quest::getcharnamebyid($character_id) . "-instance-data";
	my $invite_data_json = plugin::ServerData(3, $invite_bucket);
	my $invite_data = decode_json $invite_data_json;
	my $instance_id = $invite_data->{instance_id};
	my $instance_type = $invite_data->{instance_type};
	my $sender_id = $invite_data->{sender_id};
	my $sender_name = $invite_data->{sender_name};
	my $zone_id = $invite_data->{zone_id};
	my $zone_short_name = plugin::Zone("SN", $zone_id);
	my $zone_long_name = plugin::PWColor(plugin::Zone("LN", $zone_id), "Royal Blue");
	my $client_lockout_check = 0;
	my $client_lockout_timer = 0;
	foreach my $type (0..2) {
		if (
			plugin::Data($client, 3, "Instance-Lockout-$type-$zone_short_name") && 
			plugin::Data($client, 4, "Instance-Lockout-$type-$zone_short_name") > 0
		) {
			$client_lockout_check = 1;
			$client_lockout_timer = plugin::TimeRemaining(plugin::Data($client, 4, "Instance-Lockout-$instance_type-$zone_short_name"));
			last;
		}
	}
	if ($instance_type ~~ [1, 2]) {
		my ($invite_type, $client_check) = ($instance_invite_types{$instance_type}[0], $instance_invite_types{$instance_type}[1]);
		# plugin::Message("$client_check $instance_id $instance_type $sender_id $sender_name $zone_id $zone_long_name");
		if ($client_check == $sender_id) {
			my $instance_check = quest::CheckInstanceByCharID($instance_id, $character_id);
			if (!$instance_check && !$client_lockout_check) {
				plugin::Message("= | $invite_type Instance Invite from $sender_name");
				plugin::Message(
					"== | " . 
					quest::saylink("#inst accept", 1, "Accept") . 
					" | " .
					quest::saylink("#inst decline", 1, "Decline")
				);
			} elsif (!$instance_check && $client_lockout_check) {
				plugin::Message("= | Failed Instance Invite from $sender_name");
				plugin::Message("== | You still have a $client_lockout_timer lockout remaining.");
			} elsif ($instance_check) {
				plugin::Message("= | Failed Instance Invite from $sender_name");
				plugin::Message("== | You're already in this instance.");
			}
		} else {
			plugin::Message("= | Failed Instance Invite from $sender_name");
			plugin::Message("== | You are not in their $invite_type.");
		}
	} else {
		plugin::Message("= | Failed Instance Invite from $sender_name");
		plugin::Message("== | Solo only instance.");
	}
}

# plugin::InviteToInstance(@invite_list);
sub InviteToInstance {
	use JSON qw(encode_json);
	my $time = time();
	my $client = plugin::val('client');
	my $character_id = $client->CharacterID();
	my %instance_invite_types = plugin::InstanceInviteTypes($character_id);
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_type = plugin::ServerData(3, "Instance-Type-$instance_id");
	my $instance_version = plugin::val('instanceversion');
	my $sender_id = ($instance_type > 0 ? $instance_invite_types{$instance_type}[1] : 0);
	my $sender_name = plugin::val('name');
	my ($sender_x, $sender_y, $sender_z) = ($client->GetX(), $client->GetY(), $client->GetZ());
	my @invite_list = @_;
	my $invite_number = 0;
	while (defined $invite_list[$invite_number]) {
		my $invited_name = ucfirst($invite_list[$invite_number]);
		my $invite_data = {
			instance_id => $instance_id,
			instance_type => $instance_type,
			instance_version => $instance_version,
			invited_name => $invited_name,
			sender_id => $sender_id,
			sender_name => $sender_name,
			sender_x => $sender_x,
			sender_y => $sender_y,
			sender_z => $sender_z,
			zone_id => $zone_id,
		};
		my $invite_data_json = encode_json $invite_data;
		plugin::Data($client, 1, "Invite-Log-$time", $invite_data_json);
		plugin::ServerData(2, "$invited_name-instance-data", $invite_data_json, "5M");
		quest::crosszonesignalclientbyname($invited_name, 1000);
		$invite_number++;
	}
}

# plugin::InstanceCostTypes();
sub InstanceCostTypes {
	my %instance_cost_types = (
		"Low" => [
			25000,
			[
				"arena2", "bothunder", "droga", "eastkarana", "emeraldjungle",
				"ferubi", "fhalls", "kael", "load2", "load", "permafrost",
			 	"pofire", "potactics", "skyfire", "sleeper", "soldungb",
			 	"anguish", "veksar", "templeveeshan", "akheva", "bothunder",
			 	"crushbone", "frostcrypt"
			]
		],
		"Medium" => [
			50000,
			[
				"postorms", "discord", "anguish", "codecay", "crystallos"
			]
		],
		"High" => [
			100000,
			[
				"ashengate", "atiiki", "beholder", "deadbone", "mechanotus",
				"redfeather", "roost", "shiningcity", "mseru", "sseru", "drachnidhive"
			]
		],
		"Highest" => [
			250000,
			[
				"oldfieldofbone", "arcstone", "dreadspire"
			]
		],
	);
	return %instance_cost_types;
}

# plugin::InstanceInviteTypes();
sub InstanceInviteTypes {
	my $character_id = shift;
	my %instance_invite_types = (
		1 => ["Group", quest::getgroupidbycharid($character_id)],
		2 => ["Raid", quest::getraididbycharid($character_id)],
	);
	return %instance_invite_types;
}

# plugin::InstanceTypes();
sub InstanceTypes {
	my %instance_types = (
		"Solo" => [14400, "90M", "6H", 0],
   		"Group" => [43200, "90M", "18H", 1],
    	"Raid" => [86400, "3H", "36H", 2]
	);
	return %instance_types;
}

# plugin::InstanceZonesArray();
sub InstanceZonesArray {
	my @instance_zone_short_names = (
		"arena2", "bothunder", "droga", "eastkarana", "emeraldjungle",
		"ferubi", "fhalls", "kael", "load2", "load", "permafrost",
		"pofire", "potactics", "skyfire", "sleeper", "soldungb",
		"anguish", "veksar", "templeveeshan", "akheva", "bothunder",
		"crushbone", "frostcrypt", "postorms", "discord", "anguish", "codecay", "crystallos",
		"ashengate", "atiiki", "beholder", "deadbone", "mechanotus",
		"redfeather", "roost", "shiningcity", "mseru", "sseru",
		"oldfieldofbone", "arcstone", "dreadspire",
	);
	return @instance_zone_short_names;
}

# plugin::ListOptions($type, $sub_type);
sub ListOptions {
	my $client = plugin::val('client');
	my $zonesn = plugin::val('zonesn');
	my $instanceid = plugin::val('instanceid');
	my $instanceversion = plugin::val('instanceversion');
	my $charid = plugin::val('charid');
	my $char_instance_id = quest::GetInstanceIDByCharID($zonesn, $instanceversion, $charid);
	my $char_leader_check = (
		$char_instance_id ?
		(
			plugin::ServerData(3, "Instance-Leader-$char_instance_id") eq $client->GetCleanName() ? 
			1 : 
			0
		) : 
		0
	);
	my $char_solo_lockout = (
		plugin::Data($client, 3, "Instance-Lockout-0-$zonesn") ? 
		1 : 
		0
	);
	my $char_group_lockout = (
		plugin::Data($client, 3, "Instance-Lockout-1-$zonesn") ? 
		1 : 
		0
	);
	my $char_raid_lockout = (
		plugin::Data($client, 3, "Instance-Lockout-2-$zonesn") ? 
		1 : 
		0
	);
	my $char_solo_lockout_timer = (
		$char_solo_lockout ?
		plugin::TimeRemaining(plugin::Data($client, 4, "Instance-Lockout-0-$zonesn")) : 
		0
	);
	my $char_group_lockout_timer = (
		$char_group_lockout ? 
		plugin::TimeRemaining(plugin::Data($client, 4, "Instance-Lockout-1-$zonesn")) :
		0
	);
	my $char_raid_lockout_timer = (
		$char_raid_lockout ?
		plugin::TimeRemaining(plugin::Data($client, 4, "Instance-Lockout-2-$zonesn")) : 
		0
	);
	my $type = shift;
	# 0 => Member Outside
	# 1 => Leader Outside
	my $sub_type = shift;
	# 0 => Solo
	# 1 => Solo | Group
	# 2 => Solo | Group | Raid
	# 3 => Solo | Raid
	my %options_data = (
	0 => {
		# [Solo, Group, Raid]
		0 => [1, 0, 0],
		1 => [1, 1, 0],
		2 => [1, 1, 1],
		3 => [1, 0, 1],
	},
	1 => {
		# [Solo, Group, Raid]
		0 => [1, 0, 0],
		1 => [1, 1, 0],
		2 => [1, 1, 1],
		3 => [1, 0, 1],
	});
	my %instance_cost_types = plugin::InstanceCostTypes();
	my $instance_cost_platinum = 0;
	foreach my $cost_type (sort {$instance_cost_types{$a}[0] <=> $instance_cost_types{$b}[1]} keys %instance_cost_types) {
		my ($cost, @cost_zones_array) = ($instance_cost_types{$cost_type}[0], @{$instance_cost_types{$cost_type}[1]});
		if ($zonesn ~~ @cost_zones_array) {
			$instance_cost_platinum = $cost;
		}
	}
	
	my (
		$solo_check,
		$group_check,
		$raid_check
	) = @{$options_data{$type}{$sub_type}};
	
	if ($char_instance_id == 0) {
		plugin::Message("= | Instance Options (Base Cost " . plugin::commify($instance_cost_platinum) . " Platinum)");
		if ($char_solo_lockout == 0) {
			plugin::Message("== | Solo: " . quest::saylink("create solo", 1, "Create"));
		} else {
			plugin::Message("== | Solo: $char_solo_lockout_timer");
		}
		
		if (!$raid_check && $group_check) {
			if ($char_group_lockout == 0) {
				plugin::Message("== | Group (1.5x Base): " . quest::saylink("create group", 1, "Create"));
			} else {
				plugin::Message("== | Group: $char_group_lockout_timer");
			}
		}		
		
		if ($raid_check) {
			if ($char_raid_lockout == 0) {
				plugin::Message("== | Raid (3x Base): " . quest::saylink("create raid", 1, "Create"));
			} else {
				plugin::Message("== | Raid: $char_raid_lockout_timer");
			}
		}
	} else {
		my $instance_type = plugin::ServerData(3, "Instance-Type-$char_instance_id");
		plugin::Message("= | Instance Options");
		if ($instance_type != 0) {
			plugin::Message("== | Solo: Unavailable");
		} elsif ($instance_type == 0) {
			if ($char_leader_check) {
				if ($instanceid == 0) {
					plugin::Message("== | Solo: " . quest::saylink("enter solo", 1, "Enter") . " | " . quest::saylink("delete solo", 1, "Delete"));
				} else {
					plugin::Message("== | Solo: " . quest::saylink("delete solo", 1, "Delete"));
				}
			} else {
				if ($instanceid == 0) {
					plugin::Message("== | Solo: " . quest::saylink("enter solo", 1, "Enter") . " | " . quest::saylink("leave solo", 1, "Leave"));
				} else {
					plugin::Message("== | Solo: " . quest::saylink("leave solo", 1, "Leave"));
				}
			}
		}
		
		if ($group_check) {
			if ($instance_type != 1) {
				plugin::Message("== | Group: Unavailable");
			} elsif ($instance_type == 1) {
				if ($char_leader_check) {
					if ($instanceid == 0) {
						plugin::Message("== | Group: " . quest::saylink("enter group", 1, "Enter") . " | " . quest::saylink("delete group", 1, "Delete"));
					} else {
						plugin::Message("== | Group: " . quest::saylink("delete group", 1, "Delete"));
					}
				} else {
					if ($instanceid == 0) {
						plugin::Message("== | Group: " . quest::saylink("enter group", 1, "Enter") . " | " . quest::saylink("leave group", 1, "Leave"));
					} else {
						plugin::Message("== | Group: " . quest::saylink("leave group", 1, "Leave"));
					}
				}
			}
		}
		
		if ($raid_check) {
			if ($instance_type != 2) {
				plugin::Message("== | Raid: Unavailable");
			} elsif ($instance_type == 2) {
				if ($char_leader_check) {
					if ($instanceid == 0) {
						plugin::Message("== | Raid: " . quest::saylink("enter raid", 1, "Enter") . " | " . quest::saylink("delete raid", 1, "Delete"));
					} else {
						plugin::Message("== | Raid: " . quest::saylink("delete raid", 1, "Delete"));
					}
				} else {
					if ($instanceid == 0) {
						plugin::Message("== | Raid: " . quest::saylink("enter raid", 1, "Enter") . " | " . quest::saylink("leave raid", 1, "Leave"));
					} else {
						plugin::Message("== | Raid: " . quest::saylink("leave raid", 1, "Leave"));
					}
				}
			}
		}		
	}
}

# plugin::ListInstances($character_id);
sub ListInstances {
	my $client = plugin::val('client');
	my $character_id = shift;
	my $character_name = quest::getcharnamebyid($character_id);
	my @message = ();
	my @instance_zones_array = plugin::InstanceZonesArray();
	my $instance_count = 0;
	my $instance_index = 1;
	foreach my $instance_zone_short_name (@instance_zones_array) {
		if (quest::GetInstanceIDByCharID($instance_zone_short_name, 0, $character_id)) {
			my $instance_zone_long_name = plugin::Zone("LN", $instance_zone_short_name);
			my $instance_id = quest::GetInstanceIDByCharID($instance_zone_short_name, 0, $character_id);
			my $leader_name = plugin::ServerData(3, "Instance-Leader-$instance_id");
			my $zone_time_remaining = plugin::TimeRemaining(plugin::ServerData(4, "Instance-Leader-$instance_id"));
			my $join_link = quest::saylink("#inst join $instance_id", 1, $instance_zone_long_name);
			push (
				@message,
				"== | $instance_index. $join_link ($instance_id) | Leader $leader_name | Remaining $zone_time_remaining"
			);
			$instance_count++;
			$instance_index++;
		}
	}
	plugin::Message("= | $character_name Instance List");
	if ($instance_count > 0) {
		plugin::Message($_) for @message;
	} else {
		plugin::Message("== | Empty List");
	}
}

# plugin::RemoveFromInstance($instance_id, $character_name);
sub RemoveFromInstance {
	my $client = plugin::val('client');
	my $entity_list = plugin::val('entity_list');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $zone_short_name = plugin::val('zonesn');
	my (
		$instance_id,
		$character_name
	) = (
		shift,
		shift,
	);
	my $character_id = quest::getcharidbyname($character_name);
	my $leader_name = plugin::ServerData(3, "Instance-Leader-$instance_id");
	if ($leader_name ne "") {
		quest::RemoveFromInstanceByCharID($instance_id, $character_id);
		if ($character_id == $client->CharacterID()) {
			quest::zone("$zone_short_name");
		} else {
			quest::crosszonesetentityvariablebyclientname($character_name, "instance_remove", $instance_id);
			quest::crosszonesignalclientbyname($character_name, 1002);
		}
	} else {
		plugin::Message("= | Instance Remove Failed");
		plugin::Message("== | Invalid instance data, failed to remove.");
	}
}

# plugin::SetInstanceLeader($instance_id, $character_name);
sub SetInstanceLeader {
	my $client = plugin::val('client');
	my $entity_list = plugin::val('entity_list');
	my $name = plugin::val('name');
	my (
		$instance_id,
		$character_name
	) = (
		shift,
		shift,
	);
	my $leader_name = plugin::ServerData(3, "Instance-Leader-$instance_id");
	if ($leader_name ne "") {
		if ($character_id > 0) {
			if (quest::CheckInstanceByCharID($instance_id, $character_id)) {
				plugin::ServerData(1, "Instance-Leader-$instance_id", $character_name);
				quest::crosszonesetentityvariablebyclientname($character_name, "instance_leader", $instance_id);
				quest::crosszonesignalclientbyname($character_name, 1001);
				plugin::Message("= | Instance Leader Change Succeeded");
				plugin::Message("== | $character_name is now the leader of your instance.");
			} else {
				plugin::Message("= | Instance Leader Change Failed");
				plugin::Message("== | $character_name is not a member of your instance.");
			}
		} else {
			plugin::Message("= | Instance Leader Change Failed");
			plugin::Message("== | $character_name is an invalid character name.");
		}
	} else {
		plugin::Message("= | Instance Promote Failed");
		plugin::Message("== | Invalid instance data, failed to promote.");
	}
}