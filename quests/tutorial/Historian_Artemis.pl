sub EVENT_SAY {
	if ($ulevel == 70) {
		my $power_link = quest::saylink("power", 1);
		my $field_link = quest::saylink("#peqzone drachnidhive", 0, "The Hive");
		if ($text=~/Hail/i) {
			plugin::Whisper(
				"Hail $name, I am an Ancient Historian.
				Over time, much of the history of Norrath and its most powerful warriors has been lost.
				I am the link to the past, for I know how mere mortals rivaled the Gods in power.
				Would you like to learn of this $power_link?
				In order to farm the quantities necessary, you may visit $field_link."
			);
		} elsif ($text=~/Power/i) {
			plugin::ListSkillModifiers();
		} elsif ($text=~/Learn/i) {
			my @data = split(/ /, substr($text, 6));
			my $skill = $data[0];
			my $skill_name = quest::getskillname($skill);
			my $skill_rank = $data[1];
			my $skill_rank_string = plugin::Tier($skill_rank);
			my $before_aa_points = $client->GetAAPoints();
			if ($skill !~ /Casting|Healing|Damage|Health/i) {
				my $skill_cost = ($skill_rank < 5 ? (25000 * $skill_rank) : 150000);
				if ($class ~~ ["Warrior", "Paladin", "Ranger", "Shadowknight", "Monk", "Bard", "Rogue", "Beastlord", "Berserker"]) {
					my $skill_flag = plugin::Data($client, 3, "Advanced-Skill-$skill");
					if ($skill_flag < $skill_rank) {
						if ($before_aa_points >= $skill_cost) {
							plugin::TakeAAPoints($client, $skill_cost);
							plugin::Data($client, 1, "Advanced-Skill-$skill", $skill_rank);
							plugin::Whisper("You have successfully learned ancient knowledge pertaining to $skill_name Rank $skill_rank_string.");
							my $after_aa_points = $client->GetAAPoints();
							plugin::LogSkill($skill, $before_aa_points, $after_aa_points);
						} else {
							my $required = plugin::commify($skill_cost - $client->GetAAPoints());
							plugin::Whisper("You need $required more AA Points.");
						}
					} else {
						plugin::Whisper("You seem to already have this knowledge.");
					}
				}
			} elsif ($skill =~ /Casting|Healing/i)  {
				my $skill_cost = (50000 * $skill_rank);
				if ($class ~~ ["Cleric", "Paladin", "Ranger", "Shadowknight", "Druid", "Bard", "Shaman", "Necromancer", "Wizard", "Magician", "Enchanter", "Beastlord"]) {
					my $skill_flag = plugin::Data($client, 3, "Advanced-$skill");
					if ($skill_flag < $skill_rank) {
						if ($before_aa_points >= $skill_cost) {
							plugin::TakeAAPoints($client, $skill_cost);
							plugin::Data($client, 1, "Advanced-$skill", $skill_rank);
							plugin::Whisper("You have successfully learned ancient knowledge pertaining to $skill Rank $skill_rank_string.");
							my $after_aa_points = $client->GetAAPoints();
							plugin::LogSkill($skill, $before_aa_points, $after_aa_points);
						} else {
							my $required = plugin::commify($skill_cost - $client->GetAAPoints());
							plugin::Whisper("You need $required more AA Points.");
						}
					} else {
						plugin::Whisper("You seem to already have this knowledge.");
					}
				}
			} elsif ($skill =~ /Damage|Health/i)  {
				my $skill_cost = ($skill_rank < 5 ? (25000 * $skill_rank) : 150000);
				if ($class ~~ ["Shaman", "Necromancer", "Wizard", "Magician", "Enchanter", "Beastlord"]) {
					my $skill_flag = plugin::Data($client, 3, "Advanced-Pet-$skill");
					if ($skill_flag < $skill_rank) {
						if ($before_aa_points >= $skill_cost) {
							plugin::TakeAAPoints($client, $skill_cost);
							plugin::Data($client, 1, "Advanced-Pet-$skill", $skill_rank);
							plugin::Whisper("You have successfully learned ancient knowledge pertaining to $skill Rank $skill_rank_string.");
							my $after_aa_points = $client->GetAAPoints();
							plugin::LogSkill($skill, $before_aa_points, $after_aa_points);
						} else {
							my $required = plugin::commify($skill_cost - $client->GetAAPoints());
							plugin::Whisper("You need $required more AA Points.");
						}
					} else {
						plugin::Whisper("You seem to already have this knowledge.");
					}
				}
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}