sub EVENT_EQUIP_ITEM {
#	if($primary_weapon_type ~~ [1, 4, 35]) {$client->Message(15, "2H equip"); }
	if($class eq "Warrior" || $class eq "Shadowknight" || $class eq "Paladin") {
		my $buff = GetBuff();
		if(!$client->FindBuff($buff)) {
			ProcessBuff($buff);
			#$client->Message(15, "Casting.. $buff.. Buffcount: " . $client->HasShieldEquiped() . "");
			#CheckCurrentBuffs();
			#$client->Message(15, "Buff should be: " . GetBuff() . "");
		}
	}
}

sub EVENT_UNEQUIP_ITEM {
	FadeAll();
}

sub CheckCurrentBuffs {
	$client->FindBuff($_) for (42463..42465)
}

sub ProcessBuff {
	my $buff = $_[0];
	#FadeAll();
	#$client->Message(15, "Processing Buffs..");
	if($client->FindBuff($buff)) { $client->Message(15, "You are already buffed big boi :)"); }
	else {
		$client->SpellFinished($buff,$client,-1);  
		#plugin::ServerData($client, 1, "CombatProficiencyCD", 1);
	}
}

sub FadeAll {
	$client->BuffFadeBySpellID($_) for (42463..42465);
}

sub GetBuff {
	my $primary_weapon_type = $client->GetItemStat($client->GetItemIDAt(quest::getinventoryslotid("primary")), "itemtype");
	my $secondary_weapon_type = $client->GetItemStat($client->GetItemIDAt(quest::getinventoryslotid("secondary")), "itemtype");
	if($status >= 100) {
		#$client->Message(15, "Primary: $primary_weapon_type ID (" . $client->GetItemIDAt(quest::getinventoryslotid("primary")) . ") | Secondary: $secondary_weapon_type ID ((" . $client->GetItemIDAt(quest::getinventoryslotid("secondary")) . "))"); 
	}
	
	if($client->GetItemIDAt(quest::getinventoryslotid("secondary")) != -1) { 
		#$client->Message(15, "Something in secondary."); 
		if($secondary_weapon_type == 8) { 
			$buff = "42463";	#:: DEFENSIVE PROF
		}
		else {
			$buff = "42464";	#:: DW PROF
		}
	}
	else {				
		if($primary_weapon_type ~~ [1, 4, 35]) { #:: 2Hand Proficiency
			$buff = "42465";	#:: 2H PROF 
		}
		else {
			$buff = "0";
		}
	}
	return $buff;
}


