sub PetGearHash {
	my %pet_gear_hash = (
		1 => [["Undefined", 1, 2], [172005..172011, 172006], [172000..172004]],
		2 => [[3, 4], [172017..172023, 172018], [172012..172016]],
		3 => [[5, 6], [172029..172035, 172030], [172024..172028]],
		4 => [[7, 8], [172041..172047, 172042], [172036..172040]],
		5 => [[9, 10], [172053..172059, 172054], [172048..172052]],
		6 => [[11, 12], [172065..172071, 172066], [172060..172066]],
		7 => [[13, 14], [172077..172083, 172078], [172072..172078]],
		8 => [[15, 16], [172089..172095, 172090], [172084..172090]],
		9 => [[17, 18], [172101..172107, 172102], [172096..172102]],
		10 => [[19, 20], [172113..172119, 172114], [172108..172114]]
	);
	return %pet_gear_hash;
}

sub ListPetGear {
	my %pet_gear_hash = plugin::PetGearHash();
	my $status = plugin::val('status');
	my $client = plugin::val('client');
	my $pet_weapon_index = plugin::Data($client, 3, "PetWeapon");
	my $type = shift;
	if ($type == 0) {
		my @pet_items = @_;
		my $index = 1;
		my $message = "<table>";
			foreach my $pet_item (sort {$a <=> $b} @pet_items) {
				my $pet_item_name = quest::getitemname($pet_item);
				$message .=
				"<tr>
					<td>$index. $pet_item_name</td>
				</tr>";
				$index++;
			}
		$message .= "</table>";
		return $message;
	} elsif ($type == 1) {
		foreach my $rank (sort {$a <=> $b} keys %pet_gear_hash) {
			my @flags = @{$pet_gear_hash{$rank}[0]};
			if (plugin::Data($client, 3, "Progression") ~~ @flags || ($rank == 10 && $status >= 80)) {
				my @pet_items = @{$pet_gear_hash{$rank}[1]};
				my $pet_weapon = $pet_gear_hash{$rank}[2][$pet_weapon_index];
				my $index = 1;
				foreach my $pet_item (@pet_items, $pet_weapon, $pet_weapon) {
					my $pet_link = quest::varlink($pet_item);
					plugin::Message("$index. $pet_link");
					$index++;
				}
				return;
			}
		}
	} elsif ($type == 2) {
		foreach my $rank (sort {$a <=> $b} keys %pet_gear_hash) {
			my @flags = @{$pet_gear_hash{$rank}[0]};
			if (plugin::Data($client, 3, "Progression") ~~ @flags || ($rank == 10 && $status >= 80)) {
				my @pet_items = @{$pet_gear_hash{$rank}[1]};
				my $pet_weapon = $pet_gear_hash{$rank}[2][$pet_weapon_index];
				my $index = 1;
				my $message = "<table>";
					foreach my $pet_item (@pet_items, $pet_weapon, $pet_weapon) {
						my $pet_item_name = quest::getitemname($pet_item);
						$message .=
							"<tr>
								<td>$index. $pet_item_name</td>
							</tr>";
						$index++;
					}
				$message .= "</table>";
				return $message;
			}
		}
	} elsif ($type == 3) {
		foreach my $rank (sort {$a <=> $b} keys %pet_gear_hash) {
			my @flags = @{$pet_gear_hash{$rank}[0]};
			if (plugin::Data($client, 3, "Progression") ~~ @flags || ($rank == 10 && $status >= 80)) {
				my @pet_items = @{$pet_gear_hash{$rank}[1]};
				my $pet_weapon = $pet_gear_hash{$rank}[2][$pet_weapon_index];
				my $index = 1;
				foreach my $pet_item (@pet_items, $pet_weapon, $pet_weapon) {
					my $pet_link = quest::varlink($pet_item);
					plugin::Message("$index. $pet_link");
					$index++;
				}
			}
		}
	}
}

sub PetGear {
	my %pet_gear_hash = plugin::PetGearHash();
	my $client = plugin::val('client');
	my $entity_list = plugin::val('entity_list');
	my $npc = $entity_list->GetNPCByID($client->GetPetID());	
	my $class = plugin::val('class');
	my $status = plugin::val('status');
	my $pet_weapon_index = plugin::Data($client, 3, "PetWeapon");
	foreach my $rank (sort {$a <=> $b} keys %pet_gear_hash) {
		my @flags = @{$pet_gear_hash{$rank}[0]};
		if (plugin::Data($client, 3, "Progression") ~~ @flags || ($rank == 10 && $status >= 80)) {
			my @pet_items = @{$pet_gear_hash{$rank}[1]};
			my $pet_weapon = $pet_gear_hash{$rank}[2][$pet_weapon_index];
			if (!$npc->EntityVariableExists("PetGear")) {
				$npc->AddItem($_, 1) for (@pet_items, $pet_weapon, $pet_weapon);
				$npc->SetHP($npc->GetMaxHP());
				plugin::Popup("A mysterious voice says,", "Your pet has been equipped with the following:<br><br>" . plugin::ListPetGear(0, @pet_items, $pet_weapon, $pet_weapon), 0, 999);
				$npc->SetEntityVariable("PetGear", 1);
			} else {
				plugin::Message("Your pet already has gear!");
			}
			return;
		}
	}
}

