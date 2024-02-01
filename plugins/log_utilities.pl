# plugin::LogArmor($tier, $item_id, $before_shards, $after_shards, $before_crystals, $after_crystals, $before_aa_points, $after_aa_points, $before_tier_shards, $after_tier_shards);
sub LogArmor {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$tier,
		$item_id, 
		$before_shards, 
		$after_shards,
		$before_crystals, 
		$after_crystals,
		$before_aa_points, 
		$after_aa_points,
		$before_tier_shards,
		$after_tier_shards,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		tier => $tier,
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		aa_points => {
			before => $before_aa_points,
			after => $after_aa_points,
		},
		tier_shards => {
			before => $before_tier_shards,
			after => $after_tier_shards,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_armor_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogAugment($item_type, $shop_type, $item_id, $before_shards, $after_shards, $before_crystals, $after_crystals);
sub LogAugment {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_type, 
		$shop_type, 
		$item_id, 
		$before_shards, 
		$after_shards, 
		$before_crystals, 
		$after_crystals,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_type => $item_type,
		shop_type => $shop_type,
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_augment_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogDonator($merchant_type, $item_id, $before_credits, $after_credits);
sub LogDonator {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$merchant_type,
		$item_id,
		$before_credits,
		$after_credits,
	) = (
		shift,
		shift,
		shift,
		shift,
	);
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		int($client->GetX()),
		int($client->GetY()),
		int($client->GetZ()),
	);
	my $log_data = {
		merchant_type => $merchant_type,
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		credits => {
			before => $before_credits,
			after => $after_credits,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_donator_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogCrystalConversion($item_id, $before_ebon, $after_ebon, $before_radiant, $after_radiant);
sub LogCrystalConversion {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id, 
		$before_ebon, 
		$after_ebon,
		$before_radiant, 
		$after_radiant,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		ebon => {
			before => $before_ebon,
			after => $after_ebon,
		},
		radiant => {
			before => $before_radiant,
			after => $after_radiant,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_crystal_conversion_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogEpic($item_id, $before_shards, $after_shards, $before_crystals, $after_crystals, $before_aa_points, $after_aa_points,);
sub LogEpic {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id, 
		$before_shards, 
		$after_shards,
		$before_crystals, 
		$after_crystals,
		$before_aa_points, 
		$after_aa_points,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		aa_points => {
			before => $before_aa_points,
			after => $after_aa_points,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_epic_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogExchange($item_id, $before_shards, $after_shards, $before_crystals, $after_crystals, $before_aa_points, $after_aa_points, $before_loyalty, $after_loyalty);
sub LogExchange {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id, 
		$before_shards, 
		$after_shards,
		$before_crystals, 
		$after_crystals,
		$before_aa_points, 
		$after_aa_points,
		$before_loyalty,
		$after_loyalty,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		aa_points => {
			before => $before_aa_points,
			after => $after_aa_points,
		},
		loyalty => {
			before => $before_loyalty,
			after => $after_loyalty,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_exchange_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogFruit($item_id, $before_shards, $after_shards, $before_crystals, $after_crystals, $before_aa_points, $after_aa_points, $before_item_one, $after_item_one, $before_item_two, $after_item_two, $before_item_three, $after_item_three, $before_item_four, $after_item_four, $before_item_five, $after_item_five);
sub LogFruit {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id,
		$before_shards,
		$after_shards,
		$before_crystals,
		$after_crystals,
		$before_aa_points,
		$after_aa_points,
		$before_item_one,
		$after_item_one,
		$before_item_two,
		$after_item_two,
		$before_item_three,
		$after_item_three,
		$before_item_four,
		$after_item_four,
		$before_item_five,
		$after_item_five
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		aa_points => {
			before => $before_aa_points,
			after => $after_aa_points,
		},
		items => {
			item_one => {
				before => $before_item_one,
				after => $after_item_one,
			},
			item_two => {
				before => $before_item_two,
				after => $after_item_two,
			},
			item_three => {
				before => $before_item_three,
				after => $after_item_three,
			},
			item_four => {
				before => $before_item_four,
				after => $after_item_four,
			},
			item_five => {
				before => $before_item_five,
				after => $after_item_five,
			},
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_fruit_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogInstance($action, $instance_id, $instance_type, $instance_version[, $before_platinum, $after_platinum]);
sub LogInstance {
	use JSON qw(encode_json);
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $time = time();
	my $action = shift; # Create, Delete, Enter, Leave
	my $instance_id = shift;
	my $instance_type = shift; # Solo, Group, Raid, Guild
	my $instance_version = shift;
	my ($before_platinum, $after_platinum) = (0, 0);
	if ($action eq "Create") {
		($before_platinum, $after_platinum) = (shift, shift);
	}
	my ($x, $y, $z) = ($client->GetX(), $client->GetY(), $client->GetZ());
	my $instance_log = {
		action => $action,
		instance_id => $instance_id,
		instance_type => $instance_type,
		instance_version => $instance_version,
		name => $name,
		platinum => {
			after => $after_platinum,
			before => $before_platinum,
		},
		x => $x,
		y => $y,
		z => $z,
		zone_id => $zone_id,
	};
	my $instance_log_json = encode_json $instance_log;
	plugin::Data($client, 1, "Instance-Log-$time", $instance_log_json);
}

# plugin::LogLoyaltyConversion($amount, $before_platinum, $after_platinum);
sub LogLoyaltyConversion {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$amount_convert, 
		$before_platinum, 
		$after_platinum,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		amount_convert => $amount_convert,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		platinum => {
			before => $before_platinum,
			after => $after_platinum,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_loyalty_conversion_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogPet($item_id, $before_shards, $after_shards, $before_crystals, $after_crystals, $before_aa_points, $after_aa_points);
sub LogPet {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id, 
		$before_shards, 
		$after_shards,
		$before_crystals, 
		$after_crystals,
		$before_aa_points, 
		$after_aa_points,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		aa_points => {
			before => $before_aa_points,
			after => $after_aa_points,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_pet_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogPlatinumConversion($amount, $before_shards, $after_shards, $before_crystals, $after_crystals, $before_platinum, $after_platinum);
sub LogPlatinumConversion {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$amount_convert, 
		$before_shards,
		$after_shards,
		$before_crystals,
		$after_crystals,
		$before_platinum, 
		$after_platinum,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		amount_convert => $amount_convert,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		platinum => {
			before => $before_platinum,
			after => $after_platinum,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_platinum_conversion_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogPrestige();
# sub LogPrestige {
# }

# plugin::LogProgression($item_id, $before_tier, $after_tier);
sub LogProgression {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id,
		$before_tier,
		$after_tier
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		tier => {
			before => $before_tier,
			after => $after_tier,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_progression_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogShardConversion($amount_convert, $before_shards, $after_shards);
sub LogShardConversion {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$amount_convert, 
		$before_shards, 
		$after_shards,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		amount_convert => $amount_convert,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_shard_conversion_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogSkill($skill, $before_aa_points, $after_aa_points);
sub LogSkill {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id,
		$before_aa_points,
		$after_aa_points
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		skill => $skill,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		aa_points => {
			before => $before_aa_points,
			after => $after_aa_points,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_skill_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogSource($item_id, $before_shards, $after_shards, $before_crystals, $after_crystals, $before_aa_points, $after_aa_points, $before_platinum, $after_platinum);
sub LogSource {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id, 
		$before_shards, 
		$after_shards,
		$before_crystals, 
		$after_crystals,
		$before_aa_points, 
		$after_aa_points,
		$before_platinum,
		$after_platinum,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		shards => {
			before => $before_shards,
			after => $after_shards,
		},
		crystals => {
			before => $before_crystals,
			after => $after_crystals,
		},
		aa_points => {
			before => $before_aa_points,
			after => $after_aa_points,
		},
		platinum => {
			before => $before_platinum,
			after => $after_platinum,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_source_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

# plugin::LogWeapon($item_id, $before_item_one, $after_item_one, $before_item_two, $after_item_two, $before_item_three, $after_item_three, $before_item_four, $after_item_four, $before_item_five, $after_item_five, $before_item_six, $after_item_six);
sub LogWeapon {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$item_id, 
		$before_item_one,
		$after_item_one,
		$before_item_two,
		$after_item_two,
		$before_item_three,
		$after_item_three,
		$before_item_four,
		$after_item_four,
		$before_item_five,
		$after_item_five,
		$before_item_six,
		$after_item_six
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		items => {
			item_one => {
				before => $before_item_one,
				after => $after_item_one,
			},
			item_two => {
				before => $before_item_two,
				after => $after_item_two,
			},
			item_three => {
				before => $before_item_three,
				after => $after_item_three,
			},
			item_four => {
				before => $before_item_four,
				after => $after_item_four,
			},
			item_five => {
				before => $before_item_five,
				after => $after_item_five,
			},
			item_six => {
				before => $before_item_six,
				after => $after_item_six,
			},
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_weapon_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();
}

sub LogMoldOffset {
	use JSON qw(encode_json);
	my $time = time();
	my (
		$tier,
		$type,
		$item_id,
		$before_tier_currency,
		$after_tier_currency,
	) = @_;
	my $client = plugin::val('client');
	my $name = plugin::val('name');
	my $zone_id = plugin::val('zoneid');
	my $instance_id = plugin::val('instanceid');
	my $instance_version = plugin::val('instanceversion');
	my (
		$x,
		$y,
		$z,
	) = (
		$client->GetX(),
		$client->GetY(),
		$client->GetZ(),
	);
	my $log_data = {
		tier => $tier,
		type => $type,
		item_id => $item_id,
		name => $name,
		level => $client->GetLevel(),
		race => $client->GetRace(),
		class => $client->GetClass(),
		tier_currency => {
			before => $before_tier_currency,
			after => $after_tier_currency,
		},
		zone_id => $zone_id,
		instance_id => $instance_id,
		instance_version => $instance_version,
		x => $x,
		y => $y,
		z => $z,
	};
	my $log_data_json = encode_json $log_data;
	my $database_handler = plugin::LoadMysql();
	$database_handler->do(
		"INSERT INTO `eqe_mold_offset_logs` (`log`, `log_time`) VALUES 
		('$log_data_json', '$time')"
	);
	$database_handler->disconnect();	
}