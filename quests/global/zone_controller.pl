sub EVENT_SPAWN {
	LoadScaling();
	LoadStaticZoneScaling(); #:::  Load Zone Static Scaling
	if ($zonesn eq "bazaar") {
		quest::settimer("afkcheck", 1);
	}
	my $zone_long_name = plugin::Zone("LN", $zonesn);
	quest::settimer("scaleall", 3);
	plugin::GM("= | Zone Scaling.");
	plugin::GM(
		"== | Zone " . 
		quest::saylink
		(
			(
				$instanceid == 0 ? 
				"#zone $zonesn" : 
				"#zoneinstance $instanceid"
			), 0, "$zone_long_name"
		) .
		(
			$instanceid > 0 ?
			" | Instance $instanceid | Version $instanceversion" :
			""
		)
	);
} 

sub EVENT_TIMER {
	if($timer eq "scaleall") {
		quest::stoptimer("scaleall");
		ScaleProcedure();
		quest::settimer("scaleall", 1);
	} elsif($timer eq "afkcheck") {
		my @client_list = $entity_list->GetClientList();
		my $time = time();
		foreach my $client (@client_list) {
			if ($client && $entity_list->GetClientByID($client->GetID())) {
				my $bucket_check = plugin::Data($client, 3, "AFK");
				my $afk_check = plugin::Data($client, 3, "Idle");
				my $xyzh_check = plugin::Data($client, 3, "XYZH");
				my $last_time = ($time - $bucket_check);
				my (
					$client_x,
					$client_y,
					$client_z,
					$client_h
				) = (
					int($client->GetX()),
					int($client->GetY()),
					int($client->GetZ()),
					int($client->GetHeading())
				);
				if (!plugin::Data($client, 3, "AFK") && !plugin::Data($client, 3, "XYZH")) {
					plugin::Data($client, 0, $_) for ("AFK", "Idle", "XYZH", "Anon-Flag", "AFK-Flag");
					plugin::Data($client, 1, "AFK", $time);
					plugin::Data($client, 1, "Anon-Flag", $client->GetAnon());
					plugin::Data($client, 1, "AFK-Flag", $client->GetAFK());
					plugin::Data($client, 1, "Size-Flag", $client->GetSize());
					plugin::Data($client, 1, "XYZH", "$client_x $client_y $client_z $client_h");
				} elsif (plugin::Data($client, 3, "AFK") && plugin::Data($client, 3, "XYZH")) {
					if ($bucket_check) {
						my @data = split(/ /, $xyzh_check);
						my (
							$last_x,
							$last_y,
							$last_z,
							$last_h
						) = (
							int($data[0]),
							int($data[1]),
							int($data[2]),
							int($data[3])
						);
						if (
							$last_x == $client_x && 
							$last_y == $client_y &&
							$last_z == $client_z && 
							$last_h == $client_h
						) {
							if ($last_time >= 3600) {
								my $currency_id = 11;
								my $item_id = quest::getcurrencyitemid($currency_id);
								my $item_link = quest::varlink($item_id);
								my $value_string = plugin::commify($client->GetAlternateCurrencyValue(11));
								$client->AddAlternateCurrencyValue($currency_id, 1);
								plugin::ClientMessage(
									$client, 
									"You have been awarded a $item_link for idling for 60 minutes, you now have $value_string $item_link!"
								);
								plugin::Data($client, 0, $_) for ("AFK", "XYZH");
							} elsif ($last_time >= 180 && !$afk_check) {
								my (
									$client_primary,
									$client_secondary,
								) = (
									0,
									0,
								);
								my (
									$primary_slot,
									$secondary_slot,
								) = (
									quest::getinventoryslotid("primary"),
									quest::getinventoryslotid("secondary"),
								);
								if ($client->GetItemAt($primary_slot)) {
									$client_primary = $client->GetItemStat(
										$client->GetItemIDAt($primary_slot),
										"idfile"
									);
								}
								
								if ($client->GetItemAt($secondary_slot)) {
									$client_secondary = $client->GetItemStat(
										$client->GetItemIDAt($secondary_slot),
										"idfile"
									);
								}
								$client->WearChange($_, 0) for (7, 8);
								$client->SetRace(127);
								$client->SetGender(0);
								if ($client->GetPetID() > 0) {
									if ($entity_list->GetNPCByID($client->GetPetID())) { 
										my $pet_entity = $entity_list->GetNPCByID($client->GetPetID());
										$pet_entity->SetRace(127);
										$pet_entity->WearChange($_, 0) for (7, 8);
									}
								}
								plugin::ClientMessage($client, "You have been idle for 3 minutes. You are now A.F.K. (Away From Keyboard)");
								if ($client->Admin() != 255) {
									#$client->MovePC($zoneid, -10.38, 404.63, -43.06, 393.5);
									$client->SetAnon(1);
									$client->SetAFK(1);
									#$client->ChangeSize(0.1);
								}
								my (
									$new_x,
									$new_y,
									$new_z,
									$new_h
								) = (
									int($client->GetX()),
									int($client->GetY()),
									int($client->GetZ()),
									int($client->GetHeading())
								);
								plugin::Data($client, 1, "XYZH", "$new_x $new_y $new_z $new_h");
								plugin::Data($client, 1, "Idle", 1);
								plugin::Data($client, 1, "AFK", $time);
								plugin::Data(
									$client, 
									1, 
									"Textures", 
									"$client_primary $client_secondary"
								);
							}
						} else {
							if (plugin::Data($client, 3, "Idle") || $client->GetRace() == 127) {
								plugin::ClientMessage($client, "You are no longer A.F.K. (Away From Keyboard)");
								my $textures = plugin::Data($client, 3, "Textures");
								my $anon_flag = plugin::Data($client, 3, "Anon-Flag");
								my $afk_flag = plugin::Data($client, 3, "AFK-Flag");
								my $size_flag = plugin::Data($client, 3, "Size-Flag");
								my (
									$primary_texture,
									$secondary_texture,
								) = split(/ /, $textures);
								$client->SetAnon($anon_flag);
								$client->SetAFK($afk_flag);
								$client->SetRace($client->GetBaseRace());
								$client->SetGender($client->GetBaseGender());
								$client->ChangeSize($size_flag);
								if ($primary_texture > 0) {
									$client->WearChange(7, $primary_texture);
								}
								if ($secondary_texture > 0) {
									$client->WearChange(8, $secondary_texture);
								}
								if ($client->GetPetID() > 0) {
									if ($entity_list->GetNPCByID($client->GetPetID())) { 
										my $pet_entity = $entity_list->GetNPCByID($client->GetPetID());
										$pet_entity->SetRace($pet_entity->GetBaseRace());
									}
								}
							}
							plugin::Data($client, 0, $_) for ("AFK", "Idle", "XYZH", "Anon-Flag", "AFK-Flag", "Size-Flag", "Textures");
						}
					} elsif (!plugin::Data($client, 3, "AFK")) {
						if (plugin::Data($client, 3, "Idle")) {
							my $textures = plugin::Data($client, 3, "Textures");
							my $anon_flag = plugin::Data($client, 3, "Anon-Flag");
							my $afk_flag = plugin::Data($client, 3, "AFK-Flag");
							my $size_flag = plugin::Data($client, 3, "Size-Flag");
							my (
								$primary_texture,
								$secondary_texture,
							) = split(/ /, $textures);
							$client->SetAnon($anon_flag);
							$client->SetAFK($afk_flag);
							$client->SetRace($client->GetBaseRace());
							$client->SetGender($client->GetBaseGender());
							if ($primary_texture > 0) {
								$client->WearChange(7, $primary_texture);
							}
							if ($secondary_texture > 0) {
								$client->WearChange(8, $secondary_texture);
							}
							if ($size_flag > 0) {
								$client->ChangeSize($size_flag);
							}
							plugin::ClientMessage($client, "You are no longer A.F.K. (Away From Keyboard)");
							$client->SetRace($client->GetBaseRace());
							$client->SetGender($client->GetBaseGender());
							if ($client->GetPetID() > 0) {
								if ($entity_list->GetNPCByID($client->GetPetID())) { 
									my $pet_entity = $entity_list->GetNPCByID($client->GetPetID());
									$pet_entity->SetRace($pet_entity->GetBaseRace());
								}
							}
						}
						plugin::Data($client, 0, $_) for ("AFK", "Idle", "XYZH", "Anon-Flag", "AFK-Flag", "Size-Flag", "Textures");
					}
				}
			}
		}
		quest::settimer("afkcheck", 1);
	}
}

