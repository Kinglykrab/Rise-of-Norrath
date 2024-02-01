sub ExchangeHash {
	my %exchange_hash = (
	0 => [[900..903, 920, 921], [1, 2, 5, 10, 50, 100]],
	1 => [[904..907, 912..915], [5, 10, 25, 50, 100, 500, 1000, 5000]],
	2 => [[908..911, 916..919], [1, 2, 5, 10, 50, 100, 500, 1000]]
	);
	return %exchange_hash;
}

sub MaxIndexArray {
	my @max_index = (6, 8, 8);
	return @max_index;
}

sub EVENT_SAY {
	my %exchange_hash = ExchangeHash();
	my @max_index = MaxIndexArray();
	my @item_types = ("Shard Coupons", "Crystal Coupons", "AA Coupons");
	my ($emblem, $item_id, $item_cost) = (plugin::ProgressionEmblems(), 0, 0);
	my $emblem_link = quest::varlink($emblem);
	my $loyalty_link = quest::varlink(300);
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			plugin::Whisper("Hail $name, I can exchange $loyalty_link in to coupons that you can hand me for various bonuses.");
			foreach my $type (sort {$a <=> $b} keys %exchange_hash) {
				my $item_type = $item_types[$type];
				plugin::Message("= | " . quest::saylink("show $type", 1, $item_type));
			}
		} elsif ($text=~/^Show/i) {
			my $type = substr($text, 5);
			my (
				$item_type,
				$max,
			) = (
				$item_types[$type],
				$max_index[$type],
			);
			plugin::Message("= | $item_type");
			for (my $index = 0; $index < $max; $index++) {			
				(
					$item_id,
					$item_cost,
				) = (
					$exchange_hash{$type}[0][$index],
					($exchange_hash{$type}[1][$index] * 2),
				);
				my $item_link = quest::varlink($item_id);
				my $item_cost_string = plugin::commify($item_cost);
				my $buy_link = quest::saylink("buy $item_id", 1, "Buy");
				plugin::Message("== | $item_link | $item_cost_string $loyalty_link | $buy_link");
			}
		} elsif ($text=~/^Buy/i) {
			my $buy_item_id = substr($text, 4);
			foreach my $type (sort {$a <=> $b} keys %exchange_hash) {
				for (my $index = 0; $index < $max_index[$type]; $index++) {			
					$item_id = $exchange_hash{$type}[0][$index];
					my $item_link = quest::varlink($item_id);
					if ($buy_item_id == $item_id) {
						my $tokens = quest::countitem(300);
						$item_cost = ($exchange_hash{$type}[1][$index] * 2);
						if ($tokens >= $item_cost) {
							quest::removeitem(300, $item_cost);
							quest::summonitem($item_id, 1);
							plugin::Whisper("You have successfully purchased a $item_link!");
						} else {
							plugin::Whisper("You do not have the required amount of $loyalty_link!");
						}
					}
				}
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	my %exchange_hash = ExchangeHash();
	my @max_index = MaxIndexArray();
	my (
		$emblem, 
		$item_id, 
		$item_amount,
	) = (
		plugin::ProgressionEmblems(), 
		0, 
		0,
	);
	my $emblem_link = quest::varlink($emblem);
	my $currency_id = quest::getcurrencyid($emblem);
	my $crystal_type = plugin::GetCrystalType(2);
	my $crystal_id = $crystal_type eq "Ebon" ? 40902 : 40903;
	my $crystal_link = quest::varlink($crystal_id);
	my (
		$before_shards,
		$before_crystals,
		$before_aa_points,
		$before_loyalty,
	) = (
		plugin::GetCurrency($client, $currency_id),
		plugin::GetCrystalType(1),
		$client->GetAAPoints(),
		quest::countitem(300),
	);
	my (
		$after_shards,
		$after_crystals,
		$after_aa_points,
		$after_loyalty,
	) = (
		$before_shards,
		$before_crystals,
		$before_aa_points,
		$before_loyalty,
	);
	foreach my $type (sort {$a <=> $b} keys %exchange_hash) {
		for (my $index = 0; $index < $max_index[$type]; $index++) {
			my (
				$item_id,
				$item_amount,
			) = (
				$exchange_hash{$type}[0][$index],
				($type == 2 ? ($exchange_hash{$type}[1][$index] * 100) : ($exchange_hash{$type}[1][$index] * 10)),
			);
			my $item_link = quest::varlink($item_id);
			my $item_amount_string = plugin::commify($item_amount);
			if (plugin::check_handin(\%itemcount, $item_id => 1)) {
				if ($type == 0) {					
					plugin::AddCurrency($client, $currency_id, $item_amount);
					plugin::Whisper(
						"I have exchanged your $item_link for $item_amount_string $emblem_link."
					);
					$after_shards = plugin::GetCurrency($client, $currency_id);
				} elsif ($type == 1) {
					plugin::AddCrystals($client, $crystal_type, 0, $item_amount);
					plugin::Whisper(
						"I have exchanged your $item_link for $item_amount_string $crystal_link."
					);
					$after_crystals = plugin::GetCrystalType(1);
				} elsif ($type == 2) {
					plugin::AddAAPoints($client, $item_amount);
					plugin::Whisper(
						"I have exchanged your $item_link for $item_amount_string AA Points."
					);
					$after_aa_points = $client->GetAAPoints();
				}
				plugin::LogExchange(
					$item_id, 
					$item_amount, 
					$before_shards, 
					$after_shards, 
					$before_crystals, 
					$after_crystals, 
					$before_aa_points, 
					$after_aa_points,
					$before_loyalty,
					$after_loyalty
				);
			}
		}
	}
	plugin::return_items();
}