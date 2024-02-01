sub MeleeSkillsArray {
	my @melee_skills_array = (
		0..3, 7, 8, 10, 21,
		23, 26, 28, 30, 36,
		38, 52, 74, 77
	);
	return @melee_skills_array;
}

sub ListSkillModifiers {
	my %skills_hash = (
		"Caster" => [3, 50000, ["Cleric", "Paladin", "Ranger", "Shadowknight", "Druid", "Bard", "Shaman", "Necromancer", "Wizard", "Magician", "Enchanter", "Beastlord"]],
		"Melee" => [5, 25000, ["Warrior", "Paladin", "Ranger", "Shadowknight", "Monk", "Bard", "Rogue", "Beastlord", "Berserker"]],
		"Pet" => [5, 25000, ["Shaman", "Necromancer", "Wizard", "Magician", "Enchanter", "Beastlord"]],
	);
	my @melee_skills_array = plugin::MeleeSkillsArray();
	my $client = plugin::val('client');
	my $class = plugin::val('class');
	my (
		$melee,
		$caster,
		$pet,
		$melee_amount,
		$caster_amount,
		$pet_amount
	) = (
		1,
		1,
		1,
		0,
		0,
		0
	);
	if ($class ~~ ["Warrior", "Paladin", "Ranger", "Shadowknight", "Monk", "Bard", "Rogue", "Beastlord", "Berserker"]) {
		plugin::Message("= | Melee Skills");
		foreach my $melee_skill (@melee_skills_array) {
			if ($client->CanHaveSkill($melee_skill) && $client->MaxSkill($melee_skill) > 0) {
				if (plugin::Data($client, 3, "Advanced-Skill-$melee_skill") == 0) {
					plugin::Message("== | $melee. " . quest::getskillname($melee_skill) . " Rank One");
					plugin::Message("=== | 25,000 AA Points");
					plugin::Message("==== | " . quest::saylink("learn $melee_skill 1", 1, "Learn"));
					$melee++;
					$melee_amount++;
				} else {
					my $next_rank = (plugin::Data($client, 3, "Advanced-Skill-$melee_skill") + 1);
					if ($next_rank < 6) {
						my $skill_cost = plugin::commify($next_rank != 5 ? (25000 * $next_rank) : 150000);
						plugin::Message("== | $melee. " . quest::getskillname($melee_skill) . " Rank " . plugin::Tier($next_rank));						
						plugin::Message("=== | $skill_cost AA Points");
						plugin::Message("==== | " . quest::saylink("learn $melee_skill $next_rank", 1, "Learn"));
						$melee++;
						$melee_amount++;
					}
				}
			}
		}
		
		if ($melee_amount == 0) {
			plugin::Message("None available.");
		}
	}
	
	if ($class ~~ ["Cleric", "Paladin", "Ranger", "Shadowknight", "Druid", "Bard", "Shaman", "Necromancer", "Wizard", "Magician", "Enchanter", "Beastlord"]) {
		plugin::Message("= | Caster Skills");
		foreach my $type ("Casting", "Healing") {
			if (plugin::Data($client, 3, "Advanced-$type") == 0) {
				plugin::Message("== | $caster. $type Rank One");
				plugin::Message("=== | 50,000 AA Points");
				plugin::Message("==== | " . quest::saylink("learn $type 1", 1, "Learn"));
				$caster++;
				$caster_amount++;
			} else {
				my $next_rank = (plugin::Data($client, 3, "Advanced-$type") + 1);
				if ($next_rank < 4) {
					my $skill_cost = plugin::commify(50000 * $next_rank);
					plugin::Message("== | $caster. $type Rank " . plugin::Tier($next_rank));
					plugin::Message("=== | $skill_cost AA Points");
					plugin::Message("==== | " . quest::saylink("learn $type $next_rank", 1, "Learn"));
					$caster++;
					$caster_amount++;
				}
			}
		}
		
		if ($caster_amount == 0) {
			plugin::Message("None available.");
		}
	}
	
	if ($class ~~ ["Shaman", "Necromancer", "Wizard", "Magician", "Enchanter", "Beastlord"]) {
		plugin::Message("= | Pet Skills");
		foreach my $type ("Damage", "Health") {
			if (plugin::Data($client, 3, "Advanced-Pet-$type") < 1) {
				plugin::Message("== | $pet. $type Rank One - " . quest::saylink("learn $type 1", 1, "Learn"));
				$pet++;
				$pet_amount++;
			} else {
				my $next_rank = (plugin::Data($client, 3, "Advanced-Pet-$type") + 1);
				if ($next_rank < 6) {
					my $skill_cost = plugin::commify($next_rank != 5 ? (25000 * $next_rank) : 150000);
					plugin::Message("== | $pet. $type Rank " . plugin::Tier($next_rank));
					plugin::Message("=== | $skill_cost AA Points");
					plugin::Message("==== | " . quest::saylink("learn $type $next_rank", 1, "Learn"));
					$pet++;
					$pet_amount++;
				}
			}
		}
		
		if ($pet_amount == 0) {
			plugin::Message("None available.");
		}		
	}
}

