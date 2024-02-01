sub HandleCommands {
	my $client = plugin::val('client');
	my $text = plugin::val('text');
	my $instanceid = plugin::val('instanceid');
	my $entity_list = plugin::val('entity_list');
	my $client_pet = 0;
	my $client_ip = plugin::IP($client->GetIP());
	my $donator_flag = plugin::ServerData(3, "Donator-$client_ip");
	if ($entity_list->GetNPCByID($client->GetPetID())) {
		$client_pet = $entity_list->GetNPCByID($client->GetPetID());
	} 
	my %commands = (
		1 => ["#scale", "Scales your pet."],
		2 => ["#home", "Sends you to the hub zone."],
		3 => ["#inst", "Instance commands."],
		4 => ["#skills", "Maxes your skills for your level."],
		5 => ["#buffs", "Buffs you for " . plugin::commify(plugin::BuffCost() * 10) . " Platinum. (Once every 5 minutes.)"],
		6 => ["#progress", "View your Progression flags."],
		7 => ["#changelog", "View our most recent changes and download the client files."],
		8 => ["#playersearch", "Look up a player's magelo profile in-game using: #playersearch name"],
		9 => ["#spellsearch", "Look up a spell using the spell's ID in-game using: #spellsearch spellid"],
	);
	if ($donator_flag) {
		$commands{8} = ["donator", "Sends you to the Donator-only farming zone."];
	}
	if($text=~/#lich/i) {
		my @arg = split(' ', $text);
		if($client->GetClass() == 11) {
			if(!$arg[1]) {
				plugin::Message("-Lich Illusion Options");
				##$client->Message(15, "" . $client->GetClass() . "");
				plugin::Message("[" . quest::saylink("#lich skeleton",1,"Skeleton") . "] - [" . quest::saylink("#lich spectre",1,"Spectre") . "] - [" . quest::saylink("#lich mummy",1,"Mummy") . "]");
			}
			elsif($arg[1] ~~ ["skeleton","mummy","spectre"]) {
				plugin::Message("good");
			}
		}
	}
	if ($text=~/#playersearch/i) {
		my @arg = split(' ', $text);
		my $base_url = "http://ingame.eqempires.com/index.php?page=character&char=";
		if($arg[1]) { $client->SendWebLink("" . $base_url . "" . $arg[1] . ""); } else { $client->Message(15, "Error: You must supply a (non-GM) character name to search."); }
	}
	if ($text=~/#spellsearch/i) {
		my @arg = split(' ', $text);
		my $base_url = "http://alla.eqempires.com/?a=spell&id=";
		if($arg[1]) { $client->SendWebLink("" . $base_url . "" . $arg[1] . ""); } else { $client->Message(15, "Error: You must supply a spell ID to search."); }
	}
	if ($text=~/#Scale/i) {
		if ($client->GetPetID() > 0) {
			plugin::PetScale();
		} else {
			plugin::Message("You do not have a pet spawned!");
		}
	} elsif ($text=~/#Home/i) {
		if ($client->GetAggroCount() == 0) {
			$client->MovePC(183, 0, 0, 4, 0);
		} else {
			plugin::Message("You cannot use #home in combat!");
		} 
	} elsif ($text=~/#Skills/i) {
		foreach my $skill_id (0..42, 48..55, 62, 70..77) {
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
	} elsif ($text=~/#Buffs/i) {
		if (plugin::Data($client, 3, "Buffs") != 1) {
			if ($client->GetAggroCount() == 0) {
				plugin::HandleBuffs("Command", $client);
				plugin::Data($client, 2, "Buffs", 1, "M5");
			} else {
				plugin::Message("You cannot use #buffs in combat!");
			}
		} else {
			plugin::Message("You can only use #buffs once every 5 minutes.");
		}
	} elsif ($text=~/#Changelog/i) {
		plugin::Changelog();
	}	elsif ($text=~/#Progress/i) {
		plugin::Message("You are flagged for up to Tier " . plugin::Tier(plugin::Data($client, 3, "Progression")) . ".");
	} elsif ($text=~/#Donator/i) {
		if ($donator_flag) {
			quest::zone("pofire");
		} else {
			plugin::Message("You are not a donator.");
		}
	} elsif ($text=~/#Commands/i) {
		plugin::Message("= | Commands List");
		foreach my $key (sort {$a <=> $b} keys %commands) {
			my ($command, $info) = @{$commands{$key}};
			plugin::Message("== | " . quest::saylink($command, 0));
			plugin::Message("=== | $info");
		}
	} elsif ($text eq "petmenu") {
		plugin::Message(
			"== | " . 
			quest::saylink("petname", 1, "Name") . " | " .
			quest::saylink("petrace", 1, "Race") . " | " .
			quest::saylink("petgender", 1, "Gender") . " | " .
			quest::saylink("pettexture", 1, "Texture") . " | " .
			quest::saylink("petsize", 1, "Size") . " | " .
			quest::saylink("petgear", 1, "Gear") . " | " .
			quest::saylink("petreset", 1, "Reset") . " | " .
			quest::saylink("petinfo",1,"Scaling Info")
		);
	} elsif ($text eq "petinfo") {
		if($client->GetPetID()) {
			my $npc = $entity_list->GetNPCByID($client->GetPetID());
			my %scale_data = (
				"max_hp" => ["Health", $npc->GetMaxHP()],
				"min_hit" => ["Minimum Damage", $npc->GetMinDMG()],
				"max_hit" => ["Maximum Damage", $npc->GetMaxDMG()],
				"ac" => ["Armor Class", $npc->GetAC()],
				"atk" => ["Attack", $npc->GetATK()],
				"agi" => ["Agility", $npc->GetAGI()],
				"cha" => ["Charisma", $npc->GetCHA()],
				"dex" => ["Dexterity", $npc->GetDEX()],
				"int" => ["Intelligence", $npc->GetINT()],
				"sta" => ["Stamina", $npc->GetSTA()],
				"str" => ["Strength", $npc->GetSTR()],
				"wis" => ["Wisdom", $npc->GetWIS()],
				"healscale" => ["Heal Scale", 100],
				"spellscale" => ["Spell Scale", 100],
			);
			my (
				$damage_modifier,
				$health_modifier,
				$health,
				$min_hit,
				$max_hit,
				$armor_class,
				$attack,
				$agility,
				$charisma,
				$dexterity,
				$intelligence,
				$stamina,
				$strength,
				$wisdom,
				$heal_scale,
				$spell_scale
			) = (
				plugin::GetModifier(1),	#:: Weight Damage Harder than Health - Splose
				plugin::GetModifier(0),
				$scale_data{"max_hp"}[1],
				$scale_data{"min_hit"}[1],
				$scale_data{"max_hit"}[1],
				$scale_data{"ac"}[1],
				$scale_data{"atk"}[1],
				$scale_data{"agi"}[1],
				$scale_data{"cha"}[1],
				$scale_data{"dex"}[1],
				$scale_data{"int"}[1],
				$scale_data{"sta"}[1],
				$scale_data{"str"}[1],
				$scale_data{"wis"}[1],
				$scale_data{"healscale"}[1],
				$scale_data{"spellscale"}[1],
			);
			plugin::DisplayScaling(
				$damage_modifier,
				$health_modifier,
				$health / $health_modifier,
				$min_hit / $damage_modifier,
				$max_hit / $damage_modifier,
				$armor_class / $damage_modifier,
				$attack / $damage_modifier,
				$agility / $damage_modifier,
				$charisma / $damage_modifier,
				$dexterity / $damage_modifier,
				$intelligence / $damage_modifier,
				$stamina / $damage_modifier,
				$strength / $damage_modifier,
				$wisdom / $damage_modifier,
				$heal_scale,
				$spell_scale,
			);
		}
	} elsif ($text eq "petname") {
		plugin::Message("=== | Simply say \"petname name\", length is limited to 1-32.");
	} elsif ($text=~/^petname/i) {
		if (length($text) > 7 && length(substr($text, 8)) ~~ [1..32]) {
			my $new_name = substr($text, 8);
			if ($new_name !~ /[0-9]/i) {
				plugin::Data($client, 1, "pet-name", $new_name);
				if ($client_pet) {					
					$client_pet->TempName($new_name);
				}
			} else {
				plugin::Message("=== | A pet's name may not contain numbers, please enter a valid name.");
			}
		} else {
			plugin::Message("=== | Please enter a valid name.");
		}
	} elsif ($text eq "petrace") {
		plugin::Message("=== | Simply say \"petrace race\", use " . quest::saylink("#findrace", 0) . " to find a race.");
	} elsif ($text=~/^petrace/i) {
		if (length($text) > 7 && length(substr($text, 8)) >= 1) {
			my $new_race = substr($text, 8);
			if ($new_race ~~ [1..724]) {
				plugin::Data($client, 1, "pet-race", $new_race);
				if ($client_pet) {
					$client_pet->SendIllusion($new_race);
				}
			} else {
				plugin::Message("=== | Please enter a valid race.");
			}
		} else {
			plugin::Message("=== | Please enter a valid race.");
		}
	} elsif ($text eq "petgender") {
		plugin::Message("=== | Simply say \"petgender gender\". (0 = Male, 1 = Female, 2 = Neuter)");
	} elsif ($text=~/^petgender/i) {
		if (length($text) > 9 && length(substr($text, 10)) >= 1) {
			my $new_gender = substr($text, 10);
			if ($new_gender ~~ [0..2]) {
				plugin::Data($client, 1, "pet-gender", $new_gender);
				if ($client_pet) {
					$client_pet->SendIllusion($client_pet->GetRace(), $new_gender);
				}
			} else {
				plugin::Message("=== | Please enter a valid gender.");
			}
		} else {
			plugin::Message("=== | Please enter a valid gender.");
		}
	} elsif ($text eq "pettexture") {
		plugin::Message("=== | Simply say \"pettexture texture\" with texture being a value between 0 and 16.");
	} elsif ($text=~/^pettexture/i) {
		if (length($text) > 10 && length(substr($text, 11)) >= 1) {
			my $new_texture = substr($text, 11);
			if ($new_texture ~~ [0..16]) {
				plugin::Data($client, 1, "pet-texture", $new_texture);
				if ($client_pet) {
					$client_pet->SendIllusion($client_pet->GetRace(), $client_pet->GetGender(), $new_texture);
				}
			} else {
				plugin::Message("=== | Please enter a valid texture.");
			}
		} else {
			plugin::Message("=== | Please enter a valid texture.");
		}
	} elsif ($text eq "petsize") {
		plugin::Message("=== | Simply say \"petsize size\" with size being a value between 1 and 10.");
	} elsif ($text=~/^petsize/i) {
		if (length($text) > 7 && length(substr($text, 8)) >= 1) {
			my $new_size = substr($text, 8);
			if ($new_size ~~ [1..10]) {
				plugin::Data($client, 1, "pet-size", $new_size);
				if ($client_pet) {
					$client_pet->ChangeSize($new_size);
				}
			} else {
				plugin::Message("=== | Please enter a valid size.");
			}
		} else {
			plugin::Message("=== | Please enter a valid size.");
		}
	} elsif ($text eq "petreset") {
		plugin::Data($client, 0, "pet-$_") for ("name", "race", "gender", "texture", "size");
		plugin::Message("=== | Pet settings reset.");
		$client_pet->TempName($client_pet->GetCleanName());
		$client_pet->SendIllusion($client_pet->GetBaseRace());
	} elsif ($text eq "petgear") {
		plugin::PetGear();
	}
}

sub HandleInstanceCommands {
	my %commands = (
		"Accept" => ["#inst accept", "Accept an instance invite."],
		"Decline" => ["#inst decline", "Decline an instance invite."],
		"Help" => ["#inst help", "Displays all instancing commands."],
		"Invite" => ["#inst invite [name] [name] [name]", "Invites a single or multiple players to the instance if you are the leader."],
		"Join" => ["#inst join [instanceid]", "Joins an instance by ID that you are a member of."],
		"List" => ["#inst list", "Lists the instances you are a member of."],
		"Promote" => ["#inst promote [name]", "Promotes the player to the leader of the instance if you are the leader."],
		"Remove" => ["#inst remove [name]", "Removes the player from your instance if you are the leader."],
	);
	my $client = plugin::val('client');
	my $character_id = plugin::val('charid');
	my $character_name = quest::getcharnamebyid($character_id);
	my $instance_id = plugin::val('instanceid');
	my $instance_type = plugin::ServerData(3, "Instance-Type-$instance_id");
	my $leader_bucket = plugin::ServerData(3, "Instance-Leader-$instance_id");
	my $text = shift;
	if ($text=~/^#Inst/i) {
		if (length($text) > 6) {
			my @args = split(/ /, substr($text, 6));
			my ($command, @command_values) = @args;
			if ($command=~/Accept/i) {
				my $invite_bucket = quest::getcharnamebyid($character_id) . "-instance-data";
				my $invite_data_json = plugin::ServerData(3, $invite_bucket);
				if ($invite_data_json) {
					use JSON qw(decode_json);
					plugin::Message("=== | Invite accepted.");
					my $time = time();
					my $invite_data = decode_json $invite_data_json;
					my $instance_id = $invite_data->{instance_id};
					my $instance_type = $invite_data->{instance_type};
					my $sender_name = $invite_data->{sender_name};
					my $inviter_id = quest::getcharidbyname($sender_name);
					my (
						$sender_x, 
						$sender_y, 
						$sender_z
					) = (
						$invite_data->{sender_x}, 
						$invite_data->{sender_y}, 
						$invite_data->{sender_z}
					);
					my $zone_id = $invite_data->{zone_id};
					my $zone_long_name = plugin::Zone("LN", $zone_id);
					my $zone_short_name = plugin::Zone("SN", $zone_id);
					my $zone_time_remaining = plugin::ServerData(5, "$inviter_id-Instance-Lockout-$instance_type-$zone_short_name");
					plugin::Message("= | Instance Invite from $sender_name Accepted");
					plugin::Message("== | The invite was successfully accepted, entering your instance of $zone_long_name now.");
					plugin::Data($client, 1, "Join-Log-$time", $invite_data_json);
					plugin::Data($client, 2, "Instance-Lockout-$instance_type-$zone_short_name", $instance_type, $zone_time_remaining);
					quest::AssignToInstance($instance_id);
					quest::MovePCInstance($zone_id, $instance_id, $sender_x, $sender_y, $sender_z, 0);
				}
			} elsif ($command=~/Decline/i) {
				my $invite_bucket = quest::getcharnamebyid($character_id) . "-instance-data";
				my $invite_data_json = plugin::ServerData(3, $invite_bucket);
				if ($invite_data_json) {
					use JSON qw(decode_json);
					my $invite_data = decode_json $invite_data_json;
					my $sender_id = $invite_data->{sender_id};
					my $sender_name = quest::getcharnamebyid($sender_id);
					plugin::Message("= | Instance Invite from $sender_name Declined");
					plugin::ServerData(0, "$character_name-instance-data");
				}
			} elsif ($command=~/Help/i) {
				plugin::Message("= | Instance Commands List");
				foreach my $key (sort {$a cmp $b} keys %commands) {
					my ($command_name, $command_info) = @{$commands{$key}};
					plugin::Message("== | " . quest::saylink($command_name, 0));
					plugin::Message("=== | $command_info");
				}
			} elsif ($command=~/Invite/i) {
				if ($character_name eq $leader_bucket) {
					if ($instance_type ~~ [1, 2]) {
						plugin::Message("Inviting " . join(", ", @command_values) . " to the instance.");
						plugin::InviteToInstance(@command_values);
					} else {
						plugin::Message("You cannot invite players to Solo instances.");
					}
				} else {
					plugin::Message("= | Instance Invite Failed");
					plugin::Message("== | You are not the leader of this instance.");
				}
			}elsif ($command=~/Join/i) {
				my $instance_id = $command_values[0];
				plugin::JoinInstance($instance_id);
			} elsif ($command=~/List/i) {
				plugin::ListInstances($character_id);
			} elsif ($command=~/Promote/i) {
				my $promote_name = $command_values[0];
				if (quest::getcharidbyname($promote_name) > 0 && $character_name eq $leader_bucket) {
					plugin::Message("Promoting $promote_name to the leader of the instance.");
					plugin::SetInstanceLeader($instance_id, $promote_name);
				} elsif (!quest::getcharidbyname($promote_name)) {
					plugin::Message("= | Instance Promote Failed");
					plugin::Message("== | You must enter a valid name.");
				} elsif ($character_name ne $leader_bucket) {
					plugin::Message("= | Instance Promote Failed");
					plugin::Message("== | You are not the leader of this instance.");
				}
			} elsif ($command=~/Remove/i) {
				my $remove_name = $command_values[0];
				if (quest::getcharidbyname($remove_name) && $character_name eq $leader_bucket) {
					plugin::Message("Removing $remove_name from the instance.");
					plugin::RemoveFromInstance($instance_id, $remove_name);
				} elsif (!quest::getcharidbyname($remove_name)) {
					plugin::Message("= | Instance Remove Failed");
					plugin::Message("== | You must enter a valid name.");
				} elsif ($character_name ne $leader_bucket) {
					plugin::Message("= | Instance Remove Failed");
					plugin::Message("== | You are not the leader of this instance.");
				}
			}
		} else {
			plugin::Message("Try " . quest::saylink("#inst help", 1) . " for help with instancing commands.");
		}
	}
}

sub HandleGMCommands {
	my $client = plugin::val('client');
	my $text = plugin::val('text');
	my $entity_list = plugin::val('entity_list');
	if($text=~/#playersuspend/i) {
		my @arg = split(' ', $text);
		if(!$arg[1]) {
			$client->Message(15, "Usage: #playersuspend Splose 24 <reason>");
		} else {
			my $p_name = $arg[1];
			my $c_name = $client->GetCleanName();
			my $time = $arg[2];
			my $reason = $arg[3];
			if($arg[4]) {
				my $reasontwo = $arg[4];
				$string = "$p_name has been SUSPENDED for $time hour(s) by $c_name. Reason: $reason $reasontwo";
			} else {
				$string = "$p_name has been SUSPENDED for $time hour(s) by $c_name. Reason: $reason";
			}
			quest::worldwidemessage(15, "$string");
		}	
	}
	if($text=~/#model/i) {
		my @arg = split(' ', $text);
		my %Models = (
		"Coral" => [12674..12699,12807..12832],
		"Mermaid" => [12726..12805],
		"Swashbuckler" => [67900..67919],
		"SwashbucklerRaid" => [67920..67939],
		"ArxMentis" => [12700..12778,112708],
		"Allyrian" => [101294..101339],
		"RingofScale" => [101227..101260,101360..101385],
		"RingofScaleRaid" => [101386..101411],
		"Halloween" => [101061..101068],
		"AnastiSulGood" => [101015..101025,101069,101070,101077],
		"Disease" => [101050..101060,101075,101076,101080],
		"Dwarven" => [101038..101049,101073,101074,101079],
		"Health" => [101026..101037,101071,101072,101078,101033,101071,101072,101078],
		"Nightmare" => [101186..101202],
		"NightmareBlue" => [101203..101219,101223],
		"BloodironGreen" => [101168..101185,101221],
		"BloodironRed" => [101150..101167,101220],
		"BloodironBlue" => [101270..101289],
		"BloodironBlueRaid" => [101340..101359],
		"SKU26" => [101437..101524],
		"DwarvenTwo" => [101532..101723]
		);
		if($arg[1] && grep( /$arg[1]/, keys %Models)) {
			foreach my $model (@{$Models{$arg[1]}}) {
				plugin::Message("File: " . $arg[1] . " - $model :Pri[" . quest::saylink("#model Apply $model 7",1,"X") . "]Sec:[" . quest::saylink("#model Apply $model 8",1,"X") . "]]");
			}
		} elsif ($arg[3] && $arg[2] && $arg[1] eq "Apply") {
			quest::wearchange($arg[3],$arg[2]);
			#$npc->SetEntityVariable("CurrModel",$arg[1]);
			plugin::Message("Changing your secondary slot model to: $arg[2]");
		} else {
			plugin::Message("You may view models from the following files:");
			my $n=0;
			foreach $key (keys %Models) {
				plugin::Message("File ($n): [" . quest::saylink("#model $key",1,"$key") . "]");
				$n++;
			}
		}
	}
	if($text=~/#spelleffect/i){ #:: Usage - #spelleffect 1
		my @arg = split(' ', $text);
		if($client->GetTarget()) {
			$client->GetTarget()->SpellEffect($arg[1]);
			$client->Message(15, "[GM] - Showing spell effect: " . $arg[1] . " on " . $client->GetTarget()->GetCleanName() . "");
		} else {
			$client->SpellEffect($arg[1]);
			$client->Message(15, "[GM] - Showing spell effect: " . $arg[1] . " on you");
		}
	}
	if($text=~/#gear/i) {
        my @arg = split(' ', $text);
        if($client->GetTarget() && $client->GetTarget()->IsClient()) {
            if($arg[2]) {
                if($arg[2] eq "confirm") {
                    plugin::Gear($client->GetTarget(),$arg[1]);
                    $client->GetTarget()->Message(15, "" . $client->GetCleanName() . " has summoned you Tier $arg[1] gear!");
                    $client->Message(15, "You have summoned " . $client->GetTarget()->GetCleanName() . " Tier $arg[1] gear.");
                }
            } else {
                $client->Message(15, "Are you sure you want to perform this action on " . $client->GetTarget()->GetCleanName() . "?");     
                $client->Message(15, "[" . quest::saylink("#gear $arg[1] confirm",1,"CONFIRM") . "]");
            }
        } else { 
            if($arg[1] <= 15) { 
                plugin::Gear($client,$arg[1]); 
            } else { 
                $client->Message("Only works up to tier 15 for now cause im lazy :)"); 
            }            
        } 
    } elsif ($text=~/#ww/i) {
        if (length($text) > 3 && length(substr($text, 4)) > 0) {
            my $spell_id = substr($text, 4);
			my $spell_name = quest::getspellname($spell_id);
			my $saylink = quest::saylink("#spellsearch $spell_id",1,"$spell_name");
            quest::worldwidecastspell($spell_id);
			quest::worldwidemessage(15, "A GM has casted " . $saylink . " server-wide!", 0, 255);	#http://alla.eqempires.com/?a=spell&id=42427
        }
    } elsif ($text=~/#SetDonator/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			plugin::Message("$client_name is now a donator.");
			plugin::ClientMessage($client_target, "You are now flagged as a Donator.");
			plugin::SetDonator($client_target);
		}
	} elsif ($text=~/#RemoveDonator/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			plugin::Message("$client_name is no longer a donator.");
			plugin::ClientMessage($client_target, "You are no longer flagged as a Donator.");
			plugin::RemoveDonator($client_target);
		}
	} elsif ($text=~/#SetFlag/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			my $tier_flag = substr($text, 9);
			if ($tier_flag ~~ [1..20]) {
				my $tier_name = plugin::Tier($tier_flag);
				plugin::Message("$client_name is now flagged for Tier $tier_name.");
				plugin::ClientMessage($client_target, "You are now flagged for Tier $tier_name.");
				plugin::SetProgressionFlag($client_target, $tier_flag);
			}
		}
	} elsif ($text=~/#SetPrestige/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			my $prestige_flag = substr($text, 13);
			if ($prestige_flag ~~ [1..20]) {
				my $prestige_name = plugin::Tier($prestige_flag);
				plugin::Message("$client_name is now flagged for Prestige $prestige_name.");
				plugin::ClientMessage($client_target, "You are now flagged for Prestige $prestige_name.");				
				plugin::Data($client_target, 1, "Prestige", $prestige_flag);
			} elsif ($prestige_flag == 0) {
				plugin::Message("$client_name is no flagged for any Prestiges.");
				plugin::ClientMessage($client_target, "You are no flagged for any Prestiges.");				
				plugin::Data($client_target, 0, "Prestige");
			}
		}
	} elsif ($text=~/#SetEpic/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			my $epic_flag = substr($text, 9);
			if ($epic_flag ~~ ["Epic 1.5", "Epic 2.0"]) {
				plugin::Message("$client_name is now flagged for $epic_flag.");
				plugin::ClientMessage($client_target, "You are now flagged for $epic_flag.");
				plugin::Data($client_target, 1, $epic_flag, 1);
			}
		}
	} elsif ($text=~/#GiveAA/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			my $aa_amount = substr($text, 8);
			if ($aa_amount > 0) {
				plugin::AddAAPoints($client_target, $aa_amount);
				my $client_aa = plugin::commify($client_target->GetAAPoints());
				my $added_amount = plugin::commify($aa_amount);
				plugin::Message("$client_name now has $client_aa AA Points after adding $added_amount AA Points.");
			} else {
				plugin::RemoveAAPoints($client_target, ($aa_amount * - 1));
				my $client_aa = plugin::commify($client_target->GetAAPoints());
				my $removed_amount = plugin::commify(($aa_amount * -1));
				plugin::Message("$client_name now has $client_aa AA Points after removing $removed_amount AA Points.");
			}
		}
	} elsif ($text=~/#RemoveBuffs/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			plugin::Data($client_target, 0, "Buffs");
			plugin::Message("$client_name\'s buff bucket has been reset.");
		}
	} elsif ($text=~/#Assign/i) {
		my $task = substr($text, 8);
		my $task_name = quest::gettaskname($task);
		if ($task_name ne "") {
			if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
				my $client_target = $client->GetTarget()->CastToClient();
				my $client_name = $client_target->GetCleanName();
				plugin::Message("$client_name now has task $task_name.");
				$client_target->AssignTask($task,0);
			}
		}
	} elsif ($text=~/#Currencies/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			my (
				$client_copper,
				$client_silver,
				$client_gold,
				$client_platinum,
				$client_ebon,
				$client_radiant,
			) = (
				plugin::commify($client_target->GetMoney(0, 0)),
				plugin::commify($client_target->GetMoney(1, 0)),
				plugin::commify($client_target->GetMoney(2, 0)),
				plugin::commify($client_target->GetMoney(3, 0)),
				plugin::commify($client_target->GetEbonCrystals()),
				plugin::commify($client_target->GetRadiantCrystals()),
			);
			plugin::Message("= | " . quest::saylink("#who $client_name", 0, $client_name) . " has the following currencies:");
			plugin::Message(
				"== | 
				$client_copper Copper | 
				$client_silver Silver | 
				$client_gold Gold | 
				$client_platinum Platinum"
			);
			plugin::Message("== | $client_ebon " . quest::varlink(40902) . "(s) | $client_radiant " . quest::varlink(40903) . "(s)");
			foreach my $currency_id (1..63) {
				my $currency_value = $client_target->GetAlternateCurrencyValue($currency_id);
				my $currency_name = quest::varlink(quest::getcurrencyitemid($currency_id));
				if ($currency_value > 0) {
					plugin::Message(
						"== | $currency_id. $currency_name (" . 
						plugin::commify($currency_value) . 
						")"
					);
				}
			}
		}
	} elsif ($text=~/#AdvSkills/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			my @melee_skills_array = plugin::MeleeSkillsArray();
			my @other_skills_array = ("Casting", "Damage", "Health", "Healing");
			plugin::Message("= | " . quest::saylink("#who $client_name", 0, $client_name) . " has the following Advanced Skills:");
			foreach my $melee_skill (@melee_skills_array) {
				my $melee_skill_name = quest::getskillname($melee_skill);
				my $melee_skill_value = plugin::Data($client_target, 3, "Advanced-$melee_skill_name");
				if ($melee_skill_value > 0) {
					plugin::Message("== | Advanced $melee_skill_name ($melee_skill_value)");
				}
			}

			foreach my $other_skill_name (@other_skills_array) {
				my $other_skill_value = plugin::Data($client_target, 3, "Advanced-$other_skill_name");
				if ($other_skill_value > 0) {
					plugin::Message("== | Advanced $other_skill_name ($other_skill_value)");
				}
			}
		}
	} elsif ($text=~/#SetCurrency/i) {
		if ($client->GetTarget() && $client->GetTarget()->IsClient()) {
			my $client_target = $client->GetTarget()->CastToClient();
			my $client_name = $client_target->GetCleanName();
			my ($currency_id, $currency_value) = split(/ /, substr($text, 13));
			if ($currency_id ~~ [1..63]) {
				$client_target->SetAlternateCurrencyValue($currency_id, $currency_value);
				plugin::Message("$client_name now has " . plugin::commify($currency_value) . " " . quest::varlink(quest::getcurrencyitemid($currency_id)) . ".");
			}
		}
	} elsif ($text=~/#playerbalance/i) {
		my $RecordsCount = plugin::Donator_Currency_Search();
		$client->Message(15, "Checking world economy for donator coins..");
		$client->Message(15, "------");
		for($i=0; $i < $RecordsCount; $i++) {
			my ($account_name,$player_name,$coins) = ($SearchResults[$i][0],$SearchResults[$i][1],$SearchResults[$i][2]);
			$client->Message(15, "" . $i+1 . ". " . quest::saylink("#who $player_name", 0, $player_name) . " has $coins coins for a total of " . $coins/100 . " dollars.");
		}
	} elsif ($text=~/#Count/i) {
		plugin::Message(plugin::GroupCount());
	} elsif ($text=~/#vl/i) {
		my $current_time = time();
		my $time = (plugin::ServerData(4, "11-AFK") - $current_time);		
		plugin::Message("A");
		plugin::Message($time);
		plugin::Message("B");
	} elsif ($text=~/#magelo/i) {
		if (length($text) > 8) {
			my @data = split(/ /, substr($text, 8));
			my $name = $data[0] ? $data[0] : "";
			if ($name ne "") {
				my $name_link = "http://ingame.eqempires.com/index.php?page=character&char=$name";
				$client->SendWebLink($name_link);
			}
		}
	}
}