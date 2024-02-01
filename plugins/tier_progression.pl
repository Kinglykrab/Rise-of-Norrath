sub Tier {
	my %tiers = (
		1 => "One",
		2 => "Two",
		3 => "Three",
		4 => "Four",
		5 => "Five",
		6 => "Six",
		7 => "Seven",
		8 => "Eight",
		9 => "Nine",
		10 => "Ten",
		11 => "Eleven",
		12 => "Twelve",
		13 => "Thirteen",
		14 => "Fourteen",
		15 => "Fifteen",
		16 => "Sixteen",
		17 => "Seventeen",
		18 => "Eighteen",
		19 => "Nineteen",
		20 => "Twenty",
	);
	my $tier = shift;
	return ($tier ~~ [1..20] ? $tiers{$tier} : "Zero");
}

sub ProgressionItems {
	my $class = plugin::val('class');
	my %items = (
		"Warrior" =>
		[
			180000..180069, 182014..182020, 182056..182062,
			182098..182104, 182140..182146, 182182..182188,
			182224..182230, 182266..182272, 182308..182314,
			182350..182356, 182392..182398
		],
		"Cleric" =>
		[
			180070..180139, 182014..182020, 182056..182062,
			182098..182104, 182140..182146, 182182..182188,
			182224..182230, 182266..182272, 182308..182314,
			182350..182356, 182392..182398
		],
		"Paladin" =>
		[
			180140..180209, 182014..182020, 182056..182062,
			182098..182104, 182140..182146, 182182..182188,
			182224..182230, 182266..182272, 182308..182314,
			182350..182356, 182392..182398
		],
		"Ranger" => 
		[
			180210..180279, 182007..182013, 182049..182055,
			182091..182097, 182133..182139, 182175..182181,
			182217..182223, 182259..182265, 182301..182307,
			182343..182349, 182385..182391
		],
		"Shadowknight" => 
		[
			180280..180349, 182014..182020, 182056..182062,
			182098..182104, 182140..182146, 182182..182188,
			182224..182230, 182266..182272, 182308..182314,
			182350..182356, 182392..182398
		],
		"Druid" => 
		[
			180350..180419, 182021..182027, 182063..182069,
			182105..182111, 182147..182153, 182189..182195,
			182231..182237, 182273..182279, 182315..182321,
			182357..182363, 182399..182405
		],
		"Monk" => 
		[
			180420..180489, 182021..182027, 182063..182069,
			182105..182111, 182147..182153, 182189..182195,
			182231..182237, 182273..182279, 182315..182321,
			182357..182363, 182399..182405
		],
		"Bard" => 
		[
			180490..180559, 182014..182020, 182056..182062,
			182098..182104, 182140..182146, 182182..182188,
			182224..182230, 182266..182272, 182308..182314,
			182350..182356, 182392..182398
		],
		"Rogue" => 
		[
			180560..180629, 182007..182013, 182049..182055,
			182091..182097, 182133..182139, 182175..182181,
			182217..182223, 182259..182265, 182301..182307,
			182343..182349, 182385..182391
		],
		"Shaman" => 
		[
			180630..180699, 182007..182013, 182049..182055,
			182091..182097, 182133..182139, 182175..182181,
			182217..182223, 182259..182265, 182301..182307,
			182343..182349, 182385..182391
		],
		"Necromancer" => 
		[
			180700..180769, 182000..182006, 182042..182048,
			182084..182090, 182126..182132, 182168..182174,
			182210..182216, 182252..182258, 182294..182300,
			182336..182342, 182378..182384
		],
		"Wizard" => 
		[
			180770..180839, 182000..182006, 182042..182048,
			182084..182090, 182126..182132, 182168..182174,
			182210..182216, 182252..182258, 182294..182300,
			182336..182342, 182378..182384
		],
		"Magician" => 
		[
			180840..180909, 182000..182006, 182042..182048,
			182084..182090, 182126..182132, 182168..182174,
			182210..182216, 182252..182258, 182294..182300,
			182336..182342, 182378..182384
		],
		"Enchanter" => 
		[
			180910..180979, 182000..182006, 182042..182048,
			182084..182090, 182126..182132, 182168..182174,
			182210..182216, 182252..182258, 182294..182300,
			182336..182342, 182378..182384
		],
		"Beastlord" => 
		[
			180980..181049, 182021..182027, 182063..182069,
			182105..182111, 182147..182153, 182189..182195,
			182231..182237, 182273..182279, 182315..182321,
			182357..182363, 182399..182405
		],
		"Berserker" => 
		[
			181050..181119, 182007..182013, 182049..182055,
			182091..182097, 182133..182139, 182175..182181,
			182217..182223, 182259..182265, 182301..182307,
			182343..182349, 182385..182391
		]
	);
	return @{$items{$class}};
}

