sub EVENT_SAY {
	if ($text!~/^#inst/i) {
		if ($text!~/^#door/i) {
			plugin::HandleCommands();
		} else {
			if ($status >= 225) {
				plugin::HandleDoorCommands();
			}
		}
	} elsif ($text=~/^#inst/i) {
		plugin::HandleInstanceCommands($text);
	}
	
	if ($status >= 225) {
		plugin::HandleGMCommands();
	}
}

sub EVENT_SIGNAL {
	if ($signal == 999) {
		plugin::PetScale();
	} elsif ($signal == 998) {
		plugin::SwarmScale();
	} elsif ($signal == 1000) {
        plugin::HandleInstanceInvite();
	} elsif ($signal == 1001) {
		if ($client->EntityVariableExists("instance_leader")) {
			my $instance_id = $client->GetEntityVariable("instance_leader");
			plugin::Message("= | You have been promoted to the leader of instance $instance_id.", 0, 999);
		}
	} elsif ($signal == 1002) {
		if ($client->EntityVariableExists("instance_remove")) {
			my $instance_id = $client->GetEntityVariable("instance_remove");
			plugin::Message("= | You have been removed from instance $instance_id.", 0, 999);
			quest::zone($zonesn);
		}
	} elsif ($signal == 1337) {
		plugin::Message("= | You have a pending name change!");
	}
}

sub EVENT_CONNECT {
	plugin::Changelog();
	if ($status < 255) {
		if (plugin::Data($client, 3, "First_Connect") != 1) {
			plugin::Data($client, 1, "First_Connect", 1);
			plugin::Message("= | Hello $name and welcome to the Rise of Norrath!");
			plugin::Message("= | Feel free to take a look around the hub zone and find starter armor, weapons, and other miscellaneous items.");
			plugin::Message("= | We hope you enjoy your stay!");
			plugin::ServerAnnounce("$name has joined the server!");
			quest::rebind(183, 0, 0, 5);
			$client->MovePC(183, 0, 0, 5, 0);
			plugin::Data($client, 1, "Progression", 1);
		} else {
			plugin::ServerAnnounce("$name has logged in.");
			plugin::Message("= | Hello $name and welcome back to the Rise of Norrath!");
			plugin::Message("= | To view the custom commands you can say " . quest::saylink("#commands", 0) . ".",);
		}
	}
	my (
		$client_health,
		$client_max_health,
		$client_mana,
		$client_max_mana,
		$client_endurance,
		$client_max_endurance,
		$client_race,		
		$client_class,
		$client_progression,
		$client_prestige,
		$client_account_id,
		$client_account_name,
		$client_account_ip,
	) = (
		plugin::commify($client->GetHP()),
		plugin::commify($client->GetMaxHP()),
		plugin::commify($client->GetMana()),
		plugin::commify($client->GetMaxMana()),
		plugin::commify($client->GetEndurance()),
		plugin::commify($client->GetMaxEndurance()),
		$client->GetRace(),
		$client->GetClass(),
		plugin::Data($client, 3, "Progression"),
		plugin::Data($client, 3, "Prestige"),
		$client->AccountID(),
		$client->AccountName(),
		plugin::IP($client->GetIP()),
	);
	plugin::GM(
		"= | " . 
		quest::saylink("#who $name", 0, $name) . 
		" (" . 
		quest::saylink("#magelo $name", 0, "Magelo") . 
		") has logged in.");
	plugin::GM(
		"== |
		Account: " . quest::saylink("#who $client_account_name", 0, $client_account_name) . " ($client_account_id) |
		IP: " . quest::saylink("#who $client_account_ip", 0, $client_account_ip)
	);
	plugin::GM(
		"== | 
		Level: " . quest::saylink("#who $ulevel", 0, $ulevel)
	);
	plugin::GM(
		"== | 
		Health: $client_health/$client_max_health | " . 
		($client->GetMaxMana() > 0 ? "Mana: $client_mana/$client_max_mana | " : "") . "
		Endurance: $client_endurance/$client_max_endurance"
	);
	plugin::GM(
		"== |
		Race: " . quest::saylink("#who $race", 0, $race) . " ($client_race) | 
		Class: " . quest::saylink("#who $class", 0, $class) . " ($client_class)"
	);
	plugin::GM(
		"== | 
		Tier: $client_progression | 
		Prestige: $client_prestige"
	);
}

