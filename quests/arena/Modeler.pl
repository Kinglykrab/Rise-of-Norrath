my @npc_ids = (2000330..2000429); # Must contain 50 Model NPC IDs in sequential order
my $first_npc_id = $npc_ids[0]; # First Model NPC ID
my %race_viewer_options = ( # Option Choice => 50 Race ID Array
	0 => [1..100],
	1 => [101..200],
	2 => [201..300],
	3 => [301..400],
	4 => [401..500],
	5 => [501..600],
	6 => [601..700],
	7 => [701..732]
);
my @texture_options = (0..16); # Texture Options Array
my @gender_options = (0..2); # Gender Options Array
my @weapon_options = (
	0, 679, 1016, 2, 4, 100, 102, 104, 106, 108, 110, 
	112, 114, 116, 118, 120, 122, 124, 126, 
	128, 130, 132, 134, 136, 138, 140, 142, 
	144, 146, 148, 150, 152, 154, 156, 158, 
	160, 162, 164, 166, 168, 170, 172, 174, 
	176, 178, 180, 182, 184, 186, 188, 190, 
	192, 194, 196, 198, 200, 228, 230, 232, 
	234, 236, 238, 240, 242, 244, 246, 248, 
	250, 252,254, 256, 258, 260, 262, 264, 
	266, 268,270, 272, 274, 276, 278, 280, 
	282, 284,286, 288, 290, 292, 294, 296, 
	298, 300,302, 304, 306, 308, 350
); # Weapon Options Array
sub EVENT_SAY {
	if ($text=~/Hail/i) {
		if (!$entity_list->GetNPCByNPCTypeID($first_npc_id)) { # Check the entity list for the first Model NPC by NPC ID
			my $spawn_link = quest::saylink("spawn", 1);
			plugin::Whisper("Hail $name, would you like to $spawn_link the model NPCs?");
		} else { # Send the Modeler Options
			plugin::Message("= | Modeler Options");
			plugin::Message("== | " . quest::saylink("View $_", 1, "$_")) for ("Race", "Texture", "Gender", "Weapon");
		}
	} elsif ($text=~/^View Race$/i) { # View Race Option Choices
		plugin::Message("= | Race Options");
		foreach my $race_option (sort {$a <=> $b} keys %race_viewer_options) {
			my @races = @{$race_viewer_options{$race_option}};
			my $race_option_link = quest::saylink("option r $race_option", 0, "Race Option $race_option");
			plugin::Message("== | $race_option_link");
		}
	} elsif ($text=~/^View Gender$/i) { # View Gender Option Choices
		plugin::Message("= | Gender Options");
		foreach my $gender_option (@gender_options) {
			my $gender_option_link = quest::saylink("option g $gender_option", 0, "Gender Option $gender_option");
			plugin::Message("== | $gender_option_link");
		}
	} elsif ($text=~/^View Texture$/i) { # View Texture Option Choices
		plugin::Message("= | Texture Options");
		foreach my $texture_option (@texture_options) {
			my $texture_option_link = quest::saylink("option t $texture_option", 0, "Texture Option $texture_option");
			plugin::Message("== | $texture_option_link");
		}
	} elsif ($text=~/^View Weapon/i) { # View Weapon Option Choices
		my @data = split(/ /, $text);
		my (
			$min_option,
			$max_option,
		) = (
			0,
			9
		);
		if (defined $data[2]) {
			(
				$min_option,
				$max_option
			) = (
				$data[2],
				$data[3]
			);
		}
		my (
			$min_option_string,
			$max_option_string
		) = (
			($min_option + 1),
			($max_option + 1)
		);
		plugin::Message("= | Weapon Options $min_option_string to $max_option_string");
		my (
			$next_min_option,
			$next_max_option
		) = (
			($max_option + 1),
			($max_option + 10)
		);
		for (my $weapon_index = $min_option; $weapon_index <= $max_option; $weapon_index++) {
			if (defined $weapon_options[$weapon_index]) {
				my $weapon_option = $weapon_options[$weapon_index];
				my $model_value = ($weapon_option * 100);
				my $min_model = ($model_value + 1);
				my $min_model_string = plugin::commify($min_model);
				my $max_model = ($model_value + 100);
				my $max_model_string = plugin::commify($max_model);
				my $weapon_option_link = quest::saylink("option w $weapon_option", 0, "Weapon Option $weapon_option");
				plugin::Message("== | $weapon_option_link");
			}
		}
		
		if (defined $weapon_options[$next_min_option]) {
			my $view_weapon_link = quest::saylink("view weapon $next_min_option $next_max_option", 1, "Next 10 Options");
			plugin::Message("=== | $view_weapon_link");
		}
	} elsif ($text=~/^Spawn$/i) { # Spawn Model NPCs
		SpawnNPCs();
		plugin::Message("Modeler Options"); # Send the Modeler Options
		plugin::Message(quest::saylink("View $_", 1, "$_")) for ("Race", "Texture", "Gender", "Weapon");
	} elsif ($text=~/^Option/i) {
		if (!$entity_list->GetNPCByNPCTypeID($first_npc_id)) { # Check the entity list for the first Model NPC by NPC ID
			plugin::Message("Must spawn NPCs using Spawn Option first.");
			return;
		}
		
		if (length(substr($text, 7)) > 0) { # Check if player has specified a Modeler Option
			my ($option_type, $option_choice) = split(/ /, substr($text, 7));
			if ($option_type ~~ ["r", "g", "t", "w"] && $option_choice >= 0) { # Check if the option type matches accurate types and if the option choice is valid
				ModelNPCs($option_type, $option_choice);
			}
		}
	}
}

