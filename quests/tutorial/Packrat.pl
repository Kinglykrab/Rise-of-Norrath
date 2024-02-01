sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $exchange_id = plugin::Data($client, 3, "Exchange");
			if ($exchange_id < 1) {
				plugin::Whisper("Hail $name, I am the Hoarder of Molds.
				If you want to trade for a mold bring four molds and I will allow you to choose one mold of any slot.
				Make sure you hand me four molds from the same tier!");
			} else {
				plugin::Whisper("Hail $name, it seems you forgot to exchange last time you gave me molds!");
				plugin::ExchangeMold(0, $exchange_id);
			}
		} elsif ($text=~/^Exchange/i) {
			my $mold = substr($text, 9);
			my $mold_link_one = quest::saylink("mold $mold", 1, "exchange");
			my $mold_link_two = quest::varlink($mold);
			plugin::Whisper("Are you sure you want to exchange 4 $mold_link_one for a $mold_link_two?");
		} elsif ($text=~/^Mold/i) {
			my $mold = substr($text, 5);
			plugin::ExchangeMold(1, $mold);
		}
	}
}

sub EVENT_ITEM {
	my %molds_cost_hash = (
		1 => [166000..166006],
		2 => [166007..166013],
		3 => [166014..166020],
		4 => [166021..166027],
		5 => [166028..166034],
		6 => [166035..166041],
		7 => [166042..166048],
		8 => [166049..166055],
		9 => [166056..166062],
		10 => [166063..166069],
		11 => [166070..166076],
		12 => [166077..166083],
		13 => [166084..166090],
		14 => [166091..166097],
		15 => [166098..166104],
		16 => [166105..166111],
		17 => [166112..166118],
		18 => [166119..166125],
		19 => [166126..166132],
		20 => [166133..166139],
	);
	my %handin_hash = (
		1 => 0,
		2 => 0,
		3 => 0,
		4 => 0,
		5 => 0,
		6 => 0,
		7 => 0,
		8 => 0,
		9 => 0,
		10 => 0,
		11 => 0,
		12 => 0,
		13 => 0,
		14 => 0,
		15 => 0,
		16 => 0,
		17 => 0,
		18 => 0,
		19 => 0,
		20 => 0
	);
	if (plugin::Data($client, 3, "Exchange") < 1) {
		foreach my $tier (sort {$a <=> $b} keys %molds_cost_hash) {
			foreach my $mold (@{$molds_cost_hash{$tier}}) {
				if (defined $itemcount{$mold}) {
					$handin_hash{$tier} = ($handin_hash{$tier} + $itemcount{$mold});					
				}
			}
			
			if ($handin_hash{$tier} == 4) {
				delete $itemcount{$_} for (keys %itemcount);
				plugin::Data($client, 1, "Exchange", $tier);
				plugin::ExchangeMold(0, $tier);
			}
		}
	}
	plugin::return_items();
}
		