sub ListTierItems {
	my $client = plugin::val('client');
	my $tier = shift;
	my $status = plugin::val('status');
	my @items_array = ProgressionItems();
	my (
		$tier_begin,
		$tier_end
	) = plugin::TierIndex($tier);	
	my $index = 1;
	my $tier_flag = plugin::Data($client, 3, "Progression");
	if (($tier_flag > 0 && $tier_flag >= $tier) || $tier == 1 || $status >= 80) {
		for (my $tier_item = $tier_begin; $tier_item <= $tier_end; $tier_item++) {
			my $tier_check = ($tier_item % 7 == 0);
			my $item_id = $items_array[$tier_item];
			if ($tier_check) {
				my $tier = (
					$tier_item == 0 ? 
					1 : 
					(
						($tier_item / 7) + 1
					)
				);
				plugin::Message("= | Tier " . plugin::Tier($tier));
			}
			plugin::Message("== | $index. " . quest::varlink($item_id) . " | " . quest::saylink("recipe $item_id", 1, "View"));
			$index++;
		}
	}
}

sub TierIndex {
	my %tier_index_hash = (
		1 => [0, 6],
		2 => [7, 13],
		3 => [14, 20],
		4 => [21, 27],
		5 => [28, 34],
		6 => [35, 41],
		7 => [42, 48],
		8 => [49, 55],
		9 => [56, 62],
		10 => [63, 69],
		11 => [70, 76],
		12 => [77, 83],
		13 => [84, 90],
		14 => [91, 97],
		15 => [98, 104],
		16 => [105, 111],
		17 => [112, 118],
		18 => [119, 125],
		19 => [126, 132],
		20 => [133, 139],
	);
	my $tier = shift;
	return @{$tier_index_hash{$tier}};
}

sub ListTierRecipe {
	my $recipe = shift;
	my %items_cost_hash = plugin::ItemsCostHash();
	my @items_array = ProgressionItems();
	my $emblem = ProgressionEmblems();
	foreach my $tier (sort {$a <=> $b} keys %items_cost_hash) {
		foreach my $mold (@{$items_cost_hash{$tier}[0]}) {
			my $index = ($mold - 166000);
			my $previous_index = ($index ~~ [0..69, 77..139]) ? ($index - 7) : ElevenToTen($index);
			my $item_id = $items_array[$index];
			my $item_link = quest::varlink($item_id);
			my $tier_shard_id = ($tier >= 10 ? ($tier - 9) : 0);
			my $tier_shard_link = ($tier_shard_id > 0 ? quest::varlink($tier_shard_id) : 0);
			my $previous_item_id = ($index ~~ [0..6] ? 0 : $items_array[$previous_index]);
			my $previous_link = ($previous_item_id != 0 ? quest::varlink($previous_item_id) : "");
			my $mold_link = quest::varlink($mold);
			my $emblem_link = quest::varlink($emblem);
			my $crystal_id = plugin::GetCrystalType(2) eq "Ebon" ? 40902 : 40903;
			my $crystal_link = quest::varlink($crystal_id);
			my $craft_link = quest::saylink("upgrade $recipe", 1, "Craft");
			my (
				$emblems,
				$aa_points,
				$crystals,
				$tier_shards,
			) = (
				$items_cost_hash{$tier}[1],
				$items_cost_hash{$tier}[2],
				$items_cost_hash{$tier}[3],
				($tier >= 10 ? $items_cost_hash{$tier}[1] : 0),
			);
			my (
				$emblems_string,
				$aa_points_string,
				$crystals_string,
				$tier_shards_string,
			) = (
				plugin::commify($emblems),
				plugin::commify($aa_points),
				plugin::commify($crystals),
				plugin::commify($tier_shards),
			);
			if ($item_id == $recipe) {
				plugin::Message("= | $item_link Requirements");
				if ($aa_points > 0 && $crystals > 0 && $tier_shards > 0) {
					plugin::Message(
						"== | 
						$previous_link, 
						$mold_link, 
						$tier_shards_string $tier_shard_link,
						$emblems_string $emblem_link, 
						$aa_points_string AA Points, and 
						$crystals_string $crystal_link
						"
					);
				} elsif ($aa_points > 0 && $crystals > 0 && $tier_shards == 0) {
					plugin::Message(
						"== | 
						$previous_link, 
						$mold_link, 
						$tier_shards_string $tier_shard_link,
						$emblems_string $emblem_link, 
						$aa_points_string AA Points, and 
						$crystals_string $crystal_link
						"
					);
				} elsif ($aa_points > 0 && $crystals == 0 && $tier_shards == 0) {
					plugin::Message(
						"== | 
						$previous_link, 
						$mold_link, 
						$emblems_string $emblem_link, and 
						$aa_points_string AA Points
						"
					);
				} elsif ($aa_points == 0 && $crystals == 0 && $tier_shards == 0) {
					plugin::Message("== | $mold_link and $emblems_string $emblem_link");
				}
				plugin::Message("=== | $craft_link");
			}
		}
	}
}