# SpawnNPCs(); - Spawns the Model NPCs
sub SpawnNPCs {
	if ($entity_list->GetNPCByNPCTypeID($first_npc_id)) { # Check the entity list for the first Model NPC by NPC ID
		plugin::Message("NPCs are already spawned.");
		return;
	}
	my $column = 0;
	my $row = 0;
	my $npc_index = 1;
	foreach my $npc_id (@npc_ids) { # Loop through each Model NPC ID in the 50 Model NPC ID array
		if ($column == 10) { # Number of Columns Wide
			$column = 0; # Assign the Model NPC Entity's Column to 0
			$row++; # Increase the Model NPC Entity's Row by 1
		}
		my $npc_x = ($npc->GetX() + (($column - 4.5) * -20)); # Aligns the Model NPC based on its column position
		my $npc_y = ($npc->GetY() + (($row + 1.5) * 20)); # Aligns the Model NPC based on its row position
		my $npc_z = ($npc->GetZ() + 10); # Aligns the Model NPC slightly in the air for bigger races
		plugin::Spawn2($npc_id, 1, $npc_x, $npc_y, $npc_z, 264); # Spawns the Model NPC
		my $npc_entity = $entity_list->GetNPCByNPCTypeID($npc_id); # Find the Model NPC Entity by NPC ID
		my $column_string = plugin::Tier($column);
		my $row_string = plugin::Tier($row);
		$npc_entity->TempName("Model | Column $column_string | Row $row_string"); # Set Model NPC Entity's Name to ""
		$column++; # Increase the Model NPC Entity's Column by 1
		$npc_index++;
	}
}