sub PetCostsHash {
	my %pet_costs_hash = (
		# Leash => [Shards, AA Points, Crystals, Platinum]
		1 => [600, 10, 50, 20, 2500],
		2 => [601, 20, 100, 50, 5000],
		3 => [602, 30, 250, 100, 10000],
		4 => [603, 50, 500, 250, 25000],
		5 => [604, 100, 1000, 500, 50000],
		6 => [605, 250, 1500, 750, 100000],
		7 => [606, 500, 2000, 1000, 150000],
		8 => [607, 750, 2500, 1500, 200000],
		9 => [608, 1000, 3000, 2000, 250000],
		10 => [609, 1500, 5000, 2500, 300000],
	);
	return %pet_costs_hash;
}

sub UpgradePet {
	my $leash = shift;
	my $client = plugin::val('client');
	my %pet_costs_hash = plugin::PetCostsHash();
	my $emblem = plugin::ProgressionEmblems();
	my $currency_id = quest::getcurrencyid($emblem);
	my $crystal_type = plugin::GetCrystalType(2);
	foreach my $item (600..609) {
		my $item_link = quest::varlink($item);
		if ($item == $leash) {
			my $leash_index = ($item - 599);
			my (
				$leash_item_id,
				$shards,
				$aa_points,
				$crystals,
				$platinum,
			) = @{$pet_costs_hash{$leash_index}};
			my $previous_item = (
				($item > 600) ? 
				($item - 1) : 
				0
			);
			my $previous_link = ($previous_item > 0 ? quest::varlink($previous_item) : 0);
			my $previous_check = (
				($previous_item > 0) ? 
				(
					quest::countitem($previous_item) > 0 ? 
					quest::countitem($previous_item) : 0
				) : 
				-1
			);
			my (
				$before_shards,
				$before_crystals,
				$before_aa_points,
				$before_platinum,
			) = (
				plugin::GetCurrency($client, $currency_id),
				plugin::GetCrystalType(1),
				$client->GetAAPoints(),
				plugin::GetPlatinum($client),
			);
			if (
				$before_shards >= $shards &&
				$before_crystals >= $crystals &&
				$before_aa_points >= $aa_points &&
				$before_platinum >= $platinum &&
				($previous_check == -1 || $previous_check > 0)
			) {
				if ($previous_item > 0) {
					quest::removeitem($previous_item, 1);
				}
				plugin::TakeAAPoints($client, $aa_points);
				plugin::AddCrystals($client, $crystal_type, 1, $crystals);
				plugin::TakePlatinum($client, $platinum);
				quest::summonitem($item);
				plugin::TakeCurrency($client, $currency_id, $shards);
				if ($item > 600) {
					plugin::Whisper("I have upgraded your $previous_link to a $item_link.");
				} else {
					plugin::Whisper("You have successfully crafted a $item_link.");
				}
				if ($client->Admin() != 255) {
					plugin::GearAnnounce($item);
				}
				my (
					$after_shards,
					$after_crystals,
					$after_aa_points,
					$after_platinum,
				) = (
					plugin::GetCurrency($client, $currency_id),
					plugin::GetCrystalType(1),
					$client->GetAAPoints(),
					plugin::GetPlatinum($client),
				);
				plugin::LogPet(
					$item,
					$before_shards,
					$after_shards,
					$before_crystals,
					$after_crystals,
					$before_aa_points,
					$after_aa_points,
					$before_platinum,
					$after_platinum
				);
				return 1;
			}
		}
	}
	plugin::Whisper("You do not have the necessary crafting components!");
}

sub ListLeashRecipe {
	my $recipe = shift;
	my %pet_costs_hash = plugin::PetCostsHash();
	my (
		$leash_item_id,
		$shard_cost,
		$aa_points_cost,
		$crystals_cost,
		$platinum_cost,
	) = @{$pet_costs_hash{$recipe}};
	my $leash_link = quest::varlink($leash_item_id);
	my $previous_leash_item_id = ($leash_item_id > 600 ? ($leash_item_id - 1) : 0);
	my $previous_link = ($previous_leash_item_id > 0 ? quest::varlink($previous_leash_item_id) : 0);
	my $emblem = plugin::ProgressionEmblems();
	my $emblem_link = quest::varlink($emblem);
	my $shard_cost_string = plugin::commify($shard_cost);
	my $aa_cost_string = plugin::commify($aa_points_cost);
	my $crystal_cost_string = plugin::commify($crystals_cost);
	my $crystal_id = plugin::GetCrystalType(2) eq "Ebon" ? 40902 : 40903;
	my $crystal_link = quest::varlink($crystal_id);
	my $platinum_cost_string = plugin::commify($platinum_cost);
	my $buy_link = quest::saylink("buy $leash_item_id", 1, "Upgrade");
	plugin::Message("= | $leash_link Requirements");
	if ($previous_leash_item_id != 0) {
		plugin::Message(
			"== | 
			$previous_link | 
			$shard_cost_string $emblem_link | 
			$aa_cost_string AA Points | 
			$crystal_cost_string $crystal_link | 
			$platinum_cost_string Platinum"
		);
	} else {	
		plugin::Message(
			"== | 
			$shard_cost_string $emblem_link | 
			$aa_cost_string AA Points | 
			$crystal_cost_string $crystal_link | 
			$platinum_cost_string Platinum"
		);
	}
	plugin::Message("=== | $buy_link");
}