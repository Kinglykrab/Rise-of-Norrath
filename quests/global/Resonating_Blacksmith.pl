sub EVENT_SAY {
	my %resonating_items_hash = (
		"Warrior" => [186000..186006],
		"Cleric" => [186007..186013],
		"Paladin" => [186014..186020],
		"Ranger" => [186021..186027],
		"Shadowknight" => [186028..186034],
		"Druid" => [186035..186041],
		"Monk" => [186042..186048],
		"Bard" => [186049..186055],
		"Rogue" => [186056..186063],
		"Shaman" => [186063..186069],
		"Necromancer" => [186070..186076],
		"Wizard" => [186077..186083],
		"Magician" => [186084..186090],
		"Enchanter" => [186091..186097],
		"Beastlord" => [186098..186104],
		"Berserker" => [186105..186111]
	);
	my @molds = (166140..166146);
	my $n = 1;
	my @class_items = @{$resonating_items_hash{$class}};
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			plugin::Whisper("Hail $name, I am the Forgemaster.<br><br>
			If you want to look at recipes, check in your chat window.", 0, 999);
			foreach my $item (@class_items) {
				plugin::Message($n . ". " . quest::varlink($item) . " - " . quest::saylink("view $item", 1, "View Recipe"));
				$n++;
			}
		} elsif ($text=~/^View/i) {
			my $item = substr($text, 5);
			my $mold_index = (($item - 186000) % 7);
			my $mold = $molds[$mold_index];
			plugin::Message("= | " . quest::varlink($item) . " Requirements");
			plugin::Message("== | " . quest::varlink($mold) . " and " . quest::varlink(166147));
			plugin::Message("=== | " . quest::saylink("craft $item", 1, "Craft"))
		} elsif ($text=~/Craft/i) {
			my $item = substr($text, 6);
			plugin::ForgeResonatingItem($item);
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.", 0, 999);
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}