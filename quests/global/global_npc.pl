sub EVENT_SPAWN {	
	my $owner_id = $npc->GetOwnerID() > 0 ? $npc->GetOwnerID() : $npc->GetSwarmOwner();
	if ($owner_id > 0 && $entity_list->GetMobByID($owner_id)->IsClient()) {
		my $owner = $entity_list->GetClientByID($owner_id);
		my $pet_name = plugin::Data($owner, 3, "pet-name") ? plugin::Data($owner, 3, "pet-name") : $npc->GetCleanName();
		my $pet_race = plugin::Data($owner, 3, "pet-race") ? plugin::Data($owner, 3, "pet-race") : $npc->GetRace();
		my $pet_gender = plugin::Data($owner, 3, "pet-gender") ? plugin::Data($owner, 3, "pet-gender") : $npc->GetGender();
		my $pet_texture = plugin::Data($owner, 3, "pet-texture") ? plugin::Data($owner, 3, "pet-texture") : $npc->GetTexture();;
		my $pet_size = plugin::Data($owner, 3, "pet-size") ? plugin::Data($owner, 3, "pet-size") : $npc->GetSize();
		if ($pet_name ne "") {
			$pet_name =~ s/ /\_/ig;
			$npc->TempName($pet_name);
		}
		$npc->SendIllusion($pet_race, $pet_gender, $pet_texture);
		$npc->ChangeSize($pet_size);
		quest::settimer("Aggro", 1);
		quest::settimer("PetScale", 1);
	}
	if (!$owner_id && $npc->GetClass() != 62) {
		plugin::AddLoot($zonesn, $instanceversion);
	}
	
}

sub EVENT_TIMER {
	if (
		$npc->GetOwnerID() > 0 || 
		$npc->GetSwarmOwner() > 0
	) {
		if ($timer eq "Aggro") {
			my $aggro_flag = ($npc->IsTaunting() ? 1 : 0);
			quest::stoptimer("Aggro");
			if ($npc->GetSpecialAbility(41) != $aggro_flag) {
				$npc->SetSpecialAbility(41, $aggro_flag);
			}
			quest::settimer("Aggro", 1);
		} elsif ($timer eq "PetScale") {
        	quest::stoptimer("PetScale");
			my $swarm_id = (
				$npc->GetSwarmOwner() > 0 ? 
				$npc->GetSwarmOwner() :
				0
			);
			my $owner_id = (
				$npc->GetOwnerID() > 0 ? 
				$npc->GetOwnerID() : 
				$npc->GetSwarmOwner()
			);
			if ($swarm_id == 0 && $owner_id > 0) {
				my $owner_id = $npc->GetOwnerID();
				my $pet_owner = $entity_list->GetClientByID($owner_id);
				$pet_owner->SignalClient($pet_owner, 999);
			} elsif ($swarm_id > 0) {
				my $owner_id = $npc->GetSwarmOwner();
				my $pet_owner = $entity_list->GetClientByID($owner_id);
				plugin::SwarmScale($npc); 
				#$pet_owner->SignalClient($pet_owner, 998);
			}
    	}
	}
}

sub EVENT_KILLED_MERIT {
	return if ($npc->GetOwnerID());
	plugin::HandleDeath();
}

sub EVENT_DEATH_COMPLETE {
	return if ($npc->GetOwnerID());	
	if (
		$entity_list->GetMobByID($killer_id) && 
		$entity_list->GetMobByID($killer_id)->IsClient()
	) {
		my $killer_client = $entity_list->GetClientByID($killer_id);
		if ($npc->GetNPCTypeID() ~~ [2000447..2000450]) {	#:: Treasure Goblins
			plugin::Treasure_HandleDeath($killer_client);
			return;
		}

		plugin::HandleShardDeath($killer_client);
		#if($killer_client->Admin() > 100) {
		if(quest::ChooseRandom(1..100) >= 99) {
			if($npc->GetLevel() >= 70) {
				plugin::Treasure_Spawn($npc);
			}
		}
	} elsif ($entity_list->GetMobByID($killer_id)->GetOwnerID()) {
		plugin::HandleShardDeath($entity_list->GetClientByID($entity_list->GetMobByID($killer_id)->GetOwnerID()));
		if(quest::ChooseRandom(1..100) >= 97) {
			if($npc->GetLevel() >= 70) {
				plugin::Treasure_Spawn($npc);
			}
		}
		if ($npc->GetNPCTypeID() ~~ [2000447..2000450]) {	#:: Treasure Goblins
			plugin::Treasure_HandleDeath($entity_list->GetClientByID($entity_list->GetMobByID($killer_id)->GetOwnerID()));
			return;
		}
	}	
}
