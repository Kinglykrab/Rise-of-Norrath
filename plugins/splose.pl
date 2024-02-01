sub PlayerPercentHP {
	my ($client,$percent) = (shift,shift);
	my ($hp_amount,$mana_amount) = (int($client->GetMaxHP()*($percent/100)),int($client->GetMaxMana()*($percent/100)));
	#my $Debug = " ";
	if($Debug) {$client->Message(15, "" . $percent . " 	of " . $client->GetMaxHP() . " = $amount"); }
	
	if($client->GetHP()-$hp_amount <= 0) { #:: This would kill the client.. Set it to 1.
		$client->SetHP(1);
		$client->Message(264, "You do not have enough health to convert to mana.");
	} else {
		$client->SetHP($client->GetHP()-$hp_amount);
		$client->SetMana($client->GetMana()+$mana_amount);
		$client->Message(264, "You have converted $hp_amount health to $mana_amount mana.");
	}
	#$client->SendHPUpdate();
}

sub Treasure_HandleDeath {
	my $client = shift;
	my $zonesn = plugin::val('zonesn');
	my $npc = plugin::val('npc');
	my %prog_zones_loot = plugin::TierLootHash();
	my @prog_zones = keys %prog_zones_loot;
	my ($radiant_crystals,$ebon_crystals) = (quest::ChooseRandom(5..25),quest::ChooseRandom(5..25));
	my $emblem = plugin::ProgressionEmblems();
	#my $emblem_link = quest::varlink($emblem);
	my $currency_id = quest::getcurrencyid($emblem);
	if($zonesn ~~ @prog_zones) {
		my ($tier_shard,$tier_shard_chance) = ($prog_zones_loot{$zonesn}[5] ? $prog_zones_loot{$zonesn}[5] : 0,$prog_zones_loot{$zonesn}[6] ? $prog_zones_loot{$zonesn}[6] : 0);
		my $tier_shard_id = quest::getcurrencyid($tier_shard);
		plugin::AddCurrencyRandom($client, $currency_id, quest::ChooseRandom(3..10));	#:: Class Shards	
		if($tier_shard_id) {
			plugin::AddCurrencyRandom($client, $tier_shard_id, quest::ChooseRandom(1..5));	#:: Tier Shards	
			plugin::GM("TIER SHARD DEBUG");
		}
	} else {
		plugin::AddCrystals($client, "Both", 0, 0, $radiant_crystals, $ebon_crystals);
	}
	
	plugin::AddMoney($client, quest::ChooseRandom(10000..50000));
}

sub Treasure_Spawn {
	my $npc = $_[0];
	my %Spawns = (
	2000447	=>	"Treasure Goblin",
	2000448 =>	"Changeling",
	2000449 => 	"Corrupted Spirit",
	2000450 =>	"Guardian of Norrath",
	);
	my @SpawnTypes = keys %Spawns;
	if($_[0]) {
		quest::spawn2(2000447,0,0,$npc->GetX(),$npc->GetY(),$npc->GetZ(),$npc->GetHeading()/2);
	}
}


# plugin::Jail();
#:: Jails your target for 
sub Jail {
	my $client = plugin::val('client');
	my $nn = $client->GetCleanName();
	quest::worldwidemessage(13, "$nn test", 100, 255);
	quest::worldwidemarquee(13, 1, 1000, 1000, 3000, "$nn", 100, 255);
}


# plugin::Gear($client,1); = Tier 1
#:: Summons your stupid ass some gear
sub Gear {
	my ($client,$tier,$classbit) = ($_[0],plugin::GetTierArmorName($_[1]),plugin::GetClassBit());
	my $database_handler = plugin::LoadMysql();
	my $query = "
	SELECT DISTINCT
	items.id,
	items.name,
	items.slots
	FROM
	items 
	WHERE
	`NAME` LIKE '%" . $tier . "%' 
	AND items.id >= '165000'
	AND classes & '" . $classbit . "' LIMIT 20";
	$query_handler = $database_handler->prepare($query);
	$query_handler->execute();
	while (@row = $query_handler->fetchrow_array()){
		if($row[2] ~~ [18,1536,98304]) { quest::summonitem($row[0]) for (1,2); }
		else {
			quest::summonitem($row[0]); 
		}
	} # $client->Message(15, "Item Name: " . $row[0] . " (" . $row[1] . ")");
	$client->Message(15, "Summoning Tier " . $_[1] . " Gear ($tier)");
}

