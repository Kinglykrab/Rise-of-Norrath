# plugin::EpicItems();
sub EpicItems {
	my $class = plugin::val('class');
	my %items = (
		"Warrior" => [150000..150002, 151000, 152000, 153000],
		"Cleric" => [150003, 151001, 152001, 153001],
		"Paladin" => [150004, 150005, 151002, 151003, 152002, 152003, 153002, 153003],
		"Ranger" => [150006, 150007, 150022, 151004, 151005, 152004, 152005, 153004, 153005], 
		"Shadowknight" => [150008, 150009, 151006, 151007, 152006, 152007, 153006, 153007], 
		"Druid" => [150010, 151008, 152008, 153008],
		"Monk" => [150011, 151009, 152009, 153009],
		"Bard" => [150012, 151010, 152010, 153010],
		"Rogue" => [150013, 151011, 152011, 153011],
		"Shaman" => [150014, 151012, 152012, 153012],
		"Necromancer" => [150015, 151013, 152013, 153013],
		"Wizard" => [150016, 151014, 152014, 153014],
		"Magician" => [150017, 151015, 152015, 153015],
		"Enchanter" => [150018, 151016, 152016, 153016],
		"Beastlord" => [150019, 150020, 151017, 152017, 153017],
		"Berserker" => [150021, 151018, 152018, 153018]
	);
	return @{$items{$class}};
}

# plugin::ListEpicItems($epic_rank);
sub ListEpicItems {
	my $client = plugin::val('client');
	my $epic_rank = shift;
	my @epic_rank_items = ();
	if ($epic_rank eq "Epic 1.5") {
		@epic_rank_items = (151000..151018);
	} elsif ($epic_rank eq "Epic 2.0") {
		@epic_rank_items = (152000..152018);
	}
	my $status = plugin::val('status');
	my $index = 1;
	plugin::Message("= | $epic_rank Recipes");
	foreach my $epic_rank_item (@epic_rank_items) {
		if ($client->CanClassEquipItem($epic_rank_item)) {
			plugin::Message("== | $index. " . quest::varlink($epic_rank_item) . " - " . quest::saylink("recipe $epic_rank_item", 1, "View Recipe"));
			$index++;
		}
	}
}

# plugin::EpicCostsHash();
sub EpicCostsHash {
	my %epic_costs_hash = (
		"Epic 1.5" => [4, 168001],
		"Epic 2.0" => [8, 168002],
	);
	return %epic_costs_hash;
}

# plugin::ListEpicRecipe($recipe);
sub ListEpicRecipe {
	my $recipe = shift;
	my %epic_costs_hash = plugin::EpicCostsHash();
	my $emblem = plugin::ProgressionEmblems();
	my $epic_rank = "";
	if ($recipe ~~ [151000..151018]) {
		$epic_rank = "Epic 1.5";
	} elsif ($recipe ~~ [152000..152018]) {
		$epic_rank = "Epic 2.0";
	}
	my (
		$epic_cost,
		$epic_mold
	) = @{$epic_costs_hash{$epic_rank}};
	my $recipe_link = quest::varlink($recipe);
	my $epic_link = plugin::GetEpic(2, $recipe) eq "-" ? "" : quest::varlink(plugin::GetEpic(2, $recipe));
	my $mold_link = quest::varlink($epic_mold);
	my $epic_cost_string = plugin::commify($epic_cost);
	my $emblem_link = quest::varlink($emblem);
	my $craft_link = quest::saylink("craft $recipe", 1, "Craft");
	plugin::Message("= | $recipe_link");
	if ($epic_link) {
		plugin::Message(
		"== | 
		$epic_link, 
		$mold_link, 
		and $epic_cost_string $emblem_link"
		);
	} else {
		plugin::Message("== | $mold_link and $epic_cost_string $emblem_link");
	}
	plugin::Message("=== | $craft_link");
}

