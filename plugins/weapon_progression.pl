sub WeaponItems {
	my $type = shift;
	my $rank = shift;
	my $client = plugin::val('client');
	my %weapon_items_hash = (
		1 => [[184000..184009], [183000, 183010, 183020, 183030, 183040, 183050]],
		2 => [[184010..184019], [183001, 183011, 183021, 183031, 183041, 183051]],
		3 => [[184020..184029], [183002, 183012, 183022, 183032, 183042, 183052]],
		4 => [[184030..184039], [183003, 183013, 183023, 183033, 183043, 183053]],
		5 => [[184040..184049], [183004, 183014, 183024, 183034, 183044, 183054]],
		6 => [[184050..184059], [183005, 183015, 183025, 183035, 183045, 183055]],
		7 => [[184060..184069], [183006, 183016, 183026, 183036, 183046, 183056]],
		8 => [[184070..184079], [183007, 183017, 183027, 183037, 183047, 183057]],
		9 => [[184080..184089], [183008, 183018, 183028, 183038, 183048, 183058]],
		10 => [[184090..184099], [183009, 183019, 183029, 183039, 183049, 183059]],
	);
	my @weapon_items_array = ();
	if ($type == 0) {
		foreach my $weapon_item (@{$weapon_items_hash{$rank}[0]}) {
			if ($client->CanClassEquipItem($weapon_item)) {
				push (@weapon_items_array, $weapon_item);
			}
		}
	} elsif ($type == 1) {
		@weapon_items_array = @{$weapon_items_hash{$rank}[1]};
	}
	return @weapon_items_array;
}

sub ListWeaponItems {
	my $rank = shift;
	my $real_rank = plugin::Tier($rank);
	my $client = plugin::val('client');
	my @weapon_items_array = WeaponItems(0, $rank);
	plugin::Message("= | Rank $real_rank Recipes");
	foreach my $weapon_item (@weapon_items_array) {
		my $weapon_link = quest::varlink($weapon_item);
		my $recipe_link = quest::saylink("recipe $weapon_item", 1, "View");
		if ($client->CanClassEquipItem($weapon_item)) {
			plugin::Message("== | $weapon_link");
			plugin::Message("=== | $recipe_link");
		}
	}
}

sub WeaponsCostHash {
	my %weapons_cost_hash = (
		1 => [[184000..184009], 50],
		2 => [[184010..184019], 100],
		3 => [[184020..184029], 150],
		4 => [[184030..184039], 200],
		5 => [[184040..184049], 250],
		6 => [[184050..184059], 300],
		7 => [[184060..184069], 350],
		8 => [[184070..184079], 400],
		9 => [[184080..184089], 450],
		10 => [[184090..184099], 500]
	);
	return %weapons_cost_hash;
}

sub ListWeaponRecipe {
	my $recipe = shift;
	my %weapons_cost_hash = plugin::WeaponsCostHash();
	foreach my $rank (sort {$a <=> $b} keys %weapons_cost_hash) {
		my @weapon_items_array = plugin::WeaponItems(0, $rank);
		if ($recipe ~~ @weapon_items_array) {
			my $weapon_cost = (($recipe ~~ [184007, 184017, 184027, 184037, 184047, 184057, 184067, 184077, 184087, 184097]) ? 1 : $weapons_cost_hash{$rank}[1]);
			my $previous_item = (($rank == 1) ? 0 : ($recipe - 10));
			my @required_items = plugin::WeaponItems(1, $rank);
			my $recipe_link = quest::varlink($recipe);
			my $previous_link = ($previous_item == 0 ? "" : quest::varlink($previous_item));
			my $craft_link = quest::saylink("craft $recipe", 1, "Craft");
			my (
				$item_one_link,
				$item_two_link,
				$item_three_link,
				$item_four_link,
				$item_five_link,
				$item_six_link,
			) = (
				quest::varlink($required_items[0]),
				quest::varlink($required_items[1]),
				quest::varlink($required_items[2]),
				quest::varlink($required_items[3]),
				quest::varlink($required_items[4]),
				quest::varlink($required_items[5]),
			);
			my $weapon_cost_string = plugin::commify($weapon_cost);
			plugin::Message("= | $recipe_link");
			if ($previous_item == 0) {
				plugin::Message(
					"== | 
						$weapon_cost_string $item_one_link, 
						$weapon_cost_string $item_two_link, 
						$weapon_cost_string $item_three_link, 
						$weapon_cost_string $item_four_link, 
						$weapon_cost_string $item_five_link, and 
						$weapon_cost_string $item_six_link
					"
				);
			} else {
				plugin::Message(
					"== | 
						$previous_link, 
						$weapon_cost_string $item_one_link, 
						$weapon_cost_string $item_two_link, 
						$weapon_cost_string $item_three_link, 
						$weapon_cost_string $item_four_link, 
						$weapon_cost_string $item_five_link, and 
						$weapon_cost_string $item_six_link
					"
				);
			}
			plugin::Message("=== | $craft_link");
		}
	}
}

