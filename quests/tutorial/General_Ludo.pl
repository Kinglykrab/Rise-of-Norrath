sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my $materials_link = quest::saylink("materials", 1);
		my $upgrade_link = quest::saylink("upgrade", 1);
		plugin::Whisper(
			"Hail $name, I am General Ludo, I lead the army for King Valens.
			King Valens has taught me how to imbue items with limit breaking power.
			In order to imbue these items; however, I will need an assortment of $materials_link.
			If you return to me with what I need, you will become much more powerful.
			If you already have what I need, I can $upgrade_link it for you."
		);
	} elsif ($text=~/Materials/i) {
		plugin::SourceRanks();
	} elsif ($text=~/View/i) {
		my %source_ranks_hash = plugin::SourceRanksHash();
		my $rank = substr($text, 5);
		my $real_rank_string = plugin::Tier($rank + 1);
		my (
			$emblems,
			$aa_points,
			$crystals,
			$platinum,
		) = (
			$source_ranks_hash{$rank}[1],	
			$source_ranks_hash{$rank}[2],
			$source_ranks_hash{$rank}[3],
			$source_ranks_hash{$rank}[4],
		);
		my $emblem_link = quest::varlink(plugin::ProgressionEmblems());
		my $emblems_string = plugin::commify($emblems);
		my $aa_points_string = plugin::commify($aa_points);
		my $crystal_id = plugin::GetCrystalType(2) eq "Ebon" ? 40902 : 40903;
		my $crystal_link = quest::varlink($crystal_id);
		my $crystals_string = plugin::commify($crystals);
		my $platinum_string = plugin::commify($platinum);
		plugin::Message("== | Rank $real_rank_string Requirements");
		plugin::Message(
			"=== | 
			$emblems_string $emblem_link | 
			$aa_points_string AA Points | 
			$crystals_string $crystal_link | 
			$platinum_string Platinum"
		);
	} elsif ($text=~/Upgrade/i) {
		my $cursor_slot = quest::getinventoryslotid("cursor");
		if($client->GetItemIDAt($cursor_slot) == -1) {
			plugin::UpgradeSource();
		} else {
			plugin::Whisper("How can I craft your powersource when your hands are full?! Drop the item on your cursor!");
		}
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}