sub EVENT_DEATH_ZONE {
	my $tier = plugin::ProgressionZone(1);
	if ($tier != 0) {
		if (
			$entity_list->GetMobByID($killer_id) && 
			$entity_list->GetMobByID($killer_id)->IsClient()
		) {
			my $killer_client = $entity_list->GetClientByID($killer_id);
			plugin::UpdateTierTask($killer_client, $tier, 0, 1);
		} elsif ($entity_list->GetMobByID($killer_id)->GetOwnerID()) {
			my $killer_client = $entity_list->GetClientByID($entity_list->GetMobByID($killer_id)->GetOwnerID());
			plugin::UpdateTierTask($killer_client, $tier, 0, 1);
		}
	}
}

sub EVENT_SPAWN_ZONE {
	my $npc = $entity_list->GetNPCByID($spawned_entity_id);
	my $Pet = $npc->GetPetSpellID();
	my $SwarmPet = $npc->GetSwarmOwner();
	$npc_type = 0;
	$npc_naming = "NPC";
	if(substr($npc->GetName(), 0, 1) eq "#" && substr($npc->GetName(), 1, 2) ne "#") {
		$npc_type = 1;
		$npc_naming = "Named";
	} 
	
	if(substr($npc->GetName(), 0, 2) eq "##" && substr($npc->GetName(), 2, 3) ne "#") {
		$npc_type = 2;
		$npc_naming = "Raid";
	}
	ScaleProcedure();
}