sub EVENT_POPUPRESPONSE {
	plugin::HandlePopup($popupid);
}

sub EVENT_ENTERZONE {
	quest::settimer("Zone", 1);
}

sub EVENT_TIMER {
	if ($timer eq "Zone") {
		quest::stoptimer("Zone");
        plugin::AddStats(1);
		if ($status < 80) {
			if (plugin::ProgressionZone(1) != 1 && plugin::Data($client, 3, "Progression") < plugin::ProgressionZone(1)) {
				plugin::Message("You are not flagged for this zone!");
				$client->GoToBind();
			}
			
			if ((plugin::PrestigeZone(0) && plugin::Data($client, 3, "Progression") < 20) || plugin::Data($client, 3, "Prestige") < plugin::PrestigeZone(1)) {
				plugin::Message("You are not the proper Prestige for this zone!");
				$client->GoToBind();
			}
		
			if (!plugin::ServerData(3, "Donator-" . plugin::IP($client->GetIP())) && $zonesn eq "pofire") {
				plugin::Message("You are not a donator!");
				$client->GoToBind();
			}
			
			if (plugin::Data($client, 3, "Progression") < 20 && $zonesn eq "oldfieldofbone") {
				plugin::Message("You are not flagged for this zone, you must be flagged for Tier 20 first!");
				$client->GoToBind();
			}

			if (
				(
					!plugin::Data($client, 3, "Epic 2.0") ||
					plugin::Data($client, 3, "Progression") < 10
				) &&
				$zonesn ~~ ["poair", "poinnovation", "pojustice", "ponightmare", "potorment", "growthplane"]) {
				plugin::Message("You are not flagged for this zone, you must complete your Epic 2.0 and flagged for Tier 10!");
				$client->GoToBind();
			}
		}
		
		if (plugin::Data($client, 3, "Race")) {
			quest::playerrace(plugin::Data($client, 3, "Race"));
		}
		
		if (plugin::Data($client, 3, "Gender")) {
			quest::playergender(plugin::Data($client, 3, "Gender"));
		}
		
		if (plugin::Data($client, 3, "Texture")) {
			quest::playertexture(plugin::Data($client, 3, "Texture"));
		}
	}
}

sub EVENT_TARGET_CHANGE {
	if ($status == 255) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			plugin::ClientTargetInfo();
		} elsif ($client->GetTarget() && $client->GetTarget()->IsNPC()) {
			plugin::NPCTargetInfo();
		}
	}

	if ($client->GetTarget() && $client->GetTarget()->IsNPC() && $client->GetTarget()->GetOwnerID() == $client->GetID()) {
		if ($client->GetTarget() && $client->GetPetID() > 0 && $client->GetTarget()->GetID() == $client->GetPetID()) {
			plugin::Message("=  | " . quest::saylink("petmenu", 1, "Pet Menu"));
		}
	}
}

