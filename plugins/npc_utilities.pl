sub AddLoot {
	my $npc = plugin::val('npc');
	if ($npc->GetLevel() == 255) {
		return;
	}
	
	my %tier_loot_hash = plugin::TierLootHash();	
	my %leveling_loot_hash = plugin::LevelingLootHash();
	my %shard_loot_hash = plugin::ShardLootHash();	
	my %weapons_loot_hash = plugin::WeaponsLootHash();	
	my @prestige_zones_array = plugin::PrestigeZonesArray();
	my %races_hash = plugin::RacesHash();
	my %tier_donator_hash = plugin::TierDonatorHash();	
	my (
		$zone_short_name,
		$instance_version,
	) = (
		shift,
		shift,
	);
	if ($npc->GetOwnerID() == 0 && $zone_short_name ne "arena2") {
		if (defined $tier_loot_hash{$zone_short_name}) {
			my $donator_token = 187000;
			my $zone_tier = $tier_loot_hash{$zone_short_name}[0];
			my $tier_key = (200 + $zone_tier);
			my $donator_chance = $tier_donator_hash{$zone_tier};
			if (quest::ChooseRandom(1..$donator_chance) == $donator_chance) {
				my $donator_link = quest::varlink($donator_token);
				my $npc_name = $npc->GetCleanName();
				my $zone_long_name = plugin::Zone("LN", $zone_short_name);
				plugin::GM(
					"Adding a $donator_link to $npc_name in $zone_long_name."
				);
				$npc->AddItem($donator_token, 1);
			}

			if (quest::ChooseRandom(1..100) == 100) {
				my $key_link = quest::varlink($tier_key);
				my $npc_name = $npc->GetCleanName();
				my $zone_long_name = plugin::Zone("LN", $zone_short_name);
				plugin::GM(
					"Adding a $key_link to $npc_name in $zone_long_name."
				);
				$npc->AddItem($tier_key, 1);
			}
		} elsif (defined $leveling_loot_hash{$zone_short_name}) {
			if ($zone_short_name eq "tutorialb" && $npc->GetLevel() > 20) {
				return;
			}
			my @zone_items = @{$leveling_loot_hash{$zone_short_name}[0]};
			for (my $i = 0; $i < quest::ChooseRandom(1..3); $i++) {
				if (quest::ChooseRandom(1..100) > 50) {
					$npc->AddItem(quest::ChooseRandom(@zone_items), 1);
				}
			}
		} elsif (defined $weapons_loot_hash{$zone_short_name}) {
			if ($instance_version != 0) {
				my $rank_index = ($instance_version - 1);
				my $item = $weapons_loot_hash{$zone_short_name}[$rank_index];
				my $amount = (
					($instance_version > 5) ?  
					quest::ChooseRandom(3..6) :
					quest::ChooseRandom(1..3)
				);
				my $drop_chance = (75 - (-1 * $instance_version));
				if (quest::ChooseRandom(1..100) > $drop_chance) {
					$npc->AddItem(
						$item,
						$amount
					);
				}
				
				if (quest::ChooseRandom(1..1000) == 1000) {
					$npc->AddItem(300, quest::ChooseRandom(1..3));
				}
			}
		} elsif (grep(/$zone_short_name/i, @prestige_zones_array)) {
			if (defined $races_hash{$npc->GetRace()}) {
				my @zone_races = @{$races_hash{$npc->GetRace()}};
				quest::npctexture(quest::ChooseRandom(@zone_races));
			}
		}
	}
}

sub AddBossLoot {
	my $npc = plugin::val('npc');
	my %boss_loot_hash = plugin::BossLootHash();
	my $npc_type_id = $npc->GetNPCTypeID();
	if (defined $boss_loot_hash{$npc_type_id}) {
		if (defined $boss_loot_hash{$npc_type_id}[1]) {
			my @zone_items = @{$boss_loot_hash{$npc_type_id}};
			$npc->AddItem(quest::ChooseRandom(@zone_items));
		} else {
			my $item = $boss_loot_hash{$npc_type_id};
			$npc->AddItem($item);
		}
	}
}