sub UpgradeWeapon {
	my $item = shift;
	my %weapons_cost_hash = plugin::WeaponsCostHash();
	my $client = plugin::val('client');
	my $item_crafted = 0;
	foreach my $rank (sort {$a <=> $b} keys %weapons_cost_hash) {
		my @weapon_items_array = WeaponItems(0, $rank);
		if ($item ~~ @weapon_items_array) {
			my @required_items = WeaponItems(1, $rank);
			my $previous_item = (($rank == 1) ? 0 : ($item - 10));
			my $weapon_cost = (($item ~~ [184007, 184017, 184027, 184037, 184047, 184057, 184067, 184077, 184087, 184097]) ? 1 : $weapons_cost_hash{$rank}[1]);
			my $previous_check = (($previous_item == 0) ? -1 : quest::countitem($previous_item));
			my $item_link = quest::varlink($item);
			my (
				$before_item_one,
				$before_item_two,
				$before_item_three,
				$before_item_four,
				$before_item_five,
				$before_item_six,
			) = (
				quest::countitem($required_items[0]),
				quest::countitem($required_items[1]),
				quest::countitem($required_items[2]),
				quest::countitem($required_items[3]),
				quest::countitem($required_items[4]),
				quest::countitem($required_items[5]),
			);
			if (
				$previous_check != 0 &&
				$before_item_one >= $weapon_cost &&
				$before_item_two >= $weapon_cost &&
				$before_item_three >= $weapon_cost &&
				$before_item_four >= $weapon_cost &&
				$before_item_five >= $weapon_cost &&
				$before_item_six >= $weapon_cost
			) {
				if ($previous_check != -1) {
					quest::removeitem($previous_item, 1);
				}
				quest::removeitem($_, $weapon_cost) for (@required_items);
				quest::summonitem($item, 1);
				quest::summonitem(52023, 3);
				plugin::Whisper("I have successfully smelted your $item_link!");
				if ($client->Admin() != 255) {
					plugin::GearAnnounce($item);
				}
				$item_crafted = 1;
				my (
					$after_item_one,
					$after_item_two,
					$after_item_three,
					$after_item_four,
					$after_item_five,
					$after_item_six,
				) = (
					quest::countitem($required_items[0]),
					quest::countitem($required_items[1]),
					quest::countitem($required_items[2]),
					quest::countitem($required_items[3]),
					quest::countitem($required_items[4]),
					quest::countitem($required_items[5]),
				);
				plugin::LogWeapon(
					$item,
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
				);
			}
		}
	}
	plugin::Whisper("You do not have the necessary crafting components!");
	return $item_crafted;
}

sub ForgeResonatingItem {
	my %resonating_items_hash = (
	"Warrior" => [186000..186006],
	"Cleric" => [186007..186013],
	"Paladin" => [186014..186020],
	"Ranger" => [186021..186027],
	"Shadowknight" => [186028..186034],
	"Druid" => [186035..186041],
	"Monk" => [186042..186048],
	"Bard" => [186049..186055],
	"Rogue" => [186056..186063],
	"Shaman" => [186063..186069],
	"Necromancer" => [186070..186076],
	"Wizard" => [186077..186083],
	"Magician" => [186084..186090],
	"Enchanter" => [186091..186097],
	"Beastlord" => [186098..186104],
	"Berserker" => [186105..186111]);
	my @molds = (166140..166146);
	my $item = shift;
	my $item_link = quest::varlink($item);
	my $mold_index = (($item - 186000) % 7);
	my $client = plugin::val('client');
	my $mold = $molds[$mold_index];
	my $mold_check = quest::countitem($mold);
	my $hammer_check = quest::countitem(166147);
	my $item_crafted = 0;
	if ($mold_check > 0 && $hammer_check > 0) {
		quest::removeitem($_, 1) for ($mold, 166147);
		quest::summonitem($item);
		plugin::Whisper("You have successfully crafted your $item_link!");
		plugin::GearAnnounce($item);
		$item_crafted = 1;
	}
	plugin::Whisper("You do not have the necessary crafting components!");
	return $item_crafted;
}