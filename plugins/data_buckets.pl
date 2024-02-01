# Parameters depend on Type
# Type 0: plugin::Data($client, $type, $name);
# Type 1: plugin::Data($client, $type, $name, $value);
# Type 2: plugin::Data($client, $type, $name, $value, $duration);
# Type 3: plugin::Data($client, $type, $name);
# Type 4: plugin::Data($client, $type, $name);
# Type 5: plugin::Data($client, $type, $name);
sub Data {
	my $client = shift;
	my $character_id = $client->CharacterID();
	my $type = shift;
	my $name = shift;
	if ($type == 0) {
		quest::delete_data("$character_id-$name");
	} elsif ($type == 1) {
		my $value = shift;
		quest::set_data("$character_id-$name", $value);
	} elsif ($type == 2) {
		my $value = shift;
		my $duration = shift;
		quest::set_data("$character_id-$name", $value, $duration);
	} elsif ($type == 3) {
		return quest::get_data("$character_id-$name") ne "" ? quest::get_data("$character_id-$name") : 0;
	} elsif ($type == 4) {
		return quest::get_data_expires("$character_id-$name");
	} elsif ($type == 5) {
		my $current_time = time();
		return quest::get_data_expires("$character_id-$name") ne "" ? (quest::get_data_expires("$character_id-$name") - $current_time) : 0;
	}
}

# Parameters depend on Type
# Type 0: plugin::ServerData($type, $name);
# Type 1: plugin::ServerData($type, $name, $value);
# Type 2: plugin::ServerData($type, $name, $value, $duration);
# Type 3: plugin::ServerData($type, $name);
# Type 4: plugin::ServerData($type, $name);
# Type 5: plugin::ServerData($type, $name);
sub ServerData {
	my $type = shift;
	my $name = shift;
	if ($type == 0) {
		quest::delete_data($name);
	} elsif ($type == 1) {
		my $value = shift;
		quest::set_data($name, $value);
	} elsif ($type == 2) {
		my $value = shift;
		my $duration = shift;
		quest::set_data($name, $value, $duration);
	} elsif ($type == 3) {
		return quest::get_data($name) ne "" ? quest::get_data($name) : 0;
	} elsif ($type == 4) {
		return quest::get_data_expires($name);
	} elsif ($type == 5) {
		my $current_time = time();
		return quest::get_data_expires($name) ne "" ? (quest::get_data_expires($name) - $current_time) : 0;
	}
}

# plugin::TimeRemaining($expiration_time);
sub TimeRemaining {
	my $expiration_time = shift;
	my $current_time = time;
	my $remaining_time = ($expiration_time - $current_time);
	my $pre = $remaining_time;
	my $hours = int($remaining_time / 3600);
	$remaining_time = ($remaining_time % 3600);
	my $minutes = int($remaining_time / 60);
	$remaining_time = ($remaining_time % 60);
	my $seconds = $remaining_time;
	if ($hours < 0 || $minutes < 0 || $seconds < 0) {
		return "Unknown";
	} else {
		if ($hours > 0 && $minutes > 0 && $seconds > 0) {
			return "$hours Hour(s), $minutes Minute(s), and $seconds Second(s)";
		} elsif ($hours == 0 && $minutes > 0 && $seconds > 0) {
			return "$minutes Minute(s) and $seconds Second(s)";			
		} elsif ($hours == 0 && $minutes == 0 && $seconds > 0) {
			return "$seconds Second(s)";			
		}
	}
}

# plugin::ConvertTimeRemaining($remaining_time);
sub ConvertTimeRemaining {
	my $remaining_time = shift;
	my $pre = $remaining_time;
	my $hours = int($remaining_time / 3600);
	$remaining_time = ($remaining_time % 3600);
	my $minutes = int($remaining_time / 60);
	$remaining_time = ($remaining_time % 60);
	my $seconds = $remaining_time;
	if ($hours < 0 || $minutes < 0 || $seconds < 0) {
		return "Unknown";
	} else {
		if ($hours > 0 && $minutes > 0 && $seconds > 0) {
			return "$hours Hour(s), $minutes Minute(s), and $seconds Second(s)";
		} elsif ($hours == 0 && $minutes > 0 && $seconds > 0) {
			return "$minutes Minute(s) and $seconds Second(s)";			
		} elsif ($hours == 0 && $minutes == 0 && $seconds > 0) {
			return "$seconds Second(s)";			
		}
	}
}

# plugin::SetPrestige($prestige);
sub SetPrestige {
	my $client = plugin::val('client');
	my $prestige = shift;
	plugin::Data($client, 1, "Prestige", $prestige);
}

# plugin::SetProgressionFlag($client, $tier);
sub SetProgressionFlag {
	my $client = shift;
	my $tier = shift;
	plugin::Data($client, 1, "Progression", $tier);
}

# plugin::SetDonator($client);
sub SetDonator {
	my $client = shift;
	my $client_ip = plugin::IP($client->GetIP());
	plugin::ServerData(1, "Donator-$client_ip", 1);
	plugin::ClientMessage($client, "You are now flagged as a donator.");
}