sub HandleShardDeath {
	my $client = shift;
	my %shard_loot_hash = plugin::ShardLootHash();
	my %tier_loot_hash = plugin::TierLootHash();
	my $zone_short_name = plugin::val('zonesn');
	
	if (defined $shard_loot_hash{$zone_short_name}) {
		my (
			$zone_min_drop,
			$zone_max_drop,
			$zone_chance,
			$zone_min_platinum,
			$zone_max_platinum,
		) = (
			$shard_loot_hash{$zone_short_name}[1],
			$shard_loot_hash{$zone_short_name}[2],
			$shard_loot_hash{$zone_short_name}[3],
			$shard_loot_hash{$zone_short_name}[4],
			$shard_loot_hash{$zone_short_name}[5],
		);
		if (quest::ChooseRandom(1..100) > $zone_chance) {
			my @zone_items = @{$shard_loot_hash{$zone_short_name}[0]};
			my $random_item = $zone_items[rand @zone_items];
			my $zone_currency_id = quest::getcurrencyid($random_item);
			my $currency_amount = quest::ChooseRandom($zone_min_drop..$zone_max_drop);
			plugin::AddCurrencyRandom(
				$client, 
				$zone_currency_id, 
				$currency_amount
			);
			#quest::gmsay("This was a class shard death");
		}
	}
	
	if (defined $tier_loot_hash{$zone_short_name}) {	
		my (
			$zone_chance,
			$zone_min_platinum,
			$zone_max_platinum
		) = (
			$tier_loot_hash{$zone_short_name}[2],
			$tier_loot_hash{$zone_short_name}[3],
			$tier_loot_hash{$zone_short_name}[4],
		);
		my (
			$tier_shard,
			$tier_shard_chance
		) = (
			$tier_loot_hash{$zone_short_name}[5] ? $tier_loot_hash{$zone_short_name}[5] : 0,
			$tier_loot_hash{$zone_short_name}[6] ? $tier_loot_hash{$zone_short_name}[6] : 0,
		);
		if ($tier_shard > 0) {
			my $zone_currency_id = quest::getcurrencyid($tier_shard);
			if ($tier_shard > 1) {
				$zone_currency_id = quest::getcurrencyid(quest::ChooseRandom(1..$tier_shard));
			}
			if (quest::ChooseRandom(1..100) > $tier_shard_chance) {
				my $currency_amount = quest::ChooseRandom(1..3);
				# quest::worldwidemessage(15, "[DEBUG] :: [$zone_short_name] :: Adding $currency_amount tier shards to " . $client->GetCleanName() . "");
				plugin::AddCurrencyRandom(
					$client, 
					$zone_currency_id, 
					$currency_amount
				);
			}
		}
	}
}

