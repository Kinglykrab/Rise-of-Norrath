sub EVENT_SAY {
	my %weapon_types_hash = (
		0 => "Fire",
		1 => "Ice",
		2 => "Rage",
		3 => "Death",
		4 => "Nature",
	);
	my $index = 1;
	if ($text=~/Hail/i) {
		my $weapons_link = quest::saylink("weapons", 1);
		plugin::Whisper("Hail $name, I have the ability to give your pet many powerful $weapons_link.");
	} elsif ($text=~/Weapons/i) {
		plugin::Message("= | Pet Weapon Types");
		foreach my $weapon_type (sort {$a <=> $b} keys %weapon_types_hash) {
			my $weapon_type_name = $weapon_types_hash{$weapon_type};
			my $set_link = quest::saylink("set $weapon_type", 1, "$weapon_type_name Weapons");
			plugin::Message("== | $index. $set_link");
			$index++;
		}
	} elsif ($text=~/Set/i) {
		my $pet_weapon = substr($text, 4);
		my $pet_weapon_type = $weapon_types_hash{$pet_weapon};
		plugin::Data($client, 1, "PetWeapon", $pet_weapon);
		plugin::Whisper("You pet will now equip $pet_weapon_type weapons.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}