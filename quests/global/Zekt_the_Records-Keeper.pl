sub EVENT_SAY {
	my @service_types = (
		"Name Changes",
		"Race Changes",
		"Account Transfers",
		"Character Restorations"
	);
	my $name_denied = 0;
	if($text=~/hail/i) {
		plugin::Whisper("Hello, $name. If you're looking to change your identity I think you will find my " . quest::saylink("services", 1) . " helpful.");
	} elsif($text eq "services") {
		my @message;
		plugin::Whisper("I can provide the following services.");
		foreach my $service_type (@service_types) {
			push(
				@message,
				quest::saylink($service_type, 0)
			);
		}
		plugin::Message(join(" | ", @message));
	} elsif($text eq "Name Changes") {
		BuyServices(1);
	} elsif($text=~/changename/i) {
		my @arg = split(' ', $text);
		if($arg[1]) {
			my $new_name = $arg[1];
			$name_denied = (LoadNamingFilter($arg[1]) + LoadCharNames($arg[1]));
			$name_denied++ if (length($new_name) > 12);
			
			if($name_denied == 0) {
				plugin::Whisper("Your name will be '$new_name' from now on.");
			} else {
				plugin::Whisper("Your chosen name of '$new_name' has been denied.");
			}	
		} else {
			plugin::Whisper("To check the availability of a certain name, simply type 'changename <name>' without the <>'s.");
		}
	}
}

sub LoadNamingFilter {
	my $name = shift;
	my $database_handler = plugin::LoadMysql();
	my $query = 
	"
		SELECT
			name_filter.name
		FROM
			name_filter
	";
	$query_handler = $database_handler->prepare($query);
	$query_handler->execute(); 
	my $found = 0;
	while (my $name_filter = $query_handler->fetchrow_array()) {
		if ($name =~ /$name_filter/i) {
			$found = 1;
		}
	}
	return $found;
}

sub LoadCharNames {
	my $name = shift;
	my $database_handler = plugin::LoadMysql();
	my $query = 
	"
		SELECT
			character_data.name
		FROM
			character_data
		WHERE
			character_data.name = '$name' AND
			character_data.deleted_at IS NULL
	";
	$query_handler = $database_handler->prepare($query);
	$query_handler->execute(); 
	my $found = 0;
	if ($query_handler->rows() > 0) {
		$found = 1;
	}
	return $found;
}

# plugin::BuyFromShop($type, $index);
sub BuyServices {
	my $player_wallet = $client->GetAlternateCurrencyValue(11);
	my $service = shift;
	my %services = (
		1 => 5	#:: Name Change
	);
	
	my $item_cost = $services{$service};
	if ($player_wallet >= $item_cost) {
		if($service == 1) {
			if(plugin::Data($client, 3, "PendingNameChange") == 0) {
				$client->SetAlternateCurrencyValue(11, ($player_wallet - $item_cost));
				plugin::Data($client, 1, "PendingNameChange", 1);
				plugin::Whisper("You have successfully purchased a name change. Would you like to " . quest::saylink("changename", 1, "use") . " it now?");
			}
			else {
				plugin::Whisper("You have already purchased a name change. Would you like to " . quest::saylink("changename", 1, "use") . " it now?");
			}
		}
	}
}