sub ScaleProcedure {
	if(!$scaling_data[1][0][0]) {
		LoadScaling();
	} #:::  Scaling Vars Empty, reload them from DB
	#if(!$instanceversion) { $instanceversion = 1; }
	#if(!$zonesn) { $zonesn = "ferubi"; }
	my @npc_list = $entity_list->GetNPCList();
	foreach $NPC (@npc_list) {
		if (
			$NPC->GetPetSpellID() == 0 &&
			$NPC->GetRace() !~ [127, 240] &&
			$NPC->GetClass() < 20 &&
			$NPC->GetNPCTypeID() > 1000 &&
			(
				!$NPC->EntityVariableExists("Scaled") ||
				($NPC->EntityVariableExists("Scaled") && $NPC->GetEntityVariable("Scaled") != 1)
			)
		) {
			my (
				$armor,
				$hp,
				$accuracy,
				$slow_mitigation,
				$attack,
				$mindmg,
				$maxdmg,
				$regen,
				$atkspeed,
				$special_abilities
			) = (
				$scaling_data[$NPC->GetLevel()][$npc_type][2],
				$scaling_data[$NPC->GetLevel()][$npc_type][3],
				$scaling_data[$NPC->GetLevel()][$npc_type][4],
				$scaling_data[$NPC->GetLevel()][$npc_type][5],
				$scaling_data[$NPC->GetLevel()][$npc_type][6],
				$scaling_data[$NPC->GetLevel()][$npc_type][7],
				$scaling_data[$NPC->GetLevel()][$npc_type][8],
				$scaling_data[$NPC->GetLevel()][$npc_type][9],
				$scaling_data[$NPC->GetLevel()][$npc_type][10],
				$scaling_data[$NPC->GetLevel()][$npc_type][11]
			);
			
			$npc_type = 0;
			$npc_naming = "NPC";
			if(substr($NPC->GetName(), 0, 1) eq "#" && substr($NPC->GetName(), 1, 2) ne "#") {
				$npc_type = 1;
				$npc_naming = "Named";
			}
			
			if(substr($NPC->GetName(), 0, 2) eq "##" && substr($NPC->GetName(), 2, 3) ne "#") {
				$npc_type = 2;
				$npc_naming = "Raid";
			}

			my (
				$new_health,
				$new_min_damage,
				$new_max_damage,
				$new_attack_delay,
				$new_armor_class,
				$new_accuracy,
			) = (
				int($hp * $zone_scaling_data{$zonesn}[$instanceversion][$npc_type][2]),
				int($mindmg * $zone_scaling_data{$zonesn}[$instanceversion][$npc_type][4]),
				int($maxdmg * $zone_scaling_data{$zonesn}[$instanceversion][$npc_type][5]),
				int($atkspeed * $zone_scaling_data{$zonesn}[$instanceversion][$npc_type][6]),
				int($armor * $zone_scaling_data{$zonesn}[$instanceversion][$npc_type][7]),
				int($accuracy + ($npc->GetLevel() * 15)),
			);

			$NPC->ModifyNPCStat("max_hp", $new_health);
			$NPC->SetHP($NPC->GetMaxHP());
			$NPC->ModifyNPCStat("min_hit", $new_min_damage);
			$NPC->ModifyNPCStat("max_hit", $new_max_damage);
			$NPC->ModifyNPCStat("attack_delay", $new_attack_delay);
			$NPC->ModifyNPCStat("ac", $new_armor_class);
			$NPC->ModifyNPCStat("special_abilities", $special_abilities);
			$NPC->ModifyNPCStat("slow_mitigation", $slow_mitigation);
			$NPC->ModifyNPCStat("accuracy", $new_accuracy);
			$NPC->ModifyNPCStat("hp_regen", $regen);
			$NPC->RecalculateSkills();
			
			if(defined $zone_scaling_data{$zonesn}[$instanceversion][$npc_type][11]) {
				$NPC->ModifyNPCStat("special_abilities", $zone_scaling_data{$zonesn}[$instanceversion][$npc_type][11]);
			} else {
				$NPC->ModifyNPCStat("special_abilities", $special_abilities);
			}
			$NPC->SetHP($NPC->GetMaxHP());
			$NPC->SetEntityVariable("Scaled", 1);
			
			if($Debug) {
				$NPC->SetEntityVariable("ScaledType", 1);
			} 
			
			if(!$scaling_data[$NPC->GetLevel()][$npc_type][0]) {
				quest::gmsay($NPC->GetCleanName() . ": ERROR! Missing Scaling Entry! 
					For level " . $NPC->GetLevel() . " Type: $npc_type", 13
				);
			}
		}
		if($NPC->GetLevel() == 255) {
			$NPC->ModifyNPCStat("special_abilities", "24,1^35,1");
		} 
	}
}

