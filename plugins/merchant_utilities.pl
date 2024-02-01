sub ShopData {
	my %shop_data = (
		"Armor" =>
		[400, 
			[
				301..566
			]
		],
		"Nimbus" =>
		[1500, 
			[			
				40619..40621, 40657..40660, 40687..40691,
				40716..40720, 40748..40752, 40781..40785,
				43974, 43976..43978, 48972, 48974, 48975,
				48987, 50490, 50491, 50855..50858, 52194,
				52195, 53358, 53360, 53752, 53753, 54915,
				54918, 54984, 54985, 56060, 57379..57382,
				57474, 57529..57531, 57601, 60946, 60947,
				61035, 61955, 62769, 64708, 64746, 66950,
			]
		],
		"Weapon" =>
		[1000, 
			[
				800, 801, 41964..41971, 42991..42998, 43513..43520,
				43588..43595, 47721..47727, 48086, 48966,
				48967, 48982, 48983, 50485, 50486, 50859..50867,
				52189, 52190, 52281..52283, 55432..55440, 59476,
				61026..61034, 61946, 61947, 61970..61978,
				64692..64700, 64728..64736, 64949, 66422..66430,
				66435..66443, 67136..67144, 67871, 67874..67882,
				76782..76808, 124277..124292, 127053, 127055, 127057,
				127060, 127062, 127064..127066, 127068, 127119..127134,
				127913..127963	
			]
		],
	);
	return %shop_data;
}

# plugin::DisplayShop($type, $min, $max);
sub DisplayShop {
	my (
		$type,
		$min,
		$max,
	) = (
		shift,
		shift,
		shift,
	);
	my %shop_data = plugin::ShopData();
	my $item_cost = $shop_data{$type}[0];
	my @items = @{$shop_data{$type}[1]};
	plugin::Message("= | $type Merchant");
	for (my $index = $min; $index < $max; $index++) {
		my $item_index = ($index + 1);
		my $last_index = ($max - 1);
		my (
			$next_min,
			$next_max,
		) = (
			$max,
			($max + 10),
		);
		my (
			$item,
			$next_item,
		) = (
			$items[$index],
			$items[$next_max],
		);
		if ($item) {
			plugin::Message(
				"== | $item_index. " . 
				quest::varlink($item) . 
				" | " . 
				$item_cost . 
				" " . 
				quest::varlink(187000) . 
				" | " . 
				quest::saylink("buy $type $index", 1, "Buy")
			);
		} else {
			return;
		}
	
		if ($index == $last_index && $next_item) {
			plugin::Message("= | " . quest::saylink("list $type $next_min $next_max", 1, "Next 10"));
		}
	}
}

# plugin::BuyFromShop($type, $index);
sub BuyFromShop {
	my (
		$type,
		$index,
	) = (
		shift,
		shift,
	);
	my %shop_data = plugin::ShopData();
	my $amount = quest::countitem(187000);
	my $item_cost = $shop_data{$type}[0];
	my @items = @{$shop_data{$type}[1]};
	my $item = $items[$index];
	if ($item) {
		if ($amount >= $item_cost) {
			$amount -= $item_cost;
			quest::summonitem($item);
			quest::collectitems(187000, 1);
			if ($amount > 1000) {
				while ($amount >= 1000) {
					quest::summonitem(187000, 1000);
					$amount -= 1000;
				}
			}

			if ($amount > 0) {
				quest::summonitem(187000, $amount);
			}
		}
	}
}