sub HandleSkill {
	my @melee_skills_array = plugin::MeleeSkillsArray();
	my (
		$client,
		$skill_id,
		$target,
	) = (
		shift,
		shift,
		shift,
	);
	if ($skill_id ~~ @melee_skills_array && $client->GetID() != $target->GetID()) {
		if (plugin::Data($client, 3, "Advanced-Skill-$skill_id") >= 1) {
			my $skill_rank = plugin::Data($client, 3, "Advanced-Skill-$skill_id");
			my $skill_chance = ((70 + (5 * $skill_rank)) * 10);
			if (quest::ChooseRandom(1..1000) > $skill_chance) {
				my $skill_attacks = ((($skill_rank - 3) > 0) ? (1 + ($skill_rank - 3)) : 1);
				my $skill_min = (5500 + (50 * ($skill_rank - 2)));
				my $skill_max = (7500 + (100 * ($skill_rank - 2)));
				my $attacks = quest::ChooseRandom(1..$skill_attacks);
				if ($attacks > 1) {
						plugin::ClientColorMessage(
						$client,
						265,"You perform an extra $attacks attacks thanks to your Advanced " . quest::getskillname($skill_id) . ".");
					for (my $i = 0; $i < $attacks; $i++) {
						$client->DoSpecialAttackDamage($target, $skill_id, $skill_min, $skill_max, 0);
					}
				} else {
					plugin::ClientColorMessage(
					$client,
					265,"You perform an extra attack thanks to your Advanced " . quest::getskillname($skill_id) . ".");
					$client->DoSpecialAttackDamage($target, $skill_id, $skill_min, $skill_max, 0);
				}
			}
		}
	}
}

sub HandleCast {
	my @damage_spells_array = (
		5254, 5255, 5260, 5268, 5271,
		5275, 5279, 5286, 5292, 5301,
		5303, 5309, 5313, 5319, 5320,
		5322..5325, 5328, 5330, 5333..5335,
		5337, 5338, 5340, 5343, 5345, 5346,
		5348, 5357, 5361, 5363, 5364, 5367,
		5369, 5371, 5372, 5378, 5379, 5385,
		5391, 5401, 5403, 5408, 5411, 5412,
		5414, 5418, 5419, 5420, 5423, 5424,
		5426, 5430, 5432, 5433, 5434, 5437,
		5440, 5441, 5442, 5444..5447, 5449..5452,
		5454..5458, 5461..5463, 5474, 5479,
		5481, 5484, 5490, 5493, 5496..5498,
		5509, 5518, 5523, 5527, 5535, 5540,
		5543, 6143, 6146, 6668,	6669, 6727,
		7994, 7995, 7999, 8004, 8006, 8011,
		8018, 8021, 8022, 8025, 8027, 8034,
		8037, 8040, 8041, 8043, 8044, 8483,
		8490, 8501,8508, 8512, 8515, 8520,
		9715, 9739, 9824, 9827, 9833, 9962,
		9993, 10089, 10104, 10188, 10233,
		10245, 10272, 10324, 10380,	10470,
		10479, 10488, 10494, 10507, 10510,
		10696, 10705, 10716, 10770, 10776,
		10788, 10798, 10819, 11792, 11816,
		11834, 11857
	);
	my @heal_spells_array = (
		5251, 5265, 5270, 5282, 5289, 5296,
		5304, 5310, 5315, 5342, 5353, 5355,
		5377, 5384, 5393, 5395,	5406, 5435,
		5476, 5491, 5526, 5528, 5536, 5537,
		6140..6142, 8007, 8498, 9706, 9875,
		9968, 10092, 10155, 10185, 10321, 10333, 10419, 10712,8480	
	);
	my (
		$client,
		$spell_id,
		$target,
	) = (
		shift,
		shift,
		shift,
	);
	
	if($client->Admin() > 100) {	$client->Message(15, "Handlecast on $spell_id"); }
	
	if ($spell_id ~~ @damage_spells_array && $client->GetID() != $target->GetID()) {
		if (plugin::Data($client, 3, "Advanced-Casting") >= 1) {
			my $skill_rank = plugin::Data($client, 3, "Advanced-Casting");
			my $skill_chance = ((70 + (5 * $skill_rank)) * 10);
			if (quest::ChooseRandom(1..1000) > $skill_chance) {
				my $attacks = quest::ChooseRandom(1..$skill_rank);
				if ($attacks > 1) {
					for (my $i = 0; $i < $attacks; $i++) {
						$client->SpellFinished($spell_id, $target, 0);
					}
					plugin::Message("= | You perform an extra $attacks casts thanks to your Advanced Casting.");
				} else {
					$client->SpellFinished($spell_id, $target, 0);
					plugin::Message("= | You perform an extra cast thanks to your Advanced Casting.");
				}
			}
		}
	} elsif ($spell_id ~~ @heal_spells_array) {
		if (plugin::Data($client, 3, "Advanced-Healing") >= 1) {
			my $skill_rank = plugin::Data($client, 3, "Advanced-Healing");
			my $skill_chance = ((70 + (9 * $skill_rank)) * 10);
			if (quest::ChooseRandom(1..1000) > $skill_chance) {
				my $attacks = quest::ChooseRandom(1..$skill_rank);
				if ($attacks > 1) {
					my $attacks = quest::ChooseRandom(1..$skill_rank);
					for (my $i = 0; $i < $attacks; $i++) {
						$client->SpellFinished($spell_id, $target, 1);
					}
					plugin::Message("= | You perform an extra $attacks casts thanks to your Advanced Healing.");
				} else {
					$client->SpellFinished($spell_id, $target, 0);
					plugin::Message("= | You perform an extra cast thanks to your Advanced Healing.");
				}
			}
		}
	}
}