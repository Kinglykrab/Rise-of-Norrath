sub EVENT_SAY {
	my %pet_costs_hash = plugin::PetCostsHash();
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $acquire_link = quest::saylink("acquire", 1);
			plugin::Whisper(
				"Hail $name, I am the master of companions.
				To $acquire_link a leash you must first find the necessary components."
			);
		} elsif ($text=~/Acquire/i) {
			plugin::Message("= | Pet Leash Recipes");
			foreach my $pet_leash (sort {$a <=> $b} keys %pet_costs_hash) {
				my $leash_item_id = $pet_costs_hash{$pet_leash}[0];
				my $leash_link = quest::varlink($leash_item_id);
				my $view_link = quest::saylink("leash $pet_leash", 1, "View");
				plugin::Message("== | $pet_leash. $leash_link | $view_link");
			}
		} elsif ($text=~/^Leash/i) {
			my $leash = substr($text, 6);
			plugin::Whisper(
				"Ah, so you've gathered the necessary components?
				First, make sure you have what I need."
			);
			plugin::ListLeashRecipe($leash);
		} elsif ($text=~/^Buy/i) {
			my $leash_item_id = substr($text, 4);
			plugin::UpgradePet($leash_item_id);
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::UpgradePet();
	plugin::return_items();
}