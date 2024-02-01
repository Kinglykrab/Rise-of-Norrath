sub ViewDonatorMerchant {
	my $merchant_type = shift;
	my $client = plugin::val('client');
	my $currency_link = quest::varlink(187000);
	my $currency_string = plugin::commify(plugin::GetCurrency($client, 11));
	my $currency_dollars_string = "\$" . plugin::commify(plugin::GetCurrency($client, 11) / 100);
	my %donator_merchant_hash = plugin::DonatorMerchantHash();
	plugin::Message("= | $merchant_type");
	foreach my $item_id (
		sort {
			$donator_merchant_hash{$merchant_type}{$b} 
			<=> 
			$donator_merchant_hash{$merchant_type}{$a}
		} keys %{$donator_merchant_hash{$merchant_type}}
	) {
		if ($merchant_type ~~ ["Epic 1.5", "Epic 2.0", "Epic 3.0", "Fruit"]) {
			if (!$client->CanClassEquipItem($item_id)) {
				next;
			}
		}
		my $item_cost = $donator_merchant_hash{$merchant_type}{$item_id};
		my $item_cost_string = plugin::commify($item_cost);
		my $item_link = quest::varlink($item_id);
		my $credit_link = quest::varlink(quest::getcurrencyitemid(11));
		my $buy_link = quest::saylink("buy $item_id $merchant_type", 1, "Buy");
		plugin::Message("== | $item_link");
		plugin::Message("=== | $item_cost_string $credit_link");
		plugin::Message("==== | $buy_link");
	}
	plugin::Message("= | Current Balance: $currency_dollars_string ($currency_string $currency_link)");
}

sub BuyDonatorItem {
	my (
		$merchant_type,
		$item_id,
	) = (
		shift,
		shift,
	);
	my $client = plugin::val('client');
	my %donator_merchant_hash = plugin::DonatorMerchantHash();
	my $before_credits = plugin::GetCurrency($client, 11);
	my $item_cost = $donator_merchant_hash{$merchant_type}{$item_id};
	my $item_cost_string = plugin::commify($item_cost);
	my $item_link = quest::varlink($item_id);
	my $credit_link = quest::varlink(quest::getcurrencyitemid(11));
	if ($before_credits >= $item_cost) {
		my $after_credits = ($before_credits - $item_cost);
		my $after_credits_string = plugin::commify($after_credits);
		plugin::TakeCurrency($client, 11, $item_cost);
		plugin::Message("= | You have purchased a $item_link for $item_cost_string $credit_link, you now have $after_credits_string $credit_link.");
	#	if ($client->Admin() < 255) {
			plugin::LogDonator($merchant_type, $item_id, $before_credits, $after_credits);
		#}
		quest::summonitem($item_id);
	} else {
		plugin::Message("= | You do not have enough credits for that.");
	}
}

sub Donator_Shop_Types {
	my %donator_merchant_hash = plugin::DonatorMerchantHash();
	my @donator_shop_types = ();
	foreach my $keys (keys %donator_merchant_hash) {
		push(@donator_shop_types,$keys);
	}
	if($donator_shop_types[1]) { return @donator_shop_types; }
}

sub DonatorMerchantHash {
	my %donator_merchant_hash = (
		"Ornaments" => {
		201739 => 2500,
		201741 => 2500,
		201743 => 2500,
		201745 => 2500,
		201746 => 2500,
		201754 => 2500,
		201755 => 2500,
		201757 => 2500,
		201761 => 2500
		},
		"Loot Modifiers" => {
			200015 => 1500,
		},
		"Tiers" => {
			201 => 200,
			202	=> 300,
			203 => 400,
			204 => 500,
			205 => 1000,
			206 => 1200,
			207 => 1400,
			208 => 1600,
			209 => 1800,
			210 => 2000,
			211 => 2200,
			212 => 2400,
			213 => 2600
		},
		"Charm" => {
			200300 => 25000,
			200301 => 50000,
			200302 => 75000,
		},
		"Server Investments" => {
			200400 => 25000,
			200401 => 25000*2,
			200402 => 25000*3,
			200403 => 25000*4,
			200404 => 25000*5,
		},
		"Mount" => {
			66312 => 3000,
			66313 => 3000,
			66314 => 3000,
			66315 => 3000,
			66309 => 2000,
			66307 => 2000,
			66305 => 1000,
			66308 => 1000,
		},
		"Miscellaneous" => {
			52023 => 10,
			187002 => 50,
			200200 => 1000,
			200201 => 1500,
			200202 => 3000,
			200000 => 3000,
			200205 => 3000,
			200012 => 4000,
			200208 => 2500,
			200207 => 1000
		},
		"Fruit" => {
			169200 => 17500,
			169201 => 17500,
			169202 => 17500,
			169203 => 17500,
			169204 => 17500,
			169205 => 17500,
			169206 => 17500,
			169207 => 17500,
			169208 => 17500,
			169209 => 17500,
			169210 => 17500,
			169211 => 17500,
			169212 => 17500,
			169213 => 17500,
			169214 => 17500,
			169215 => 17500,
		},
		"Epic 1.5" => {
			151000 => 750,
			151001 => 750,
			151002 => 750,
			151003 => 750,
			151004 => 750,
			151005 => 750,
			151006 => 750,
			151007 => 750,
			151008 => 750,
			151009 => 750,
			151010 => 750,
			151011 => 750,
			151012 => 750,
			151013 => 750,
			151014 => 750,
			151015 => 750,
			151016 => 750,
			151017 => 750,
			151018 => 750,
		},
		"Epic 2.0" => {
			152000 => 2000,
			152001 => 2000,
			152002 => 2000,
			152003 => 2000,
			152004 => 2000,
			152005 => 2000,
			152006 => 2000,
			152007 => 2000,
			152008 => 2000,
			152009 => 2000,
			152010 => 2000,
			152011 => 2000,
			152012 => 2000,
			152013 => 2000,
			152014 => 2000,
			152015 => 2000,
			152016 => 2000,
			152017 => 2000,
			152018 => 2000,
		},
		"Epic 3.0" => {
			153000 => 10000,
			153001 => 10000,
			153002 => 10000,
			153003 => 10000,
			153004 => 10000,
			153005 => 10000,
			153006 => 10000,
			153007 => 10000,
			153008 => 10000,
			153009 => 10000,
			153010 => 10000,
			153011 => 10000,
			153012 => 10000,
			153013 => 10000,
			153014 => 10000,
			153015 => 10000,
			153016 => 10000,
			153017 => 10000,
			153018 => 10000,
		},
		"Experience Bonuses" => {
			200001 => 100,
			200002 => 200,
			200003 => 300,
			200004 => 400,
			200005 => 500,
			200006 => 600,
			200007 => 700,
			200008 => 800,
			200009 => 900,
			200010 => 1000,
		},
		"Illusion" => {
			200100 => 500,
			200101 => 500,
			200102 => 500,
			200103 => 500,
			200104 => 500,
			200105 => 500,
			200106 => 500,
			200107 => 500,
			200108 => 500,
			200109 => 500,
			200110 => 500,
			200111 => 500,
			200112 => 500,
			200113 => 500,
			200114 => 500,
			200115 => 500,
			200116 => 500,
			200117 => 500,
			200118 => 500,
			200119 => 500,
			200120 => 500,
			200121 => 500,
			200122 => 500,
			200123 => 500,
			200124 => 500,
			200125 => 500,
			200126 => 500,
			200127 => 500,
			200128 => 500,
			200129 => 500,
		},
	);
	return %donator_merchant_hash;
}