sub LoadScaling {
	$connect = plugin::LoadMysql();
	$query = "SELECT
		npc_scale_global_base.level,
		npc_scale_global_base.type,
		npc_scale_global_base.ac,
		npc_scale_global_base.hp,
		npc_scale_global_base.accuracy,
		npc_scale_global_base.slow_mitigation,
		npc_scale_global_base.attack,
		npc_scale_global_base.min_dmg,
		npc_scale_global_base.max_dmg,
		npc_scale_global_base.hp_regen_rate,
		npc_scale_global_base.attack_delay,
		npc_scale_global_base.special_abilities
		FROM
		npc_scale_global_base
		ORDER BY npc_scale_global_base.level, npc_scale_global_base.type";
	$query_handle = $connect->prepare($query);
	$query_handle->execute();
	while (@row = $query_handle->fetchrow_array()) {
		$scaling_data[$row[0]][$row[1]] = [@row];
	}
	plugin::GM("= | Scaling Reloaded.");
}

sub LoadStaticZoneScaling {
	#:::  Load Static Zone Scaling Data #:::  
	$connect = plugin::LoadMysql();
	#:::  Default empty values to 1
	for($i = 2; $i < 17; $i++){ 
		for($t = 0; $t < 3; $t++){
			if (
				!$zone_scaling_data{$zonesn}[$instanceversion][$t][$i] ||
				$zone_scaling_data{$zonesn}[$instanceversion][$t][$i] eq ""
			){ 
				$zone_scaling_data{$zonesn}[$instanceversion][$t][$i] = 1; 
			}
		}
	} 
	
	$query = "SELECT `zonesn`, `version`, `hp`, `mana`, `mindmg`, `maxdmg`, `attack_speed`, `ac`, `healscale`, `spellscale`, `hpregen`, `specialattacks`, `type`, `accuracy` FROM `cust_npc_zonescale_static` WHERE `zonesn` = '$zonesn'";
	$query_handle = $connect->prepare($query);
	$query_handle->execute();
	my @SZD;
	while (@row = $query_handle->fetchrow_array()){ 
		my (
			$type,
			$hp_modifier,
			$mana_modifier,
			$min_damage_modifier,
			$max_damage_modifier,
			$attack_speed_modifier,
			$armor_class_modifier,
			$heal_scale_modifier,
			$spell_scale_modifier,
		) = (
			$row[12],
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][2] * 100),
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][3] * 100),
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][5] * 100),
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][6] * 100),
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][7] * 100),
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][8] * 100),
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][9] * 100),
			($zone_scaling_data{$zonesn}[$instanceversion][$row[12]][9] * 100),
		);
		$zone_scaling_data{$row[0]}[$row[1]][$row[12]] = [@row];  
		if($zone_scaling_data{$zonesn}[$instanceversion][0]){
			$Mod = $zone_scaling_data{$zonesn}[$instanceversion][2];
			$npc->SetEntityVariable("ScaleMod", $Mod);
			if (
				(
					!$npc->EntityVariableExists("TypeZero") &&
					$type == 0
				) || 
				$type != 0
			) {
				$npc->SetEntityVariable("TypeZero", 1) if ($type == 0);
				plugin::GM("= | Zone Controller");
				plugin::GM("== | Type $type");
				plugin::GM("=== | HP $hp_modifier%% | Mana $mana_modifier%%");
				plugin::GM("=== | Min Damage $min_damage_modifier%% | Max Damage $max_damage_modifier%%");
				plugin::GM("=== | Attack Speed $attack_speed_modifier%% | Armor Class $armor_class_modifier%%");
				plugin::GM("=== | Spell Scale $spell_scale_modifier%% | Heal Scale $heal_scale_modifier%%");
			}
		}
	}
}

