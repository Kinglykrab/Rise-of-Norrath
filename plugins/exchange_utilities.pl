sub ConvertCrystals {
	my $client = plugin::val('client');
	my $crystal = plugin::GetCrystalType(2);
	my $crystal_id = $crystal eq "Ebon" ? 40902 : 40903;
	my $ebon_link = quest::varlink(40902);
	my $radiant_link = quest::varlink(40903);
	my $crystal_link = quest::varlink($crystal_id);
	my (
		$before_ebon,
		$before_radiant,
	) = (
		plugin::GetCrystalType("Ebon"),
		plugin::GetCrystalType("Radiant"),
	);
	my (
		$radiant_crystals,
		$ebon_crystals,
	) = (
		$before_radiant,
		$before_ebon,
	);
	if ($crystal eq "Ebon") {
		if ($radiant_crystals >= 5) {
			my $conversion_crystals = 0;
			while ($radiant_crystals >= 5) {
				$conversion_crystals++;
				$radiant_crystals -= 5;
			}
			my $conversion_value = ($conversion_crystals * 5);
			my $conversion_value_string = plugin::commify($conversion_value);
			my $ebon_crystals_string = plugin::commify($conversion_crystals);
			if ($conversion_crystals > 0) {
				plugin::AddCrystals($client, "Both", 1, 0, $conversion_value, $conversion_crystals);
				plugin::Whisper(
					"I have successfully transmogrified $conversion_value_string $radiant_link into $ebon_crystals_string $crystal_link."
				);
				my (
					$after_ebon,
					$after_radiant,
				) = (
					plugin::GetCrystalType("Ebon"),
					plugin::GetCrystalType("Radiant"),
				);
				plugin::LogCrystalConversion(
					$crystal,
					$before_ebon,
					$after_ebon,
					$before_radiant,
					$after_radiant,
				);
			} else {
				plugin::Whisper("You don't have enough $radiant_link to transmogrify!"); 
			}
		} else {
			plugin::Whisper("You don't have enough $radiant_link to transmogrify!"); 
		}
	} else {
		if ($before_ebon >= 5) {
			my $conversion_crystals = 0;
			while ($before_ebon >= 5) {
				$conversion_crystals++;
				$before_ebon -= 5;
			}
			my $conversion_value = ($conversion_crystals * 5);
			my $conversion_value_string = plugin::commify($conversion_value);
			my $radiant_crystals_string = plugin::commify($conversion_crystals);
			if ($conversion_crystals > 0) {
				plugin::AddCrystals(
					$client,
					"Both", 
					0, 
					1, 
					$conversion_crystals, 
					$conversion_value
				);
				plugin::Whisper(
					"I have successfully transmogrified $conversion_value_string $ebon_link into $radiant_crystals_string $crystal_link."
				);
				my (
					$after_ebon,
					$after_radiant,
				) = (
					plugin::GetCrystalType("Ebon"),
					plugin::GetCrystalType("Radiant"),
				);
				plugin::LogCrystalConversion(
					$crystal,
					$before_ebon,
					$after_ebon,
					$before_radiant,
					$after_radiant,
				);
			} else {
				plugin::Whisper("You don't have enough $ebon_link to transmogrify!"); 
			}
		} else {
			plugin::Whisper("You don't have enough $ebon_link to transmogrify!"); 
		}
	}
}

