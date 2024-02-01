sub SwarmScale {
	my $npc = $_[0];
	my $entity_list = plugin::val('entity_list');
	my $client = $entity_list->GetClientByID($npc->GetSwarmOwner());
	my (
		$damage_modifier,
		$health_modifier
	) = (
		plugin::GetModifier(1,$client)*1.75,	#:: Weight Damage Harder than Health - Splose
		plugin::GetModifier(0,$client),
	);
	
		#$npc->Shout("HM: " . $health_modifier . " : DM: " . $damage_modifier . "");
	my %scale_data = (
		"max_hp" => ["Health", $client->GetMaxHP()/3],
		"min_hit" => ["Minimum Damage", $client->GetLevel()*25],
		"max_hit" => ["Maximum Damage", $client->GetLevel()*55],
		"ac" => ["Armor Class", $npc->GetAC()],
		"atk" => ["Attack", $npc->GetATK()],
		"agi" => ["Agility", $npc->GetAGI()],
		"cha" => ["Charisma", $npc->GetCHA()],
		"dex" => ["Dexterity", $npc->GetDEX()],
		"int" => ["Intelligence", $npc->GetINT()],
		"sta" => ["Stamina", $npc->GetSTA()],
		"str" => ["Strength", $npc->GetSTR()],
		"wis" => ["Wisdom", $npc->GetWIS()],
		"accuracy" => ["Accuracy", 100],
		"healscale" => ["Heal Scale", 25],
		"spellscale" => ["Spell Scale", 45],
	);

	if ($npc->GetLevel() < $client->GetLevel()) {
		$npc->SetLevel($client->GetLevel());
	}

	foreach my $stat (sort {$a cmp $b} keys %scale_data) {
		my (
			$stat_name,
			$stat_value
		) = @{$scale_data{$stat}};
		$stat_value *= (($stat eq "max_hp") ? $health_modifier : $damage_modifier);
		$npc->ModifyNPCStat($stat, $stat_value);
		$npc->SetHP($npc->GetMaxHP());
		$npc->SetEntityVariable("Scaled", 1);
	}
	my (
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
	$npc->RecalculateSkills()
}

sub PetScale {
	my $client = plugin::val('client');
	my $entity_list = plugin::val('entity_list');
	my $npc = $entity_list->GetNPCByID($client->GetPetID());
	my (
		$damage_modifier,
		$health_modifier
	) = (
		plugin::GetModifier(1),	#:: Weight Damage Harder than Health - Splose
		plugin::GetModifier(0),
	);

	if (plugin::GetModifier(0) <= 1) {
		plugin::Message("Scaling your pet would be useless, so it was not scaled.");
		return;
	}
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
		"healscale" => ["Heal Scale", int(25+($health_modifier*1.75))],
		#"spellscale" => ["Spell Scale", int(45+($damage_modifier*3))],
		"spellscale" => ["Spell Scale", 100],
	);
	if (!$npc->EntityVariableExists("Scaled")) {
		if ($npc->GetLevel() < $client->GetLevel()) {
			$npc->SetLevel($client->GetLevel());
		}

		foreach my $stat (sort {$a cmp $b} keys %scale_data) {
			my (
				$stat_name,
				$stat_value
			) = @{$scale_data{$stat}};
			$stat_value *= (($stat eq "max_hp") ? $health_modifier : $damage_modifier);
			$npc->ModifyNPCStat($stat, $stat_value);
			$npc->SetHP($npc->GetMaxHP());
			$npc->SetEntityVariable("Scaled", 1);
		}
		my (
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
		);
	} else {
		plugin::Message("Your pet has already been scaled.");
		return;
	}
	#$npc->Shout("HM: " . $health_modifier . " : DM: " . $damage_modifier . "");
}

sub GetModifier {
	if(!$_[1]) { $client = plugin::val('client'); } else { $client = $_[1]; }
	my $modifier = 1;
	my $type = shift;
	if($type == 1) { $modifier+= 1; }
	if ($client->GetCHA() / 100 > 1) {
		if($type == 1) { $modifier += ($client->GetCHA() / 400); } else { $modifier += ($client->GetCHA() / 1000); }
	}

	if (!$type) {
		if (plugin::Data($client, 3, "Advanced-Pet-Health")) {
			$modifier += (plugin::Data($client, 3, "Advanced-Pet-Health") * 3);
		}
		
		if (plugin::Data($client, 3, "Prestige") && $client->GetClass() ~~ [10..15]) {
			$modifier += (plugin::Data($client, 3, "Prestige") * 7);
		}
	} elsif ($type == 1) {
		if (plugin::Data($client, 3, "Progression") >= 5) {
			$modifier += (plugin::Data($client, 3, "Progression") * 2);
		}
		if (plugin::Data($client, 3, "Advanced-Pet-Damage")) {
			$modifier += (plugin::Data($client, 3, "Advanced-Pet-Damage") * 5);
		}
		
		if (plugin::Data($client, 3, "Prestige") && $client->GetClass() ~~ [10..15]) {
			$modifier += (plugin::Data($client, 3, "Prestige") * 10);
		}
	}
	return $modifier;
}

sub DisplayScaling {
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
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
		shift,
	);
	my @table = 
	"<table>
		<tr>
			<td></td>
			<td>" . plugin::PWColor("Before", "Royal Blue") . "</td>
			<td>" . plugin::PWColor("After", "Royal Blue") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Health", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($health), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($health * $health_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Minimum Damage", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($min_hit), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($min_hit * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Maximum Damage", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($max_hit), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($max_hit * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Armor Class", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($armor_class), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($armor_class * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Attack", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($attack), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($attack * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Agility", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($agility), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($agility * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Charisma", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($charisma), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($charisma * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Dexterity", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($dexterity), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($dexterity * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Intelligence", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($intelligence), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($intelligence * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Stamina", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($stamina), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($stamina * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Strength", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($strength), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($strength * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Wisdom", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($wisdom), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($wisdom * $damage_modifier)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Heal Scale", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($heal_scale), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($heal_scale)), "Green") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor("Spell Scale", "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($spell_scale), "Yellow") . "</td>
			<td>" . plugin::PWColor(plugin::commify(int($spell_scale)), "Green") . "</td>
		</tr>
	</table>";
	plugin::Popup(
		"Pet Scaling Information",
		"Damage Modifier: $damage_modifier<br>
		Health Modifier: $health_modifier<br><br>
		@table", 0, 999
	);
}