# plugin::GetTierArmorName(5);
#:: Gets Tier Armor Names
sub GetTierArmorName {
	my %tier_armor = (
		1 => "Xixos",
		2 => "Ezazel",
		3 => "Elizabeth",
		4 => "Vladimir",
		5 => "Prino",
		6 => "Zalax",
		7 => "Aslan",
		8 => "Guardian of Norrath",
		9 => "Willowisp",
		10 => "Two-Faced",
		11 => "Ash-covered",
		12 => "Vibrant",
		13 => "Plagued",
		14 => "Cursed",
		15 => "Mechanized",
	);
	if($_[0]) { return $tier_armor{$_[0]}; }
}

# plugin::GetClassbit($class_id);
#:: Gets class bit
sub GetClassBit {
	my $client = plugin::val('client');
	my %class_bit = (
		1 => 1,
		2 => 2,
		3 => 4,
		4 => 8,
		5 => 16,
		6 => 32,
		7 => 64,
		8 => 128,
		9 => 256,
		10 => 512,
		11 => 1024,
		12 => 2048,
		13 => 4096,
		14 => 8192,
		15 => 16384,
		16 => 32768
	);
	return $class_bit{$client->GetClass()};
}

# plugin::Donator_Currency_Search();
#::	Searches the database and presents a list of characters who have more than 100 ($1) donator coins.
sub Donator_Currency_Search {
	my $database_handler = plugin::LoadMysql();
	my $query = 
	"SELECT
	account.NAME,
	character_data.NAME,
	character_alt_currency.amount
	FROM
	character_alt_currency
	INNER JOIN character_data ON character_data.id = character_alt_currency.char_id
	INNER JOIN account ON character_data.account_id = account.id 
	WHERE
	currency_id = 11 
	AND account.STATUS = 0 
	AND character_alt_currency.amount > 100 
	ORDER BY
	amount DESC";
	$query_handler = $database_handler->prepare($query);
	$query_handler->execute(); 
	my $i=0;
	while (@row = $query_handler->fetchrow_array()){ $SearchResults[$i] = [@row]; $i++ }
	return $i;
}

#::: Author: Trevius
#::: Usage: plugin::CloneAppearance(MobA, MobB, CloneName=false)
#::: Description: Clones the look of a target
#:::	 MobA is the target mob to clone from
#:::	 MonB is the mob that is changing to clone MobA
#:::	 CloneName is an optional field that if set to 1 will clone the name of the target as well
sub CloneAppearance {
	my $MobA = $_[0];
	my $MobB = $_[1];
	my $CloneName = $_[2];
	
	#my $Mob_A = $MobA->GetEnt();
	
	my $Race = $MobA->GetRace();
	my $Gender = $MobA->GetGender();
	my $Texture = $MobA->GetTexture();
	my $HelmTexture = $MobA->GetHelmTexture();
	my $Face = $MobA->GetLuclinFace();
	my $HairStyle = $MobA->GetHairStyle();
	my $HairColor = $MobA->GetHairColor();
	my $Beard = $MobA->GetBeard();
	my $BeardColor = $MobA->GetBeardColor();
	my $DrakkinHeritage = $MobA->GetDrakkinHeritage();
	my $DrakkinTattoo = $MobA->GetDrakkinTattoo();
	my $DrakkinDetails = $MobA->GetDrakkinDetails();
	my $Size = $MobA->GetSize();
	
	if (!$Size)
	{
		%RaceSizes = (
			1 => 6, # Human
			2 => 8, # Barbarian
			3 => 6, # Erudite
			4 => 5, # Wood Elf
			5 => 5, # High Elf
			6 => 5, # Dark Elf
			7 => 5, # Half Elf
			8 => 4, # Dwarf
			9 => 9, # Troll
			10 => 9, # Ogre
			11 => 3, # Halfling
			12 => 3, # Gnome
			128 => 6, # Iksar
			130 => 6, # Vah Shir
			330 => 5, # Froglok
			522 => 6, # Drakkin
		);
		
		$Size = $RaceSizes{$Race};
	}
	
	if (!$Size)
	{
		$Size = 6;
	}

	if ($Size > 15)
	{
		$Size = 15;
	}
	
	$MobB->SendIllusion($Race, $Gender, $Texture, $HelmTexture, $Face, $HairStyle, $HairColor, $Beard, $BeardColor, $DrakkinHeritage, $DrakkinTattoo, $DrakkinDetails, $Size);
	
	for ($slot = 0; $slot < 7; $slot++)
	{
		my $Color = 0;
		my $Material = 0;
		if ($MobA->IsClient() || $slot > 6)
		{
			$Color = $MobA->GetEquipmentColor($slot);
			$Material = $MobA->GetEquipmentMaterial($slot);
		}
		else
		{
			$Color = $MobA->GetArmorTint($slot);
			if ($slot == 0)
			{
				$Material = $MobA->GetHelmTexture();
			}
			else
			{
				$Material = $MobA->GetTexture();
			}
		}
		$MobB->WearChange($slot, $Material, $Color);
	}
	
	$PrimaryModel = $MobA->GetEquipmentMaterial(7);
	$SecondaryModel = $MobA->GetEquipmentMaterial(8);
	
	# NPCs can set animations and attack messages, but clients only set the model change
	if ($MobB->IsNPC())
	{
		plugin::SetWeapons($PrimaryModel, $SecondaryModel);
	}
	else
	{
		$MobB->WearChange(7, $PrimaryModel, 0);
		$MobB->WearChange(8, $SecondaryModel, 0);
	}
	
	if ($CloneName)
	{
		my $CloneName = $MobA->GetCleanName();
		$MobB->TempName($CloneName);
	}
	
	
}

