sub BuySource {
	my $client = plugin::val('client');
	my $client_name = $client->GetCleanName();
	my $emblem = plugin::ProgressionEmblems();
	my $currency_id = quest::getcurrencyid($emblem);
	my $class_source = ClassSource(0);
	my $crystal_type = plugin::GetCrystalType(2);
	my (
		$before_crystals,
		$before_shards,
		$before_aa_points,
		$before_platinum,
	) = (
		plugin::GetCrystalType(1),
		plugin::GetCurrency($client, $currency_id),
		$client->GetAAPoints(),
		plugin::GetPlatinum($client),
	);
	if (
		$before_crystals >= 500 &&
		$before_shards >= 25 && 
		$before_aa_points >= 25 && 
		$before_platinum >= 1000000
	) {
		plugin::TakeCurrency($client, $currency_id, 25);
		plugin::AddCrystals($client, $crystal_type, 1, 500);
		plugin::TakeAAPoints($client, 25);
		plugin::TakePlatinum($client, 1000000);
		quest::summonitem($class_source);
		plugin::Whisper("It seems you are a worthy adversary indeed $client_name, I have harnessed your raw power into a powerful item.");
		if ($client->Admin() != 255) {
			plugin::GearAnnounce($class_source);
		}
		my (
			$after_crystals,
			$after_shards,
			$after_aa_points,
			$after_platinum,
		) = (
			plugin::GetCrystalType(1),
			plugin::GetCurrency($client, $currency_id).
			$client->GetAAPoints(),
			plugin::GetPlatinum($client),
		);
		plugin::LogSource(
			$class_source,
			$before_shards, 
			$after_shards,
			$before_crystals, 
			$after_crystals,
			$before_aa_points, 
			$after_aa_points,
			$before_platinum,
			$after_platinum
		);
		return;
	} else {
		plugin::Whisper("You do not have what I require, do not waste time!");
		return;
	}
	plugin::Whisper("You do not have what I require, do not waste time!");
	return;
}

sub SourceRanksHash {
	my %source_ranks_hash = (
		1 => [[167116..167131], 50, 50, 1000, 1100000],
		2 => [[167132..167147], 100, 100, 1500, 1200000],
		3 => [[167148..167163], 150, 150, 2000, 1300000],
		4 => [[167164..167179], 200, 200, 2500, 1400000],
		5 => [[167180..167195], 250, 250, 3000, 1500000],
		6 => [[167196..167211], 300, 300, 3500, 1600000],
		7 => [[167212..167227], 350, 350, 4000, 1700000],
		8 => [[167228..167243], 400, 400, 4500, 1800000],
		9 => [[167244..167259], 500, 500, 5000, 2000000],
	);
	return %source_ranks_hash;
}

