# plugin::AddCrystals($client, $type, $action, $crystals);
# plugin::AddCrystals($client, $type, $action_one, $action_two, $radiant_crystals, $ebon_crystals);
sub AddCrystals {
	my (
		$client,
		$type,
	) = (
		shift,
		shift
	);
	if ($type ~~ ["Ebon", "Radiant"]) {
		my $action = shift;
		my $crystals = ($action == 1 ? (-1 * shift) : shift);
		if ($type eq "Ebon") {
			$client->AddCrystals(0, $crystals);
			if ($crystals > 0) {
				my $ebon_link = quest::varlink(40902);
				plugin::ClientMessage($client, "You receive $crystals $ebon_link.");
			}
		} elsif ($type eq "Radiant") {
			$client->AddCrystals($crystals, 0);
			if ($crystals > 0) {
				my $radiant_link = quest::varlink(40903);
				plugin::ClientMessage($client, "You receive $crystals $radiant_link.");
			}
		}
	} elsif ($type eq "Both") {
		my (
			$action_one,
			$action_two,
		) = (
			shift,
			shift,
		);
		my (
			$radiant_crystals,
			$ebon_crystals,
		) = (
			($action_one == 1 ? (-1 * shift) : shift),
			($action_two == 1 ? (-1 * shift) : shift),
		);
		$client->AddCrystals($radiant_crystals, $ebon_crystals);
		my $loot_check = plugin::Data($client, 3, "Loot-Clicky");
		if ($radiant_crystals > 0 && $ebon_crystals == 0) {
			if ($loot_check > 0 && $client->GetZoneID() != 183) {
				$radiant_crystals *= $loot_check;
			}
			my $radiant_link = quest::varlink(40903);
			plugin::ClientMessage($client, "You receive $radiant_crystals $radiant_link.");
		} elsif ($ebon_crystals > 0 && $radiant_crystals == 0) {
			if ($loot_check > 0 && $client->GetZoneID() != 183) {
				$ebon_crystals *= $loot_check;
			}
			my $ebon_link = quest::varlink(40902);
			plugin::ClientMessage($client, "You receive $ebon_crystals $ebon_link.");				
		} elsif ($radiant_crystals > 0 && $ebon_crystals > 0) {
			if ($loot_check > 0 && $client->GetZoneID() != 183) {
				$ebon_crystals *= $loot_check;
				$radiant_crystals *= $loot_check;
			}
			my $ebon_link = quest::varlink(40902);
			my $radiant_link = quest::varlink(40903);
			plugin::ClientMessage($client, "You receive $radiant_crystals $radiant_link and $ebon_crystals $ebon_link.");
		}
	}
}

# plugin::AddCurrency($client, $currency_id, $currency_value);
sub AddCurrency {
	my (
		$client,
		$currency_id,
		$currency_value,
	) = (
		shift,
		shift,
		shift,
	);
	my $item_id = quest::getcurrencyitemid($currency_id);
	my $currency_link = quest::varlink($item_id);
	my $loot_check = plugin::Data($client, 3, "Loot-Clicky");
	if ($loot_check > 0 && $client->GetZoneID() != 183) {
		$currency_value *= $loot_check;
	}
	$client->AddAlternateCurrencyValue($currency_id, $currency_value);
	plugin::ClientMessage($client, "You receive $currency_value $currency_link.");
	#if ($client->Admin() == 255) {
	#	plugin::ClientMessage($client, "CID: $currency_id IID: $item_id");
	#}
}

# plugin::AddCurrency($client, $currency_id, $currency_value);
sub AddCurrencyRandom {
	my (
		$client,
		$currency_id,
		$currency_value,
	) = (
		shift,
		shift,
		shift,
	);
	#plugin::ClientMessage($client, "$currency_id $currency_value");
	my $entity_list = plugin::val('entity_list');
	if ($client->GetGroup() || $client->GetRaid()) {
		my %currency_members = plugin::GetCurrencyMembers($client);
		my @members = keys %currency_members;
		my $choice = $members[rand @members];
		if ($client->GetGroup()->GetMember($choice)) {
			my $member = $client->GetGroup()->GetMember($choice);
			$member->SetEntityVariable("Loot", 1);
			plugin::AddCurrency($member, $currency_id, $currency_value);
		}
	} else {
		plugin::AddCurrency($client, $currency_id, $currency_value);
	}
}

