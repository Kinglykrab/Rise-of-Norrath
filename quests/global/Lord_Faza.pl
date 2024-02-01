sub EVENT_SAY {
	my %shop_data = plugin::ShopData();
	if ($text=~/Hail/i) {
		plugin::Whisper("Hail $name, would you like me to view my " . quest::saylink("shops", 1) . "?");
	} elsif ($text=~/Shops/i) {
		foreach my $key (sort {$a cmp $b} keys %shop_data) {
			plugin::Message("= | " . quest::saylink("list $key 0 10", 1, "Show $key Shop"));
		}
	} elsif ($text=~/Buy/i) {
		my @data = split(/ /, substr($text, 4));
		my (
			$type,
			$index,
		) = @data;
		plugin::BuyFromShop($type, $index);
	} elsif ($text=~/List/i) {
		my @data = split(/ /, substr($text, 5));
		my (
			$type,
			$min,
			$max,
		) = @data;
		plugin::DisplayShop($type, $min, $max);
	}
}

sub EVENT_ITEM {
	plugin::return_items(\%itemcount);
}