sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my $spell_link = quest::saylink("spells", 1);
		my $discipline_link = quest::saylink("disciplines", 1);
		plugin::Whisper("Hail $name. I can perform many actions involving $spell_link and $discipline_link.");
		if(quest::istaskactivityactive(1,2)) {
			plugin::Whisper("Well hello there! Normally your skills and spells will automatically scribe and max upon leveling. But after a patch it is always wise to come and
			see me in case any spells or abilities get added to your class!");
			plugin::Whisper("Go speak with Guardian Pocliosis. He always has a task needing done that will test your meddle in combat!");
		}
	} elsif ($text=~/Spells/i) {
		my $scribe_link = quest::saylink("scribe 1 70", 1);
		my $unscribe_link = quest::saylink("unscribe", 1);
		plugin::Whisper("Simply say $scribe_link and I will scribe your spells based on that level range, or I can $unscribe_link your spells.");
	} elsif ($text=~/Disciplines/i) {
		my $train_link = quest::saylink("train 1 70", 1);
		my $untrain_link = quest::saylink("untrain", 1);
		plugin::Whisper("Simply say $train_link and I will train your disciplines based on that level range, or I can $untrain_link your disciplines.");
	} elsif ($text=~/Train/i) {
		my @levels = split(' ', $text);
		if($levels[0] eq "train") {
			quest::traindiscs($levels[2], $levels[1]);
		} else {
			quest::untraindiscs();
		} 
	} elsif ($text=~/Scribe/i) {
		my @levels = split(' ', $text);
		if($levels[0] eq "scribe") {
			quest::scribespells($levels[2], $levels[1]);
		} else {
			$client->UnscribeSpellAll(1);
			$client->UnmemSpellAll();
		}
	} 
}

sub EVENT_ITEM {
	plugin::return_items();
}