sub EVENT_TASKACCEPTED {
	my %prestige_hash = (1 => ["The Dragon Slayer", [32, 73, 91, 94]],
	2 => ["Vanquisher of the Shade", [0, 0, 0, 0]],
	3 => ["The Shadow Slayer", [0, 0, 0, 0]],
	4 => ["The Dragon Lord", [0, 0, 0, 0]],
	5 => ["Master of Discord", [0, 0, 0, 0]],
	6 => ["6", [0, 0, 0, 0]],
	7 => ["7", [0, 0, 0, 0]],
	8 => ["8", [0, 0, 0, 0]],
	9 => ["9", [0, 0, 0, 0]],
	10 => ["10", [0, 0, 0, 0]]);
	if ($task_id ~~ [201..210]) {
		my $prestige = ($task_id - 200);
		my @zones = @{$prestige_hash{$prestige}[1]};
		plugin::Whisper(
			"Be warned $name, this task requires determination, willpower, and strength.
			You will be fighting in the following zones:"
		);
		my $index = 1;
		foreach my $zone (@zones) {
			plugin::Message($index++ . ". " . quest::saylink("#peqzone " . plugin::Zone("SN", $zone), 1, plugin::Zone("LN", $zone)));
		}
	}
}

sub EVENT_TASK_COMPLETE {
	if ($task_id ~~ [201..203]) {
		my $prestige = ($task_id - 200);
		if ($task_id == 201) {
			plugin::ServerAnnounce("$name has prestiged for the first time!");
			plugin::Data($client, 1, "Prestige", $prestige);
			plugin::Message("You are now flagged for Prestige " . plugin::Tier($prestige) . "!");
		} elsif ($task_id == 202) {
			plugin::ServerAnnounce("$name has prestiged for the second time!");
			plugin::Data($client, 1, "Prestige", $prestige);
			plugin::Message("You are now flagged for Prestige " . plugin::Tier($prestige) . "!");
		} elsif ($task_id == 203) {
			my %items_hash = (
				"Warrior" => 153000,
				"Cleric" => 153001,
				"Paladin" => 153002,
				"Ranger" => 153005,
				"Shadowknight" => 153007,
				"Druid" => 153008,
				"Monk" => 153009,
				"Bard" => 153010,
				"Rogue" => 153011,
				"Shaman" => 153012,
				"Necromancer" => 153013,
				"Wizard" => 153014,
				"Magician" => 153015,
				"Enchanter" => 153016,
				"Beastlord" => 153017,
				"Berserker" => 153018,
			);
			plugin::ServerAnnounce("$name has prestiged for the third time!");
			plugin::Data($client, 1, "Prestige", $prestige);
			quest::summonitem($items_hash{$class});
			plugin::GearAnnounce($items_hash{$class});
			plugin::Message("You are now flagged for Prestige " . plugin::Tier($prestige) . "!");
		}
	}
}

sub EVENT_USE_SKILL {
	if ($client->GetTarget()) {
		my $target = $client->GetTarget();
		plugin::HandleSkill($client, $skill_id, $target);
	}
}

sub EVENT_CAST {
	if ($client->GetTarget()) {
		my $target = $client->GetTarget();
		plugin::HandleCast($client, $spell_id, $target);
	}
}

sub EVENT_LEVEL_UP {
	if ($ulevel == 70 && plugin::Data($client, 3, "Level70") == 0) {
		my $emblem = plugin::ProgressionEmblems();
		my $currency_id = quest::getcurrencyid($emblem);
		plugin::Data($client, 1, "Level70",1);
		plugin::SetProgressionFlag($client, 1);
		plugin::Message("You are now flagged for Tier 1!");
		plugin::ServerAnnounce("$name has reached level 70!");
		$client->Message(15, "You have been awarded 8 class shards! Welcome to level 70!");
		plugin::AddCurrency($client, $currency_id, 8);
	}
	foreach my $skill_id (0..42, 48..55, 70..74, 76, 77) {
		if ($client->CanHaveSkill($skill_id)) {
			my $max_skill = $client->MaxSkill(
				$skill_id, 
				$client->GetClass(), 
				$client->GetLevel()
			);
			if ($client->GetRawSkill($skill_id) < $max_skill) {
				$client->SetSkill($skill_id, $max_skill);
			}
		}
	}
	quest::scribespells($ulevel, 1);
	quest::traindiscs($ulevel, 1);
}

sub EVENT_CLICKDOOR {
	if($status > 100) {
		plugin::HandleDoorClick();
	}
}