sub GearCheck {
	my $tier = shift;
	my @items_array = plugin::ProgressionItems();
	my (
		$min_index,
		$max_index,
	) = plugin::TierIndex($tier);
	my $client = plugin::val('client');
	my $found = 0;
	my $check = 0;
	for (my $index = $min_index; $index <= $max_index; $index++) {
		my $item = $items_array[$index];
		if (quest::countitem($item)) {
			$found++;
		}
	}

	if ($found >= 7) {
		$check = 1;
	}
	return $check;
}

sub ElevenToTen {
	my $index = shift;
	my %index_hash = (
		70 => 66,
		71 => 69,
		72 => 63,
		73 => 67,
		74 => 68,
		75 => 65,
		76 => 64,
	);
	return $index_hash{$index};
}

sub ProgressionEmblems {
	my $class = plugin::val('class');
	my %emblems = (
		"Warrior" => 167000,
		"Cleric" => 167001,
		"Paladin" => 167002,
		"Ranger" => 167003,
		"Shadowknight" => 167004,
		"Druid" => 167005,
		"Monk" => 167006,
		"Bard" => 167007,
		"Rogue" => 167008,
		"Shaman" => 167009,
		"Necromancer" => 167010,
		"Wizard" => 167011,
		"Magician" => 167012,
		"Enchanter" => 167013,
		"Beastlord" => 167014,
		"Berserker" => 167015,
	);
	return $emblems{$class};
}

sub ItemsCostHash {	
	my %items_cost_hash = (
		# Tier => [[Molds], Shards, AA Points, Crystals]
		1 => [[166000..166006], 1, 0, 0],
		2 => [[166007..166013], 2, 10, 0],
		3 => [[166014..166020], 3, 15, 0],
		4 => [[166021..166027], 4, 20, 0],
		5 => [[166028..166034], 5, 25, 10],
		6 => [[166035..166041], 6, 30, 20],
		7 => [[166042..166048], 7, 40, 30],
		8 => [[166049..166055], 8, 50, 40],
		9 => [[166056..166062], 9, 75, 50],
		10 => [[166063..166069], 10, 100, 75],
		11 => [[166070..166076], 12, 100, 100],
		12 => [[166077..166083], 14, 150, 150],
		13 => [[166084..166090], 16, 200, 200],
		14 => [[166091..166097], 18, 250, 250],
		15 => [[166098..166104], 20, 300, 300],
		16 => [[166105..166111], 25, 350, 350],
		17 => [[166112..166118], 30, 400, 400],
		18 => [[166119..166125], 35, 450, 450],
		19 => [[166126..166132], 40, 500, 500],
		20 => [[166133..166139], 50, 750, 750],
	);
	return %items_cost_hash;
}