# plugin::GetCurrencyMembers($client);
sub GetCurrencyMembers {
	my $client = shift;
	my $group_count = plugin::ClientGroupCount($client);
	my $entity_list = plugin::val('entity_list');
	my %members = ();
	my $count = 1;
	if ($client->GetGroup()) {
		foreach my $member_index (0..5) {
			my $group_member = $client->GetGroup()->GetMember($member_index);
			if (
				$group_member && 
				$group_member->IsClient()
			) {
				if (!$group_member->EntityVariableExists("Loot") || 
					(
						$group_member->EntityVariableExists("Loot") &&
						$group_member->GetEntityVariable("Loot") == -1
					)
				) {
					$members{$member_index} = 1;
				} elsif (
					$group_member->EntityVariableExists("Loot") &&
					$group_member->GetEntityVariable("Loot") > 0
				) {
					$count++;
				}
			}
		}

		if ($count == $group_count) {
			foreach my $member_index (0..5) {
				my $group_member = $client->GetGroup()->GetMember($member_index);
				if (
					$group_member && 
					$group_member->IsClient()
				) {
					$group_member->SetEntityVariable("Loot", -1);
				}
			}
		}
	} elsif ($client->GetRaid()) {
		foreach my $member_index (0..71) {
			my $raid_member = $client->GetRaid()->GetMember($member_index);
			if (
				$raid_member && 
				$raid_member->IsClient()
			) {
				if (!$raid_member->EntityVariableExists("Loot") || 
					(
						$raid_member->EntityVariableExists("Loot") &&
						$raid_member->GetEntityVariable("Loot") == -1
					)
				) {
					$members{$member_index} = 1;
				} elsif (
					$raid_member->EntityVariableExists("Loot") &&
					$raid_member->GetEntityVariable("Loot") > 0
				) {
					$count++;
				}
			}
		}

		if ($count == $group_count) {
			foreach my $member_index (0..71) {
				my $raid_member = $client->GetRaid()->GetMember($member_index);
				if (
					$raid_member && 
					$raid_member->IsClient()
				) {
					$raid_member->SetEntityVariable("Loot", -1);
				}
			}
		}
	}
	return %members;
}

# plugin::AddMoney($client, $value);
sub AddMoney {
	my (
		$client,
		$value,
	) = (
		shift,
		shift
	);
	my $platinum_value = ($value * 1000);
	my $loot_check = plugin::Data($client, 3, "Loot-Clicky");
	if ($loot_check > 0 && $client->GetZoneID() != 183) {
		$platinum_value *= $loot_check;
	}
	my (
		$platinum,
		$gold,
		$silver,
		$copper,
	) = plugin::ConvertMoney($platinum_value);
	my $platinum_string = plugin::commify($platinum);
	plugin::ClientColorMessage(
		$client,
		285,
		"You loot $platinum_string Platinum, $gold Gold, $silver Silver, and $copper Copper from the corpse.")
	;
	$client->AddMoneyToPP($copper, $silver, $gold, $platinum, 1);
}

# plugin::ConvertMoney($value);
sub ConvertMoney {
	my $value = shift;
	my (
		$platinum,
		$gold,
		$silver,
		$copper,
	) = (
		0,
		0,
		0,
		0,
	);
	if ($value >= 1000) {
		while ($value > 1000) {
			$value -= 1000;
			$platinum++;
		}
	}
	
	if ($value >= 100) {
		while ($value > 100) {
			$value -= 100;
			$gold++;
		}
	}
	
	if ($value >= 10) {
		while ($value > 10) {
			$value -= 10;
			$silver++;
		}
	}
	
	if ($value > 0) {
		$value--;
		$copper++;
	}
	return (
		$platinum,
		$gold,
		$silver,
		$copper
	);
}

# plugin::GetCurrency($client, $currency_id);
sub GetCurrency {
	my (
		$client,
		$currency_id,
	) = (
		shift,
		shift,
	);
	return $client->GetAlternateCurrencyValue($currency_id);
}

# plugin::GetPlatinum($client);
sub GetPlatinum {
	my $client = shift;
	my $client_platinum = 0;
	$client_platinum += $client->GetMoney(3, 0);
	$client_platinum += ($client->GetMoney(2, 0) / 10);
	$client_platinum += ($client->GetMoney(1, 0) / 100);
	$client_platinum += ($client->GetMoney(0, 0) / 1000);
	return $client_platinum;
}

# plugin::TakeCurrency($client, $currency_id, $currency_value);
sub TakeCurrency {
	my (
		$client,
		$currency_id,
		$currency_value,
	) = (
		shift,
		shift,
		shift,
	);
	my $previous_value = plugin::GetCurrency($client, $currency_id);
	if ($previous_value >= $currency_value && $currency_value > 0) {
		my $new_value = ($previous_value - $currency_value);
		my $currency_value_string = plugin::commify($currency_value);
		my $currency_link = quest::varlink(
			quest::getcurrencyitemid($currency_id)
		);
		$client->SetAlternateCurrencyValue($currency_id, $new_value);
		plugin::ClientMessage($client, "You lost $currency_value_string $currency_link.");
	}
}

# plugin::TakePlatinum($client, $platinum);
sub TakePlatinum {
	my (
		$client,
		$platinum,
	) = (
		shift,
		shift,
	);
	my $copper = ($platinum * 1000);
	my $max_copper = 2000000000;
	if (
		$client->GetMoney(3, 0) >= $platinum ||
		($client->GetMoney(2, 0) / 10) >= $platinum ||
		($client->GetMoney(1, 0) / 100) >= $platinum ||
		($client->GetMoney(0, 0) / 1000) >= $platinum
	) {
		if ($copper > $max_copper) {
			while ($copper >= $max_copper) {
				$copper -= $max_copper;
				$client->TakeMoneyFromPP($max_copper, 1);
			}
		}

		if ($copper > 0) {
			$client->TakeMoneyFromPP($copper, 1);
		}
	}
}