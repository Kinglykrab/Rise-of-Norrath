sub ClientTargetInfo {
    my $client = plugin::val('client');
	my $client_target = $client->GetTarget()->CastToClient();
	my (
		$client_name,
		$client_level,
		$client_health,
		$client_max_health,
		$client_mana,
		$client_max_mana,
		$client_endurance,
		$client_max_endurance,
		$client_race,
		$client_race_name,				
		$client_class,
		$client_class_name,
		$client_progression,
		$client_prestige,
		$client_account_id,
		$client_account_name,
		$client_account_ip,
		$client_character_id,
	) = (
		$client_target->GetCleanName(),
		$client_target->GetLevel(),
		plugin::commify($client_target->GetHP()),
		plugin::commify($client_target->GetMaxHP()),
		plugin::commify($client_target->GetMana()),
		$client_target->GetMaxMana(),
		plugin::commify($client_target->GetEndurance()),
		plugin::commify($client_target->GetMaxEndurance()),
		$client_target->GetRace(),
		quest::getracename($client_target->GetRace()),
		$client_target->GetClass(),
		quest::getclassname($client_target->GetClass()),
		plugin::Data($client_target, 3, "Progression"),
		plugin::Data($client_target, 3, "Prestige"),
		$client_target->AccountID(),
		$client_target->AccountName(),
		plugin::IP($client_target->GetIP()),
		$client_target->CharacterID(),
	);
	plugin::TargetMessage("= | Player Info");
	plugin::TargetMessage(
		"== |
		Account: " . quest::saylink("#who $client_account_name", 0, $client_account_name) . " ($client_account_id) |
		IP: " . quest::saylink("#who $client_account_ip", 0, $client_account_ip)
	);
	plugin::TargetMessage(
		"== | 
		Name: " . quest::saylink("#who $client_name", 0, $client_name) . " ($client_character_id) | 
		Level: " . quest::saylink("#who $client_level", 0, $client_level)
	);
	plugin::TargetMessage(
		"== | 
		Health: $client_health/$client_max_health | " . 
		(
		$client_max_mana > 0 ?
		"Mana: $client_mana/" . 
		plugin::commify($client_max_mana) . 
		" | " : 
		"") . 
		"Endurance: $client_endurance/$client_max_endurance"
	);
	plugin::TargetMessage(
		"== |
		Race: " . quest::saylink("#who $client_race_name", 0, $client_race_name) . " ($client_race) | 
		Class: " . quest::saylink("#who $client_class_name", 0, $client_class_name) . " ($client_class)"
	);
	plugin::TargetMessage(
		"== | 
		Tier: $client_progression | 
		Prestige: $client_prestige"
	);
	plugin::TargetMessage(
		"== | " . 
		quest::saylink("#currencies", 0, "Currencies") .
		" | " .
		quest::saylink("#advskills", 1, "Advanced Skills") .
		" | " .
		quest::saylink("#magelo $client_name", 1, "Magelo")
	);
}

sub NPCTargetInfo {
    my $client = plugin::val('client');
    my $client_target = $client->GetTarget()->CastToNPC();
    my $name_type = "NPC";
    if(substr($client_target->GetName(), 0, 1) eq "#" && substr($client_target->GetName(), 1, 2) ne "#") {
		$name_type = "Named";
	}
    if(substr($client_target->GetName(), 0, 2) eq "##" && substr($client_target->GetName(), 2, 3) ne "#") {
		$name_type = "Raid Target";
	}
    if($client_target->GetLevel == 255) {
		$name_type = "Quest (No-Combat) NPC";
	}
    my $target_name = $client_target->GetCleanName();
	my $target_level = $client_target->GetLevel();
    if ($name_type eq "Raid Target") {
		plugin::TargetMessage("This creature would take an army to defeat!");
	}
	
	if ($client->GetAggroCount() == 0) {
		plugin::TargetMessage("= | NPC Info");
         	plugin::TargetMessage(
		  "== | 
		   Name: $target_name (" . plugin::commify($client_target->CastToNPC()->GetNPCTypeID()) . ") | 
		   Level: $target_level | 
		   Type: $name_type"
		);
		plugin::TargetMessage(
			"== | 
			HP: " . 
			plugin::commify($client_target->GetHP()) . 
			"/" . 
			plugin::commify($client_target->GetMaxHP())
		);
		plugin::TargetMessage("== | 
			Damage: (" . 
			plugin::commify($client_target->CastToNPC()->GetMinDMG()) . 
			"/" .
			plugin::commify($client_target->CastToNPC()->GetMaxDMG()) . 
			")"
		);
		plugin::TargetMessage(
			"== | Race: " . 
			quest::getracename($client_target->GetRace()) . 
			" (" . 
			$client_target->GetRace() . 
			")" .
			" | Class: " . 
			quest::getclassname($client_target->GetClass()) . 
			" (" . 
			$client_target->GetClass() . 
			")"
		);
		plugin::TargetMessage(
			"== |						
			Spawn2: " . 
			plugin::commify($client_target->CastToNPC()->GetSp2()) . 
			" | Spawngroup: " . 
			plugin::commify($client_target->CastToNPC()->GetSpawnPointID())					
		);
		plugin::TargetMessage(
			"== | " .
			quest::saylink("#npcloot show", 0, "Loot")
		);
    }
}