# plugin::GetEpic($type, $epic_item);
sub GetEpic {
	my $type = shift;
	my $epic_item = shift;
	if ($type == 0) {
		return $epic_item;
	} elsif ($type == 1) {
		if ($epic_item ~~ [150000..150002]) {
			return 151000;
		} elsif ($epic_item ~~ [150004..150005]) {
			return 151002;
		} elsif ($epic_item ~~ [150006, 150007, 150022]) {
			return 151004;
		} elsif ($epic_item ~~ [150008, 150009]) {
			return 151006;
		} elsif ($epic_item ~~ [150019, 150020]) {
			return 151017;
		} elsif ($epic_item == 150021) {
			return 151018;
		} else {
			if ($epic_item ~~ [150003, 150010..150018]) {
				return (($epic_item + 1000) - 2);
			} else {
				return ($epic_item + 1000);
			}
		}
	} elsif ($type == 2) {
		if ($epic_item == 151000) {
			return 150000;
		} elsif ($epic_item ~~ [151002..151003]) {	
			return 150004;
		} elsif ($epic_item ~~ [151004..151005]) {
			return 150006;
		} elsif ($epic_item ~~ [151006..151007]) {
			return 150008;
		} elsif ($epic_item == 151017) {
			return 150019;
		} elsif ($epic_item == 151018) {
			return 150021;
		} elsif ($epic_item ~~ [152000..152018]) {
			return ($epic_item - 1000);
		}
	}
	return "-";
}

# plugin::UpgradeEpic($epic_item);
sub UpgradeEpic {
	my $epic_item = shift;
	my %epic_costs_hash = plugin::EpicCostsHash();
	my $client = plugin::val('client');
	my $emblem = plugin::ProgressionEmblems();
	my $currency_id = quest::getcurrencyid($emblem);
	my $previous = (GetEpic(2, $epic_item) eq "-" ? 0 : GetEpic(2, $epic_item));
	my $epic_rank = "";
	if ($epic_item ~~ [150000..150022]) {
		$epic_rank = "Epic 1.0";
	} elsif ($epic_item ~~ [151000..151018]) {
		$epic_rank = "Epic 1.5";
	} elsif ($epic_item ~~ [152000..152018]) {
		$epic_rank = "Epic 2.0";
	}
	my (
		$epic_cost,
		$mold
	) = @{$epic_costs_hash{$epic_rank}};
	my (
		$before_shards,
		$before_crystals,
		$before_aa_points,
	) = (
		plugin::GetCurrency($client, $currency_id),
		plugin::GetCrystalType(1),
		$client->GetAAPoints(),
	);
	my $mold_check = quest::countitem($mold);
	my $previous_check = ($previous > 0 ? quest::countitem($previous) : -1);
	if (
		$before_shards >= $epic_cost &&
		$mold_check >= 1 &&
		(
			$previous_check == -1 ||
			$previous_check >= 1
		)
	) {
		quest::summonitem($epic_item);
		plugin::Whisper("You have successfully crafted an $epic_rank!");
		if ($client->Admin() != 255) {
			plugin::GearAnnounce($epic_item);
		}
		plugin::TakeCurrency($client, $currency_id, $epic_cost);
		quest::removeitem($mold, 1);
		if ($previous_check != -1) {
			quest::removeitem($previous, 1);
		}
		plugin::Data($client, 1, $epic_rank, 1);
		my (
			$after_shards,
			$after_crystals,
			$after_aa_points,
		) = (
			plugin::GetCurrency($client, $currency_id),
			plugin::GetCrystalType(1),
			$client->GetAAPoints(),
		);
		plugin::LogEpic(
			$epic_item, 
			$before_shards, 
			$after_shards, 
			$before_crystals, 
			$after_crystals, 
			$before_aa_points, 
			$after_aa_points
		);
		return 0;
	}
	plugin::Whisper("You don't seem to have what I need, I think you've made a mistake.");
}