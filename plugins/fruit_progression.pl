# plugin::FruitItem();
sub FruitItem {
	my $class = plugin::val('class');
	my %items = (
		"Warrior" => 169200,
		"Cleric" => 169201,
		"Paladin" => 169202,
		"Ranger" => 169203,
		"Shadowknight" => 169204,
		"Druid" => 169205,
		"Monk" => 169206,
		"Bard" => 169207,
		"Rogue" => 169208,
		"Shaman" => 169209,
		"Necromancer" => 169210,
		"Wizard" => 169211,
		"Magician" => 169212,
		"Enchanter" => 169213,
		"Beastlord" => 169214,
		"Berserker" => 169215,
	);
	return $items{$class};
}

# plugin::FruitRanks();
sub FruitRanks {
	my $fruit_item = plugin::FruitItem();
	my $emblem = plugin::ProgressionEmblems();
	my $fruit_link = quest::varlink($fruit_item);
	my $emblem_link = quest::varlink($emblem);
	my $crystal_id = plugin::GetCrystalType(2) eq "Ebon" ? 40902 : 40903;
	my $crystal_link = quest::varlink($crystal_id);
	my (
		$item_one_link,
		$item_two_link,
		$item_three_link,
		$item_four_link,
		$item_five_link,
	) = (
		quest::varlink(169100),
		quest::varlink(169101),
		quest::varlink(169102),
		quest::varlink(169103),
		quest::varlink(169104),
	);
	plugin::Message("= | $fruit_link");
	plugin::Message(
		"== | 
		1,000 $emblem_link,
		1,000 AA Points,
		1,000 $crystal_link,
		100 $item_one_link, 
		100 $item_two_link, 
		100 $item_three_link, 
		100 $item_four_link, 
		and 100 $item_five_link."
	);
}

# plugin::ProduceFruit();
sub ProduceFruit {
	my $client = plugin::val('client');
	my (
		$item_one_currency_id,
		$item_two_currency_id,
		$item_three_currency_id,
		$item_four_currency_id,
		$item_five_currency_id,
	) = (
		quest::getcurrencyid(169100),
		quest::getcurrencyid(169101),
		quest::getcurrencyid(169102),
		quest::getcurrencyid(169103),
		quest::getcurrencyid(169104),
	);
	my (
		$before_item_one,
		$before_item_two,
		$before_item_three,
		$before_item_four,
		$before_item_five,
	) =	(
		plugin::GetCurrency($client, $item_one_currency_id),
		plugin::GetCurrency($client, $item_two_currency_id),
		plugin::GetCurrency($client, $item_three_currency_id),
		plugin::GetCurrency($client, $item_four_currency_id),
		plugin::GetCurrency($client, $item_five_currency_id),
	);
	my $emblem = plugin::ProgressionEmblems();
	my $currency_id = quest::getcurrencyid($emblem);
	my $fruit_item = plugin::FruitItem();
	my $fruit_link = quest::varlink($fruit_item);
	my $before_shards = plugin::GetCurrency($client, $currency_id);
	my $before_crystals = plugin::GetCrystalType(1);
	my $crystal_type = plugin::GetCrystalType(2);
	my $before_aa_points = $client->GetAAPoints();
	if (
		$before_shards >= 1000 &&
		$before_crystals >= 1000 &&
		$before_aa_points >= 1000 &&
		$before_item_one >= 100 &&
		$before_item_two >= 100 &&
		$before_item_three >= 100 &&
		$before_item_four >= 100 &&
		$before_item_five >= 100
	) {
		quest::summonitem($fruit_item, 1);
		plugin::Whisper("I have successfully produced a $fruit_link!");
		if ($client->Admin() != 255) {
			plugin::GearAnnounce($fruit_item);
		}
		plugin::TakeCurrency($client, $currency_id, 1000);
		plugin::TakeCurrency($client, quest::getcurrencyid($_), 100) for (169100..169104);		
		plugin::TakeAAPoints($client, 1000);
		plugin::AddCrystals($client, $crystal_type, 1, 1000);
		my (
			$after_shards,
			$after_crystals,
			$after_aa_points,
			$after_item_one,
			$after_item_two,
			$after_item_three,
			$after_item_four,
			$after_item_five,
		) =	(
			plugin::GetCurrency($client, $currency_id),
			plugin::GetCrystalType(1),
			$client->GetAAPoints(),
			plugin::GetCurrency($client, $item_one_currency_id),
			plugin::GetCurrency($client, $item_two_currency_id),
			plugin::GetCurrency($client, $item_three_currency_id),
			plugin::GetCurrency($client, $item_four_currency_id),
			plugin::GetCurrency($client, $item_five_currency_id),
		);
		plugin::LogFruit(
			$fruit_item,
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
		);
		return 1;
	}
	plugin::Whisper("You do not have the necessary crafting components!");
	return 0;
}