# ModelNPCs(option_type, option_choice); - Model NPCs based on Option Type and Option Choice
# Option Types: "r" => Race, "g" => Gender, "t" => Texture, "w" => Weapon
sub ModelNPCs {
	my ($option_type, $option_choice) = (shift, shift); # Assign $option_type and $option_choice to the values supplied to ModelNPCs(option_type, option_choice);
	my ($npc_name, $npc_last_name) = ("", ""); # Assign $npc_name and $npc_last_name to ""
	my ($npc_race, $npc_gender, $npc_texture, $npc_primary, $npc_secondary) = (0, 0, 0, 0, 0); # Assign $npc_race, $npc_gender, $npc_texture, $npc_primary, and $npc_secondary to 0
	my $race_index = 0; # Assign the Race Index to 0
	foreach my $npc_id (@npc_ids) { # Loop through each Model NPC ID in the 50 Model NPC ID array
		my $npc_entity = $entity_list->GetNPCByNPCTypeID($npc_id); # Find the Model NPC Entity by NPC ID
		$npc_race = $npc_entity->GetRace(); # Assigns Model NPC Entity's Race to the Model NPC Entity's Race
		$npc_texture = $npc_entity->GetTexture(); # Get the Model NPC Entity's Texture
		if ($option_type eq "r") { # Check if the Option Type is "r" (Race)
			my @races = (
				defined $race_viewer_options{$option_choice} ?  # Check if the option choice is a defined option type
				@{$race_viewer_options{$option_choice}} :  # Assign the Races array to the 50 Race ID Array from %race_viewer_options
				@{$race_viewer_options{0}} # Assign the Races array to the 50 Race ID Array from %race_viewer_options for Option Type 0
			);	
			$npc_race = (
				defined $races[$race_index] ? # Check if the current Race Index is defined in the 50 Race ID Array and set it to that value, if not set the Model NPC Race to 1
				$races[$race_index] : 
				1
			); 
		} elsif ($option_type eq "g") { # Check if the Option Type is "g" (Gender)
			$npc_gender = $option_choice; # Assign the Model NPC Entity's Gender to the Option Choice
		} elsif ($option_type eq "t") { # Check if the Option Type is "t" (Texture)
			$npc_texture = $option_choice; # Assign the Model NPC Entity's Texture to the Option Choice
		} elsif ($option_type eq "w") { # Check if the Option Type is "w" (Weapon)
			if ($npc_primary == 0) { # Check if the Model NPC Entity's Primary Model is equal to 0
				$npc_primary = (($option_choice * 100) + 1); # Example: Choice 0's Primary Model is "1", Choice 10's Primary Model is "1001"
				$npc_secondary = (($option_choice * 100) + 2); # Example: Choice 0's Secondary Model is "2", Choice 10's Secondary Model is "1002"
			}
			
			$npc_race = 127; # Assign the Model NPC Entity's Race to 127 (Invisible Man)
			$npc_gender = 0; # Assign the Model NPC Entity's Gender to 0 (Male)
			$npc_texture = 0; # Assign the Model NPC Entity's Texture to 0
			$npc_name = ""; # Assign the Model NPC Entity's Name to ""
		}
		
		if ($race_index > 0 && $npc_primary != 0) { # Check if the Model NPC Entity's Primary Model is not equal to 0
			$npc_primary = ($npc_primary + 2); # Increase the Model NPC Entity's Primary Model by 1
			$npc_secondary = ($npc_primary + 1); # Increase the Model NPC Entity's Secondary Model by 2
		}
		
		$npc_entity->SetRace($npc_race); # Sets the Model NPC Entity's Race to the value of $npc_race
		if ($option_type ~~ ["r", "t"]) { # Check if the Option Type is "r" (Race)
			$npc_gender = $npc_entity->GetGender(); # Assign the Model NPC Entity's Gender to the Model NPC Entity's Current Gender
		}
		$npc_entity->SendIllusion($npc_race, $npc_gender, $npc_texture); # Sets Model NPC Entity's Race, Gender, and Texture to their respective values
		if ($option_type ne "w") {
			$npc_name = quest::getracename($npc_race); # Return the Model NPC Entity's Race Name
		}
		if ($option_type ~~ ["r", "g", "t"]) { # Checks if the Option Type is "r" (Race), "g" (Gender), or "t" (Texture)
			$npc_last_name = "| R$npc_race | T$npc_texture | G$npc_gender |"; # Assigns the Model NPC Entity's Lastname to "| R$npc_race | T$npc_texture | G$npc_gender |"
			$npc_entity->WearChange($_, 0) for (7, 8); # Sets the Model NPC Entity's Primary and Secondary Models to 0
		} else {
			$npc_last_name = "| P$npc_primary | S$npc_secondary |"; # Assigns the Model NPC Entity's Lastname to "| P$npc_primary | S$npc_secondary |"
			$npc_entity->WearChange(7, $npc_primary); # Sets the Model NPC Entity's Primary Model to $npc_primary
			$npc_entity->WearChange(8, $npc_secondary); # Sets the Model NPC Entity's Secondary Model to $npc_secondary
		}
		$npc_entity->TempName($npc_name); # Sets the Model NPC Entity's Name to $npc_name
		$npc_entity->ChangeLastName($npc_last_name); # Sets the Model NPC Entity's Lastmame to $npc_last_name
		$race_index++; # Increase the Race Index by 1
	}
}

sub EVENT_SPAWN {
	if ($instanceid == 0) {
		quest::depopall(2000329);
	}
}