# plugin::ExchangeEpic();
sub ExchangeEpic {
	my $itemcount = plugin::var('itemcount');
	my @epic_items_array = EpicItems();
	my $next = 0;
	foreach my $epic_item (@epic_items_array) {
		if (defined $itemcount->{$epic_item}) {
			if ($epic_item ~~ [150000..150002]) {
				$next = $epic_item == 150002 ? 150000 : ($epic_item + 1);
			} elsif ($epic_item ~~ [150004, 150005]) {
				$next = $epic_item == 150004 ? 150005 : 150004;
			} elsif ($epic_item ~~ [150008, 150009]) {
				$next = $epic_item == 150008 ? 150009 : 150008;
			} elsif ($epic_item ~~ [150006, 150007, 150022]) {
				if ($epic_item == 150006) {
					$next = 150007;
				} elsif ($epic_item == 150007) {
					$next = 150022;
				} elsif ($epic_item == 150022) {
					$next = 150006;
				}
			} elsif ($epic_item ~~ [150019, 150020]) {
				$next = $epic_item == 150019 ? 150020 : 150019;
			} elsif ($epic_item ~~ [151002, 151003]) {
				$next = $epic_item == 151002 ? 151003 : 151002;
			} elsif ($epic_item ~~ [151004, 151005]) {
				$next = $epic_item == 151004 ? 151005 : 151004;
			} elsif ($epic_item ~~ [151006, 151007]) {
				$next = $epic_item == 151006 ? 151007 : 151006;
			} elsif ($epic_item ~~ [152002, 152003]) {
				$next = $epic_item == 152002 ? 152003 : 152002;
			} elsif ($epic_item ~~ [152004, 152005]) {
				$next = $epic_item == 152004 ? 152005 : 152004;
			} elsif ($epic_item ~~ [152006, 152007]) {
				$next = $epic_item == 152006 ? 152007 : 152006;
			} elsif ($epic_item ~~ [153002, 153003]) {
				$next = $epic_item == 153002 ? 153003 : 153002;
			} elsif ($epic_item ~~ [153004, 153005]) {
				$next = $epic_item == 153004 ? 153005 : 153004;
			} elsif ($epic_item ~~ [153006, 153007]) {
				$next = $epic_item == 153006 ? 153007 : 153006;
			}
			if ($next != 0) {
				delete $itemcount->{$epic_item};
				quest::summonitem($next);
				plugin::Whisper("You have successfully exchanged your Epic.");
				return 1;
			}
		}
	}
	return 0;
}

# plugin::ExchangeLoyalty($amount);
sub ExchangeLoyalty {
	my $amount = shift;
	my $client = plugin::val('client');
	my $cost_platinum = (500000 * $amount);
	my $cost_platinum_string = plugin::commify($cost_platinum);
	my $loyalty_link = quest::varlink(300);
	my $before_platinum = plugin::GetPlatinum($client);
	if ($before_platinum >= $cost_platinum) {
		plugin::TakePlatinum($client, $cost_platinum);
		quest::summonitem(300, $amount);
		plugin::Whisper("I have exchanged $cost_platinum_string Platinum for $amount $loyalty_link.");
		my $after_platinum = plugin::GetPlatinum($client);
		plugin::LogLoyaltyConversion($amount, $before_platinum, $after_platinum);
	} else {
		plugin::Whisper("You do not have enough Platinum!");
	}
}


# plugin::ExchangeMold($type, $tier);
# plugin::ExchangeMold($type, $mold);
sub ExchangeMold {
	my $type = shift;
	my %molds_cost_hash = (
		1 => [166000..166006],
		2 => [166007..166013],
		3 => [166014..166020],
		4 => [166021..166027],
		5 => [166028..166034],
		6 => [166035..166041],
		7 => [166042..166048],
		8 => [166049..166055],
		9 => [166056..166062],
		10 => [166063..166069],
		11 => [166070..166076],
		12 => [166077..166083],
		13 => [166084..166090],
		14 => [166091..166097],
		15 => [166098..166104],
		16 => [166105..166111],
		17 => [166112..166118],
		18 => [166119..166125],
		19 => [166126..166132],
		20 => [166133..166139],
	);
	my $client = plugin::val('client');
	my $mold_exchanged = 0;
	if ($type == 0) {
		my $tier = shift;
		my @mold_items = @{$molds_cost_hash{$tier}};
		my $index = 1;
		my $tier_mold_link = quest::saylink("Tier $tier Molds", 1);
		plugin::Message("= | $tier_mold_link");
		foreach my $mold_item (@mold_items) {
			my $mold_link = quest::varlink($mold_item);
			my $exchange_link = quest::saylink("exchange $mold_item", 1, "Exchange");
			plugin::Message("== | $index. $mold_link | $exchange_link");
			$index++;
		}
		$mold_exchanged = 1;
	} elsif ($type == 1) {
		my $exchange_id = plugin::Data($client, 3, "Exchange");
		my $mold = shift;
		if ($exchange_id != 0) {
			my $mold_link = quest::varlink($mold);
			quest::summonitem($mold, 1);
			plugin::Whisper("I have successfully exchanged your molds for a $mold_link.");
			plugin::Data($client, 0, "Exchange");
			$mold_exchanged = 1;
		}
		plugin::Whisper("I cannot exchange for you, I need molds!");
	}
	return $mold_exchanged;
}

