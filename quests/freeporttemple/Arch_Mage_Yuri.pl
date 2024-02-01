sub EVENT_SAY {
	my %types_data = (
		0 => ["health", "Health"],
		1 => ["mana", "Mana"],
		2 => ["platinum", "Platinum"],
		3 => ["aa_points", "AA Points"],
		4 => ["armor_class", "Armor Class"],
	);
	if ($text=~/Hail/i) {
		my $add_link = quest::saylink("add", 1);
		my $delete_link = quest::saylink("delete", 1);
		my $hide_link = quest::saylink("hide", 1);
		my $view_link = quest::saylink("view", 1, "view");
		my $view_class_link = quest::saylink("viewc", 1, "view");
		plugin::Whisper("Hail $name, I am in charge of the book keeping here.
		Would you like to $add_link your stats to the books, 
		$delete_link your stats from the books,
		$hide_link your stats from the books, 
		$view_link the books, 
		or $view_class_link the books by class?");
	} elsif ($text=~/Add/i) {
		plugin::AddStats(0);
	} elsif ($text=~/Delete/i) {
		plugin::DeleteStats();
	} elsif ($text=~/^Hide$/i) {
		my $public_link = quest::saylink("hide 0", 1);
		my $private_link = quest::saylink("hide 1", 1);
		plugin::Message("Set Stats to Public: /say $public_link");
		plugin::Message("Set Stats to Private: /say $private_link");
	} elsif ($text=~/^Hide/i) {
		my $setting = substr($text, 5);
		plugin::SetPrivacy($setting);
	} elsif ($text=~/^View$/i) {
		foreach my $type (sort {$a <=> $b} keys %types_data) {
			my $type_name = $types_data{$type}[1];
			my $view_first_link = quest::saylink("view $type 0", 1);
			my $view_second_link = quest::saylink("view $type 10", 1);
			plugin::Message("Ranks 1 to 10 Sorted by $type_name: /say $view_first_link");
			plugin::Message("Ranks 11 to 20 Sorted by $type_name: /say $view_second_link");
		}
	} elsif ($text=~/^Viewc$/i) {	
		foreach my $type (sort {$a <=> $b} keys %types_data) {
			my $type_name = $types_data{$type}[1];
			my $view_first_link = quest::saylink("view $type 0 Warrior", 1);
			my $view_second_link = quest::saylink("view $type 10 Warrior", 1);
			my $view_third_link = quest::saylink("view $type 0 Warrior Cleric", 1);
			my $view_fourth_link = quest::saylink("view $type 10 Warrior Cleric", 1);
			plugin::Message("Ranks 1 to 10 Sorted by $type_name for a Single Class: /say $view_first_link");
			plugin::Message("Ranks 11 to 20 Sorted by $type_name for a Single Class: /say $view_second_link");
			plugin::Message("Ranks 1 to 10 Sorted by $type_name for Multiple Classes: /say $view_third_link");
			plugin::Message("Ranks 11 to 20 Sorted by $type_name for Multiple Classes: /say $view_fourth_link");
		}
	} elsif ($text=~/^View/i) {
		my @data = split(/ /, substr($text, 5));
		if (!defined $data[2]) {
			plugin::ViewStats(@data);
		} else {
			plugin::ViewStatsByClass(@data);
		}
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}