sub HandleDeath {
	my $client = plugin::val('client');
	my $character_count = plugin::GroupCount();
	my $zone_short_name = plugin::val('zonesn');
	my $instance_version = plugin::val('instanceversion');
	my %aa_loot_hash = plugin::AALootHash();
	my %crystal_loot_hash = plugin::CrystalLootHash();
	my %leveling_loot_hash = plugin::LevelingLootHash();
	my %prestige_loot_hash = plugin::PrestigeLootHash();
	my %shard_loot_hash = plugin::ShardLootHash();
	my %tier_loot_hash = plugin::TierLootHash();
	my %weapons_loot_hash = plugin::WeaponsLootHash();	
	if (defined $aa_loot_hash{$zone_short_name}) {
		my (
			$zone_min_aa_points,
			$zone_max_aa_points,
			$zone_drop_chance,
		) = @{$aa_loot_hash{$zone_short_name}};
		my $aa_points = quest::ChooseRandom($zone_min_aa_points..$zone_max_aa_points);
		if (quest::ChooseRandom(1..100) > $zone_drop_chance) {
			plugin::AddAAPoints($client, $aa_points);
		}
	}
	
	if (defined $crystal_loot_hash{$zone_short_name}) {
		my (
			$zone_min_crystals,
			$zone_max_crystals,
			$zone_crystal_chance,
			$zone_min_drop,
			$zone_max_drop,
			$zone_drop_chance,
		) = @{$crystal_loot_hash{$zone_short_name}};
		my (
			$radiant_crystals,
			$ebon_crystals
		) = (
			quest::ChooseRandom($zone_min_crystals..$zone_max_crystals),
			quest::ChooseRandom($zone_min_crystals..$zone_max_crystals)
		);
		my $currency = quest::ChooseRandom(1..5);
		my $currency_value = quest::ChooseRandom($zone_min_drop..$zone_max_drop);
		if (quest::ChooseRandom(1..100) > $zone_crystal_chance) {
			plugin::AddCrystals($client, "Both", 0, 0, $radiant_crystals, $ebon_crystals);
			#quest::worldwidemessage(15, "[DEBUG] :: [$zone_short_name] :: Adding $radiant_crystals / $ebon_crystals crystals to " . $client->GetCleanName() . "");
		}				
			
		if (quest::ChooseRandom(1..100) > $zone_drop_chance) {
			if ($currency_value > 0) {
				plugin::AddCurrency($client, $currency, $currency_value);
				#quest::worldwidemessage(15, "[DEBUG] :: [$zone_short_name] :: Adding $currency_value zone currency to " . $client->GetCleanName() . "");
			} 
		}
	}
	
	if (defined $leveling_loot_hash{$zone_short_name}) {
		my (
			$zone_min_platinum,
			$zone_max_platinum,
		) = (
			$leveling_loot_hash{$zone_short_name}[1],
			$leveling_loot_hash{$zone_short_name}[2],
		);
		if (quest::ChooseRandom(1..100) > 50) {
			my $platinum_amount = quest::ChooseRandom($zone_min_platinum..$zone_max_platinum);
			plugin::AddMoney(
				$client,
				int(
					$platinum_amount /
					$character_count
				)
			);
		}
	}
	
	if (defined $prestige_loot_hash{$zone_short_name}) {
		my (
			$zone_currency_id,
			$zone_min_crystals,
			$zone_max_crystals,
			$zone_crystal_chance,
		) = @{$prestige_loot_hash{$zone_short_name}};
		my $currency_value = quest::ChooseRandom($zone_min_crystals..$zone_max_crystals);
		if (quest::ChooseRandom(1..100) > $zone_crystal_chance) {
			my $platinum_amount = quest::ChooseRandom(10000..25000);
			if ($currency_value > 0) {
				plugin::AddCurrency($client, $zone_currency_id, $currency_value);
			}
			plugin::AddMoney(
				$client,
				int(
					$platinum_amount / 
					$character_count
				)
			);
		}
	}
	
	if (defined $shard_loot_hash{$zone_short_name}) {
		my (
			$zone_chance,		
			$zone_min_platinum,
			$zone_max_platinum,
		) = (
			$shard_loot_hash{$zone_short_name}[3],
			$shard_loot_hash{$zone_short_name}[4],
			$shard_loot_hash{$zone_short_name}[5],
		);
		if (quest::ChooseRandom(1..100) > $zone_chance) {
			my $platinum_amount = quest::ChooseRandom(
				$zone_min_platinum..$zone_max_platinum
			);
			plugin::AddMoney(
				$client,
				int(
					$platinum_amount / 
					$character_count
				)
			);
		}
	}
	
	if (defined $tier_loot_hash{$zone_short_name}) {
		my (
			$zone_tier,
			$zone_item,
			$zone_chance,
			$zone_min_platinum,
			$zone_max_platinum,
		) = (
			$tier_loot_hash{$zone_short_name}[0],
			$tier_loot_hash{$zone_short_name}[1],
			$tier_loot_hash{$zone_short_name}[2],
			$tier_loot_hash{$zone_short_name}[3],
			$tier_loot_hash{$zone_short_name}[4],
		);
		if (quest::ChooseRandom(1..100) > $zone_chance) {
			my $zone_currency_id = quest::getcurrencyid($zone_item);
			plugin::AddCurrencyRandom(
				$client, 
				$zone_currency_id, 
				1
			);
		}
	
		if (quest::ChooseRandom(1..100) > $zone_chance) {
			my $platinum_amount = quest::ChooseRandom(
				$zone_min_platinum..$zone_max_platinum
			);
			plugin::AddMoney(
				$client,
				int(
					$platinum_amount /
					$character_count
				)
			);
		}
	}
	
	if (defined $weapons_loot_hash{$zone_short_name}) {
		if ($instance_version) {
			my (
				$zone_chance,
				$platinum_amount,
			) = (
				(75 - (-1 * $instance_version)),
				(quest::ChooseRandom(6500..12500) + ($instance_version * 1000)),
			);
			if (quest::ChooseRandom(1..100) > $zone_chance) {
				plugin::AddMoney(
					$client,
					int(
						$platinum_amount /
						$character_count
					)
				);
			}
		}
	}
}