# plugin::ExchangePlatinum($data);
sub ExchangePlatinum {
	my $data = shift;
	my (
		$price,
		$type
	) = split(/ /, $data);
	my $client = plugin::val('client');
	my $emblem = plugin::ProgressionEmblems();
	my $emblem_link = quest::varlink($emblem);
	my $currency_id = quest::getcurrencyid($emblem);
	my $crystal_type = plugin::GetCrystalType(2);
	my $crystal_id = $crystal_type eq "Ebon" ? 40902 : 40903;
	my $crystal_link = quest::varlink($crystal_id);
	my %types_hash = (	
		1000000 => [10, 50, 100],
		2500000 => [25, 125, 250],
		5000000 => [50, 250, 500],
	);
	my (
		$before_shards,
		$before_crystals,
		$before_platinum,
	) = (
		plugin::GetCurrency($client, $currency_id),
		plugin::GetCrystalType(1),
		plugin::GetPlatinum($client),
	);
	if ($before_platinum >= $price) {
		plugin::TakePlatinum($client, $price);
		my $amount = $types_hash{$price}[$type];
		my $price_string = plugin::commify($price);
		my $amount_string = plugin::commify($amount);
		if ($type == 0) {
			plugin::AddCurrency($client, $currency_id, $amount);
			plugin::Whisper("I have successfully converted $price_string Platinum in to $amount_string $emblem_link.");
		} elsif ($type == 1) {
			plugin::AddCrystals($client, $crystal_type, 0, $amount);
			plugin::Whisper("I have successfully converted $price_string Platinum in to $amount_string $crystal_link.");
		} elsif ($type == 2) {
			plugin::AddAAPoints($client, $amount);
			plugin::Whisper("I have successfully converted $price_string Platinum in to $amount_string AA Points.");
		}
		my (
			$after_shards,
			$after_crystals,
			$after_platinum,
		) = (
			plugin::GetCurrency($client, $currency_id),
			plugin::GetCrystalType(1),
			plugin::GetPlatinum($client),
		);
		plugin::LogPlatinumConversion(
			$amount, 
			$before_shards, 
			$after_shards, 
			$before_crystals, 
			$after_crystals, 
			$before_platinum, 
			$after_platinum
		);
	} else {
		plugin::Whisper("You don't have enough Platinum to exchange!");
	}
}

# plugin::ExchangeShard();
sub ExchangeShard {
	my %class_emblems = (
		167000 => 0,
		167001 => 0,
		167002 => 0,
		167003 => 0,
		167004 => 0,
		167005 => 0,
		167006 => 0,
		167007 => 0,
		167008 => 0,
		167009 => 0,
		167010 => 0,
		167011 => 0,
		167012 => 0,
		167013 => 0,
		167014 => 0,
		167015 => 0,
	);
	my $client = plugin::val('client');
	my @class_emblem_ids = (167000..167015);
	my $amount = 0;
	my $emblem = plugin::ProgressionEmblems();
	my $emblem_link = quest::varlink($emblem);
	my $currency_id = quest::getcurrencyid($emblem);
	my $before_shards = plugin::GetCurrency($client, $currency_id);
	my $convert_amount = 0;
	foreach my $class_emblem (@class_emblem_ids) {		
		my $class_currency_id = quest::getcurrencyid($class_emblem);
		my $class_currency_value = plugin::GetCurrency($client, $class_currency_id);
		my $currency_amount = 0;
		if ($class_emblem != $emblem) {
			if ($class_currency_value >= 10) {
				my $currency_value = $class_currency_value;
				while ($currency_value >= 10) {
					$currency_value -= 10;
					$amount++;
					$currency_amount += 10;
				}
				if ($class_currency_value >= $currency_amount) {
					$class_emblems{$class_emblem} = $currency_amount;
					$convert_amount += $currency_amount;
					$client->SetAlternateCurrencyValue(
						$class_currency_id, 
						($class_currency_value - $currency_amount)
					);
				}
			}
		}
	}
	
	if ($amount > 0) {
		my $amount_string = plugin::commify($amount);
		my $amount_convert_string = plugin::commify($convert_amount);
		plugin::Whisper(
			"I have successfully exchanged your shards! 
			$amount_convert_string of your shards for $amount_string $emblem_link."
		);
		plugin::AddCurrency($client, $currency_id, $amount);
		my $after_shards = plugin::GetCurrency($client, $currency_id);
		plugin::LogShardConversion($convert_amount, $before_shards, $after_shards);
	} elsif ($amount == 0) {
		plugin::Whisper("You have no shards to exchange!");
	}
}