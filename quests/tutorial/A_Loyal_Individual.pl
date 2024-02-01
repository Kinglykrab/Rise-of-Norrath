sub EVENT_SAY {
	my $loyalty_link = quest::varlink(300);
	if ($text=~/Hail/i) {
		my $view_link = quest::saylink("view", 1);
		plugin::Whisper(
			"Hail $name, I can exchange your Platinum for $loyalty_link, would you like to $view_link my shop?"
		);
	} elsif ($text=~/View/i) {
		plugin::Message("= | Loyalty Credits");
		for my $type (1, 2, 5, 10, 20, 50, 100) {
			my $cost = (500000 * $type);
			my $cost_string = plugin::commify($cost);
			my $buy_link = quest::saylink("buy $type", 1, "Buy");
			plugin::Message("== | $type $loyalty_link | $cost_string Platinum | $buy_link");
		}
	} elsif ($text=~/Buy/i) {
		my $amount = substr($text, 4);
		plugin::ExchangeLoyalty($amount);
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}