sub AALootHash {
	my %aa_loot_hash = (
		"oldfieldofbone" => [1, 25, 65],
	);
	return %aa_loot_hash;
}

sub BossLootHash {
	my %boss_loot_hash = (
		2000191 => [186501, 186508],
		2000192 => 166142,
		2000194 => [186502, 186509],
		2000195 => 166146,
		2000197 => [186504, 186511],
		2000198 => 166145,
		2000200 => [186503, 186510],
		2000201 => 166140,
		2000203 => [186500, 186507],
		2000204 => 166143,
		2000206 => [186505, 186512],
		2000207 => 166144,
		2000209 => [186506, 186513],
		2000210 => 166141,
	);
	return %boss_loot_hash;
}

sub CrystalLootHash {
	my %crystal_loot_hash = (
		"potactics" => [1, 3, 50, 0, 0, 0],
		"fhalls" => [1, 6, 70, 0, 0, 0],
		"ferubi" => [1, 9, 50, 1, 3, 50],
		"drachnidhive" => [3,10,40,1,4,50],
		"pofire" => [1, 12, 70, 1, 6, 70],
	);
	return %crystal_loot_hash;
}

sub LevelingLootHash {
	my %leveling_loot_hash = (
		"tutorialb" => [[50033..50060, 50320..50339, 50523..50535], 1, 5],
		"innothule" => [[50033..50060, 50320..50339, 50523..50535], 1, 5],
		"kurn" => [[50061..50088, 50340..50359, 50540..50552], 5, 10],
		"blackburrow" => [[50061..50088, 50340..50359, 50540..50552], 5, 10],
		"netherbian" => [[50089..50116, 50350..50369, 50556..50568], 10, 15],
		"warrens" => [[50089..50116, 50350..50369, 50556..50568], 10, 15],
		"mistmoore" => [[50117..50144, 50380..50399, 50572..50585, 60528..60547, 60500..60561], 15, 20],
		"gukbottom" => [[50117..50144, 50380..50399, 50572..50585, 60528..60547, 60500..60561], 15, 20],
		"karnor" => [[50145..50178, 50401..50420, 50588..50601], 20, 25],
		"kael" => [[50179..50212, 50422..50441, 50604..50616], 25, 50],
		"veksar" => [[50179..50212, 50422..50441, 50604..50616], 25, 50],
		"droga" => [[50179..50212, 50422..50441, 50604..50616], 25, 50],
		"sleeper" => [[50213..50246, 50443..50462, 50617..50631], 50, 100],
	);
	return %leveling_loot_hash;
}

sub PrestigeLootHash {
	my %prestige_loot_hash = (
		"soldungb" => [6, 1, 3, 70],
		"permafrost" => [6, 1, 4, 75],
		"emeraldjungle" => [6, 1, 3, 70],
		"skyfire" => [6, 1, 4, 75],
		"dreadspire" => [6, 1, 5, 80],
		"arcstone" => [7, 1, 5, 80],
	);
	return %prestige_loot_hash;
}