sub CalculateLevelScaling { #:: Return an appropriate level to scale NPCs
	#my $Debug = " ";

	my $avglevel = 0;
	my $peoplecount = 0;
	my $addedlevels = 0;

	my @CL = $entity_list->GetClientList();
	my @LL;
	foreach my $person (@CL) {
		push @LL, $person->GetLevel();
		$addedlevels = ($person->GetLevel())+$addedlevels;
	}
	foreach my $value (@LL) {
		$peoplecount++;
		@LL = grep { $_ ne '' } @LL;
		#if($Debug) {quest::shout("$value");}	#::Debug to see if we have any whitespace or zeros in array
	}
	
	if($peoplecount > 1) {		#:: Scaling for Groups
		my (
			$min,
			$max
		) = (
			sort {$a <=> $b} @LL
		)[0, -1];	#:: Define lowest/highest level players.
		if($max >= ($min + 15)) {		#:: medium level disparity (10+level difference between lowest and highest level players) 
			$avglevel = int((($max - (($max - $min) / 2)) * $peoplecount) / $peoplecount);
			if($Debug) {
				quest::shout("levels a bit far apart.. $avglevel");
			}
		} else {	#:: Scale for players within appropriate level ranges
			$avglevel = int($addedlevels / $peoplecount);
			$avglevel = ($avglevel + 2);	#:: Just to make sure highest-level player isn't carrying a whole group
			if($Debug) {
				quest::shout("levels appropriate.. $avglevel");
			}
		}
	} else {	#:: Scaling SOLO
		$avglevel = $addedlevels;
	}
	return $avglevel;
}