#Usage: plugin::RandomRoam(MaxXVariance, MaxYVariance, MaxZVariance, LoSMobSize);
# MaxXVariance - Sets the max X variance to travel 
# MaxYVariance - Sets the max Y variance to travel 
# MaxZVariance - Sets the max Z variance to travel.  This field is optional and default is 15.
# LoSMobSize - Sets the size of the mob LoS check.  This field is optional and default is 5.
# The LoS check basically looks from your NPC to an imaginary NPC of the LoSMobSize size to see if LoS exists

sub RandomRoam {

	my $npc = plugin::val('$npc');
	my $MaxXVariance = $_[0];
	my $MaxYVariance = $_[1];
	my $MaxZVariance = $_[2];
	my $LoSMobSize = $_[3];

	#Set the Max Z Variance to 15 if no 3rd argument is set
	if(!$MaxZVariance){
		$MaxZVariance = 15;
	}
	
	#Set the LoS Check Mob Size to 5 if no 4th argument is set
	if(!$LoSMobSize){
		$LoSMobSize = 5;
	}
	
	# Don't try to roam if already engaged in combat!
	if ($npc->IsEngaged() != 1) {
		#Get needed Locs
		my $CurX = $npc->GetX();
		my $CurY = $npc->GetY();
		#my $CurZ = $npc->GetZ();	#Not currently required by this plugin
		my $OrigX = $npc->GetSpawnPointX();
		my $OrigY = $npc->GetSpawnPointY();
		my $OrigZ = $npc->GetSpawnPointZ();
		my $GuardX = $npc->GetGuardPointX();
		my $GuardY = $npc->GetGuardPointY();

		if ($CurX == $GuardX && $CurY == $GuardY) {	#If the NPC has finished walking to the previous given Loc

			#Get a random X and Y within the set range
			my $RandomX = int(rand($MaxXVariance - 1)) + 1;
			my $RandomY = int(rand($MaxYVariance - 1)) + 1;
			my $PosX = $OrigX + $RandomX;
			my $PosY = $OrigY + $RandomY;
			my $NegX = $OrigX - $RandomX;
			my $NegY = $OrigY - $RandomY;
			my $NewX = quest::ChooseRandom($PosX, $NegX);
			my $NewY = quest::ChooseRandom($PosY, $NegY);
			
			#Check for LoS and Z issues before moving to the new Loc
			my $NewZ = $npc->FindGroundZ($NewX,$NewY, 5) + 1;	#Add 1 to the new Z to prevent hopping issue when they arrive
			if ($NewZ > -999999 && $OrigZ > ($NewZ - $MaxZVariance + 1) && $OrigZ < ($NewZ + $MaxZVariance - 1)) {
				my $LoS_Check = $npc->CheckLoSToLoc($NewX, $NewY, $NewZ, $LoSMobSize);
				#Check LoS to the new random Loc
				if ($LoS_Check) {
					quest::moveto($NewX, $NewY, $NewZ, -1, 1);
				}
			}
		}
	}
}

# plugin::PotatoPass($client, $zone_short_name);
#:: Removes all lockouts for the zone specified.
sub PotatoPass {
	my (
		$client,
		$zone_short_name
	) = (
		shift,
		shift,
	);
	my %types =	(
		0 => "Solo",
		1 => "Group",
		2 => "Raid"
	);
	my $removed_count = 0;
	foreach my $type (0..2) {
		if (plugin::Data($client, 3, "Instance-Lockout-$type-$zone_short_name") > 0) {
			plugin::Data($client, 0, "Instance-Lockout-$type-$zone_short_name");	#:: Delete Data Bucket
			plugin::ClientMessage($client, "Your instance lockout for: $zone_short_name ($types{$type}) has been deleted!");
			$removed_count++;
			last;
		}
	}
	
	if ($removed_count == 0) {
		plugin::ClientMessage($client, "You didn't have any lockouts.");
		$client->SummonItem(187002);
	}
}