sub PrestigeZonesArray {
	my @prestige_zones_array = (
		"soldungb",
		"permafrost",
		"emeraldjungle",
		"skyfire",
		"dreadspire",
		"arcstone",
	);
	return @prestige_zones_array;
}

sub RacesHash {
	my %races_hash = (
		411 => [0..2],
		417 => [0..2],
		434 => [0, 1],
		442 => [0..2],
		482 => [0..3],
		494 => [0..4],
	);
	return %races_hash;
}

sub ShardLootHash {
	my %shard_loot_hash = (
		"eastkarana" => [[167000..167015], 1, 2, 75, 5000, 7500],
		"potactics" => [[167000..167015], 2, 2, 75, 7500, 10000],
		"fhalls" => [[167000..167015], 2, 3, 70, 10000, 12000],
		"ferubi" => [[167000..167015], 3, 4, 70, 12000, 15000],
		"drachnidhive" => [[167000..167015], 4, 6, 70, 15000, 20000],
		"pofire" => [[167000..167015], 4, 5, 50, 20000, 25000],
	);
	return %shard_loot_hash;
}

sub TierDonatorHash {
	my %tier_donator_hash = (
		1 => 500,
		2 => 450,
		3 => 400,
		4 => 350,
		5 => 300,
		6 => 250,
		7 => 200,
		8 => 150,
		9 => 150,
		10 => 150,
		11 => 145,
		12 => 140,
		13 => 135,
		14 => 130,
		15 => 125,
		16 => 120,
		17 => 115,
		18 => 110,
		19 => 105,
		20 => 100,
	);
	return %tier_donator_hash;
}

sub TierMerchantHash {
	my %tier_merchant_hash = (
		1 => [[165000..165013, 165200..165202], [166000..166006], 1],
		2 => [[165014..165027, 165203..165205], [166007..166013], 1],
		3 => [[165028..165041, 165206..165208], [166014..166020], 2],
		4 => [[165042..165055, 165209..165211], [166021..166027], 2],
		5 => [[165056..165069, 165212..165214], [166028..166034], 3],
		6 => [[165070..165083, 165215..165217], [166035..166041], 3],
		7 => [[165084..165097, 165218..165220], [166042..166048], 4],
		8 => [[165098..165111, 165221..165223], [166049..166055], 4],
		9 => [[165112..165125, 165224..165226], [166056..166062], 5],
		10 => [[165126..165139, 165227..165229], [166063..166069], 5],
		11 => [[182028..182041, 165230..165232], [166070..166076], 6],
		12 => [[182070..182083, 165233..165235], [166077..166083], 6],
		13 => [[182112..182125, 165236..165238], [166084..166090], 7],
		14 => [[182154..182167, 165239..165241], [166091..166097], 7],
		15 => [[182196..182209, 165242..165244], [166098..166104], 8],
		16 => [[182238..182251, 165245..165247], [166105..166111], 8],
		17 => [[182280..182293, 165248..165250], [166112..166118], 9],
		18 => [[182322..182335, 165251..165253], [166119..166125], 9],
		19 => [[182364..182377, 165254..165256], [166126..166132], 10],
		20 => [[182406..182419, 165257..165259], [166133..166139], 10],
	);
	return %tier_merchant_hash;
}