sub UpgradeSource {
	my $client = plugin::val('client');
	my $class_source = plugin::ClassSource(0);
	my @class_source_ranks = plugin::ClassSource(1);
	my %source_ranks_hash = plugin::SourceRanksHash();
	my $emblem = plugin::ProgressionEmblems();
	my $currency_id = quest::getcurrencyid($emblem);
	my $crystal_type = plugin::GetCrystalType(2);
	my (
		$before_crystals,
		$before_shards,
		$before_aa_points,
		$before_platinum,
	) = (
		plugin::GetCrystalType(1),
		plugin::GetCurrency($client, $currency_id),
		$client->GetAAPoints(),
		plugin::GetPlatinum($client),
	);
	if (quest::countitem($class_source) > 0) {
		my $next_source = ($class_source + 16);
		my $next_source_link = quest::varlink($next_source);
		foreach my $rank (keys %source_ranks_hash) {
			my @source_items = @{$source_ranks_hash{$rank}[0]};
			if ($next_source ~~ @source_items) {
				my (
					$emblems,
					$aa_points,
					$crystals,
					$platinum
				) = (
					$source_ranks_hash{$rank}[1],
					$source_ranks_hash{$rank}[2],
					$source_ranks_hash{$rank}[3],
					$source_ranks_hash{$rank}[4],
				);
				if (
					$before_shards >= $emblems &&
					$before_crystals >= $crystals &&
					$before_aa_points >= $aa_points &&
					$before_platinum >= $platinum
				) {
					plugin::AddCrystals($client, $crystal_type, 1, $crystals);
					plugin::TakeCurrency($client, $currency_id, $emblems);
					quest::removeitem($class_source, 1);
					plugin::TakeAAPoints($client, $aa_points);
					plugin::TakePlatinum($client, $platinum);
					quest::summonitem($next_source);
					plugin::Whisper(
						"I have successfully crafted a $next_source_link.
						I'm sure you'll feel more powerful any moment now."
					);
					if ($client->Admin() != 255) {
						plugin::GearAnnounce($next_source);
					}
					my (
						$after_crystals,
						$after_shards,
						$after_aa_points,
						$after_platinum,
					) = (
						plugin::GetCrystalType(1),
						plugin::GetCurrency($client, $currency_id).
						$client->GetAAPoints(),
						plugin::GetPlatinum($client),
					);
					plugin::LogSource(
						$next_source,
						$before_shards, 
						$after_shards,
						$before_crystals, 
						$after_crystals,
						$before_aa_points, 
						$after_aa_points,
						$before_platinum,
						$after_platinum
					);
					return;
				} else {
					plugin::Whisper("You do not have what I require, do not waste time!");
					return;
				}
			}
		}
	} else {
		foreach my $class_source_rank (@class_source_ranks) {
			if (quest::countitem($class_source_rank) > 0) {				
				my $next_source = ($class_source_rank + 16);
				my $next_source_link = quest::varlink($next_source);
				foreach my $rank (keys %source_ranks_hash) {
					my @source_items = @{$source_ranks_hash{$rank}[0]};
					if ($next_source ~~ @source_items) {
						my (
							$emblems,
							$aa_points,
							$crystals,
							$platinum
						) = (
							$source_ranks_hash{$rank}[1],
							$source_ranks_hash{$rank}[2],
							$source_ranks_hash{$rank}[3],
							$source_ranks_hash{$rank}[4],
						);
						if (
							$before_shards >= $emblems &&
							$before_crystals >= $crystals &&
							$before_aa_points >= $aa_points &&
							$before_platinum >= $platinum
						) {
							plugin::AddCrystals($client, plugin::GetCrystalType(2), 1, $crystals);
							plugin::TakeCurrency($client, quest::getcurrencyid($emblem), $emblems);
							quest::removeitem($class_source_rank, 1);
							plugin::TakeAAPoints($client, $aa_points);							
							plugin::TakePlatinum($client, $platinum);
							quest::summonitem($next_source);
							plugin::Whisper(
								"I have successfully crafted a $next_source_link.
								I'm sure you'll feel more powerful any moment now."
							);
							if ($client->Admin() != 255) {
								plugin::GearAnnounce($next_source);
							}
							my (
								$after_crystals,
								$after_shards,
								$after_aa_points,
								$after_platinum,
							) = (
								plugin::GetCrystalType(1),
								plugin::GetCurrency($client, $currency_id).
								$client->GetAAPoints(),
								plugin::GetPlatinum($client),
							);
							plugin::LogSource(
								$next_source,
								$before_shards, 
								$after_shards,
								$before_crystals, 
								$after_crystals,
								$before_aa_points, 
								$after_aa_points,
								$before_platinum,
								$after_platinum
							);
							return;
						} else {
							plugin::Whisper("You do not have what I require, do not waste time!");
							return;
						}
					}
				}
			}
		}
	}
	plugin::Whisper("You do not have what I require, do not waste time!");
	return;
}

sub ClassSource {
	my $client = plugin::val('client');
	my $type = shift;
	my %source_ranks_hash = plugin::SourceRanksHash();
	if ($type == 0) {
		my @sources = (167100..167115);
		foreach my $source_item (@sources) {
			if ($client->CanClassEquipItem($source_item)) {
				return $source_item;
			}
		}
	} elsif ($type == 1) {
		my @sources = ();
		my $index = 0;
		foreach my $rank (keys %source_ranks_hash) {
			my @source_items = @{$source_ranks_hash{$rank}[0]};
			foreach my $source_item (@source_items) {
				if ($client->CanClassEquipItem($source_item)) {
					$sources[$index] = $source_item;
					$index++;
				}
			}
		}
		return @sources;
	}
	return 0;
}

sub SourceRanks {
	my %source_ranks_hash = plugin::SourceRanksHash();
	my @class_source_ranks = plugin::ClassSource(1);
	my $rank = 1;
	foreach my $item (sort {$a <=> $b} @class_source_ranks) {
		my $item_link = quest::varlink($item);
		my $view_link = quest::saylink("view $rank", 1, "View");
		plugin::Message("= | $item_link | $view_link");
		$rank++;
	}
}