sub UpgradeItem {
	my $item = shift;
	my %items_cost_hash = plugin::ItemsCostHash();
	my @items_array = plugin::ProgressionItems();
	my $emblem = plugin::ProgressionEmblems();
	my $currency_id = quest::getcurrencyid($emblem);
	my $client = plugin::val('client');
	foreach my $tier (sort {$a <=> $b} keys %items_cost_hash) {
		my (
			$shards,
			$aa_points,
			$crystals,
			$tier_shards,
		) = (
			$items_cost_hash{$tier}[1],
			$items_cost_hash{$tier}[2],
			$items_cost_hash{$tier}[3],
			($tier >= 10 ? $items_cost_hash{$tier}[1] : 0),
		);
		my @mold_items = @{$items_cost_hash{$tier}[0]};
		foreach my $mold (@mold_items) {
			my $index = ($mold - 166000);
			my $previous_index = (
				$index ~~ [0..69, 77..139]? 
				($index - 7) : 
				ElevenToTen($index)
			);
			my $item_id = $items_array[$index];
			my $tier_shard_id = (
				$tier >= 10 ? 
				($tier - 9) : 
				0
			);
			my $tier_shard_currency_id = (
				$tier_shard_id > 0 ? 
				quest::getcurrencyid($tier_shard_id) : 
				0
			);
			my $item_link = quest::varlink($item_id);
			if ($item_id == $item) {
				if ($index >= 7) {
					my $previous_item = $items_array[$previous_index];
					my $previous_check = quest::countitem($previous_item);
					my $mold_check = quest::countitem($mold);
					my $before_shards = plugin::GetCurrency(
						$client,
						$currency_id
					);
					my $before_crystals = plugin::GetCrystalType(1);
					my $before_aas = $client->GetAAPoints();
					my $before_tier_shards = plugin::GetCurrency($client, $tier_shard_currency_id);
					if (
						$previous_check >= 1 &&
						$mold_check >= 1 &&
						$before_shards >= $shards &&
						$before_crystals >= $crystals &&
						$before_aas >= $aa_points &&
						$before_tier_shards >= $tier_shards
					) {
						quest::summonitem($item_id, 1);
						plugin::Whisper("You have successfully crafted your $item_link!");
						if ($client->Admin() != 255) {
							plugin::GearAnnounce($item_id);
						}
						quest::removeitem($_, 1) for ($previous_item, $mold);
						plugin::TakeCurrency($client, $currency_id, $shards);
						if ($aa_points > 0) {
							plugin::TakeAAPoints($client, $aa_points);
						}
						
						if ($crystals > 0) {
							plugin::AddCrystals($client, plugin::GetCrystalType(2), 1, $crystals);
						}
						
						if ($tier_shards > 0) {
							plugin::TakeCurrency($client, $tier_shard_currency_id, $tier_shards);
						}
						my (
							$after_shards,
							$after_crystals,
							$after_aas,
							$after_tier_shards,
						) = (
							plugin::GetCurrency($client, $currency_id),
							plugin::GetCrystalType(1),
							$client->GetAAPoints(),
							plugin::GetCurrency($client, $tier_shard_currency_id),
						);
						plugin::LogArmor(
							$tier, 
							$item_id, 
							$before_shards, 
							$after_shards, 
							$before_crystals, 
							$after_crystals,
							$before_aas, 
							$after_aas, 
							$before_tier_shards,
							$after_tier_shards,
						);
						return 1;
					}
				} else {
					my $mold_check = quest::countitem($mold);
					my $before_shards = plugin::GetCurrency($client, $currency_id);
					my $before_crystals = plugin::GetCrystalType(1);
					my $before_aas = $client->GetAAPoints();
					my $before_tier_shards = plugin::GetCurrency($client, $tier_shard_currency_id);
					if (
						$mold_check >= 1 && 
						$before_shards >= 1
					) {
						quest::summonitem($item_id, 1);
						plugin::Whisper("You have successfully crafted your $item_link!");
						if ($client->Admin() != 255) {
							plugin::GearAnnounce($item_id);
						}
						quest::removeitem($mold, 1);
						plugin::TakeCurrency($client, $currency_id, $shards);
						my (
							$after_shards,
							$after_crystals,
							$after_aas,
							$after_tier_shards,
						) = (
							plugin::GetCurrency($client, $currency_id),
							plugin::GetCrystalType(1),
							$client->GetAAPoints(),
							plugin::GetCurrency($client, $tier_shard_currency_id),
						);
						plugin::LogArmor(
							$tier, 
							$item_id, 
							$before_shards, 
							$after_shards, 
							$before_crystals, 
							$after_crystals,
							$before_aas, 
							$after_aas, 
							$before_tier_shards,
							$after_tier_shards,
						);
						return 1;
					}
				}
			}
		}
	}
	plugin::Whisper("You do not have the necessary crafting components!");
	return 0;
}

sub ProgressionZone {
	my $zonesn = plugin::val('zonesn');
	my $type = shift;
	my @zones = (
		"templeveeshan", "akheva", "bothunder", "crushbone", "frostcrypt",
		"postorms", "discord", "anguish", "codecay", "crystallos",
		"ashengate", "atiiki", "beholder", "deadbone", "mechanotus",
		"redfeather", "roost", "shiningcity", "mseru", "sseru",
	);
	my $zone_tier = 0;
	if ($zonesn ~~ @zones) {
		if ($type == 0) {
			$zone_tier = 1;
		} else {
			for (my $zone_index = 0; $zone_index < $#zones; $zone_index++) {
				if ($zones[$zone_index] eq $zonesn) {
					$zone_tier = ($zone_index + 1);
				}
			}
		}
	}
	return $zone_tier;
}