sub TierLootHash {
	my %tier_loot_hash = (
		"templeveeshan" => [1, 166200, 70, 2500, 5000],
		"akheva" =>	[2, 166201, 70, 2500, 5000],
		"bothunder" => [3, 166202, 70, 2500, 5000],
		"crushbone" => [4, 166203, 70, 2500, 5000],
		"frostcrypt" =>	[5, 166204, 70, 5000, 10000],
		"postorms" => [6, 166205, 70, 5000, 10000],
		"discord" => [7, 166206, 75, 5000, 10000],
		"anguish" => [8, 166207, 75, 5000, 10000],
		"codecay" => [9, 166208, 75, 6000, 12000],
		"crystallos" => [10, 166209, 80, 6500, 13000, 1, 65],
		"ashengate" => [11, 166210, 80, 7000, 13500, 2, 65],
		"atiiki" =>	[12, 166211, 80, 8000, 14500, 3, 65],
		"beholder" => [13, 166212, 81, 8750, 15000, 4, 70],
		"deadbone" => [14, 166213, 81, 9000, 15000, 5, 70],
		"mechanotus" =>	[15, 166214, 81, 9250, 16500, 6, 70],
		"redfeather" =>	[16, 166215, 82, 10000, 17000, 7, 75],
		"roost" => [17, 166216, 82, 11500, 19500, 8, 75],
		"shiningcity" => [18, 166217, 82, 12500, 21500, 9, 75],
		"mseru" => [19, 166218, 83, 14000, 23000, 10, 75],
		"sseru" => [20, 166219, 85, 15000, 24500, 11, 80],
	);
	return %tier_loot_hash;
}

sub WeaponsLootHash {
	my %weapons_loot_hash = (
		"poair" => [183000..183009],
		"poinnovation" => [183010..183019],
		"pojustice" => [183020..183029],
		"ponightmare" => [183030..183039],
		"potorment" => [183040..183049],
		"growthplane" => [183050..183059],
	);
	return %weapons_loot_hash;
}

sub HandleBossDeath {
	my $entity_list = plugin::val('entity_list');
	my $killer_id = plugin::val('killer_id');
	my $killer_mob = $entity_list->GetMobByID($killer_id) ? $entity_list->GetMobByID($killer_id) : 0;
	my $zone_short_name = plugin::val('zonesn');
	
	my %boss_loot_hash = (
		6 => [["dreadspire", "permafrost", "soldungb", "emeraldjungle", "skyfire"], 10],
		7 => [["arcstone"], 25],
		8 => [["deathknell"], 50],
	);
	
	foreach my $currency_id (sort {$a <=> $b} keys %boss_loot_hash) {
		my @zones = @{$boss_loot_hash{$currency_id}[0]};
		my $zone_currency = $boss_loot_hash{$currency_id}[1];
		if (grep(/$zone_short_name/i, @zones)) {
			if ($killer_mob != 0 && ($killer_mob->IsClient() || ($killer_mob->IsNPC() && $entity_list->GetMobByID($killer_mob->GetOwnerID())->IsClient()))) {
				my $client_entity = ($killer_mob->IsClient() ? $killer_mob->CastToClient() : $entity_list->GetMobByID($killer_mob->GetOwnerID())->CastToClient());
				if (!$client_entity->GetGroup()) {
					if ($zone_currency > 0) {
						plugin::AddCurrency($client_entity, $currency_id, $zone_currency);
					}
				} else {
					for (my $member = 0; $member < 6; $member++) {
						if ($client_entity->GetGroup()->GetMember($member) && $client_entity->GetGroup()->GetMember($member)->IsClient()) {
							my $member_entity = $client_entity->GetGroup()->GetMember($member)->CastToClient();
							if ($zone_currency > 0) {
								plugin::AddCurrency($member_entity, $currency_id, $zone_currency);
							}
						}
					}
				}
			}			
		}
	}
}

sub SetProx{	
	my $Range = $_[0];
	my $Z = $_[1];
	my $NPCBorder = $_[2];
	if(!$NPCBorder){ $NPCBorder = 0; }
	my $x = plugin::val('$x');
	my $y = plugin::val('$y');
	my $npc = plugin::val('$npc');
	my $z = $npc->GetZ();

	if($NPCBorder == 1){ 
		quest::spawn2(614, 0, 0, $x + $Range, $y + $Range, $z, 0);
		quest::spawn2(614, 0, 0, $x - $Range, $y + $Range, $z, 0);
		quest::spawn2(614, 0, 0, $x + $Range, $y - $Range, $z, 0);
		quest::spawn2(614, 0, 0, $x - $Range, $y - $Range, $z, 0);
	}
	quest::set_proximity($x - $Range, $x + $Range, $y - $Range, $y + $Range, $z - $Z, $z + $Z);
}