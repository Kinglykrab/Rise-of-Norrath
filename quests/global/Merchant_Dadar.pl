sub EVENT_SAY {
	my %augment_cost_data = plugin::AugmentCostData();
	my $crystal_type = plugin::GetCrystalType(2);
	if (plugin::Data($client, 3, "Progression") >= 10) {
		if ($text=~/Hail/i) {
			my $wares_link = quest::saylink("wares", 1);
			plugin::Whisper("Hail $name, would you like to view my $wares_link?");
		} elsif ($text=~/^Wares/i) {
			foreach my $item_type (sort {$a cmp $b} keys %augment_cost_data) {
				my $type_link = quest::saylink("type $item_type", 1, "$item_type Augments");
				plugin::Message("= | $type_link");
			}
		} elsif ($text=~/^Type/i) {
			my $item_type = substr($text, 5);			
			foreach my $augment_type (sort {$a cmp $b} keys %{$augment_cost_data{$item_type}}) {
				my $shop_link = quest::saylink("shop $item_type $augment_type", 1, $augment_type);
				plugin::Message("== | $shop_link");
			}
		} elsif ($text=~/^Shop/i) {
			my ($item_type, $shop_type) = split(/ /, substr($text, 5));
			my $ranks = ($item_type eq "Proc" ? 10 : 5);
			my @item_ids = @{$augment_cost_data{$item_type}{$shop_type}[0]};
			for (my $rank = 1; $rank < $ranks; $rank++) {
				my $real_rank = ($rank + 1);
				my $tier_flag = ($rank + 9);
				my $real_rank_string = plugin::Tier($real_rank);
				my $view_link = quest::saylink(
					"view $item_type $shop_type $rank",
					1,
					"Rank $real_rank_string $shop_type Recipe"
				);
				if (plugin::Data($client, 3, "Progression") >= $tier_flag) {
					plugin::Message("=== | $rank. $view_link");
				}
			}
		} elsif ($text=~/^View/i) {
			my ($item_type, $shop_type, $rank) = split(/ /, substr($text, 5));
			my $previous_rank = ($rank - 1);
			my $previous_item_id = $augment_cost_data{$item_type}{$shop_type}[0][$previous_rank];
			my $item_id = $augment_cost_data{$item_type}{$shop_type}[0][$rank];
			my $item_cost_crystals = plugin::commify($augment_cost_data{$item_type}{$shop_type}[1][$rank]);
			my $item_cost_shards = $augment_cost_data{$item_type}{$shop_type}[2];
			my $item_link = quest::varlink($item_id);
			my $previous_link = quest::varlink($previous_item_id);
			my $craft_link = quest::saylink("craft $item_type $shop_type $rank", 1, "Craft");
			my $tier = ($rank + 1);
			my $tier_shard = quest::varlink($tier);
			my $crystal_id = $crystal_type eq "Ebon" ? 40902 : 40903;
			my $crystal_link = quest::varlink($crystal_id);
			plugin::Message("= | $item_link");
			plugin::Message("== | 2 $previous_link | $item_cost_crystals $crystal_link | $item_cost_shards $tier_shard");
			plugin::Message("=== | $craft_link");
		} elsif ($text=~/^Craft/i) {
			my ($item_type, $shop_type, $rank) = split(/ /, substr($text, 6));
			my $previous_rank = ($rank - 1);
			my $previous_item_id = $augment_cost_data{$item_type}{$shop_type}[0][$previous_rank];
			my $item_id = $augment_cost_data{$item_type}{$shop_type}[0][$rank];
			my $item_cost_crystals = $augment_cost_data{$item_type}{$shop_type}[1][$rank];
			my $item_cost_shards = $augment_cost_data{$item_type}{$shop_type}[2];
			my $tier_shard = ($rank + 1);
			my $currency_id = quest::getcurrencyid($tier_shard);
			my $before_shards = plugin::GetCurrency($client, $currency_id);
			my $before_crystals = plugin::GetCrystalType(1);
			my $item_check = quest::countitem($previous_item_id);
			if (
				$before_shards >= $item_cost_shards && 
				$before_crystals >= $item_cost_crystals && 
				$item_check >= 2
			) {
				plugin::AddCrystals($client, $crystal_type, 1, $item_cost_crystals);
				plugin::TakeCurrency($client, $currency_id, $item_cost_shards);
				quest::removeitem($previous_item_id, 2);
				quest::summonitem($_) for (52023, $item_id);
				plugin::Whisper("I was able to gather together my energy into a new augment for you, enjoy.");
				if ($client->Admin() != 255) {
					plugin::GearAnnounce($item_id);
				}
				my (
					$after_shards,
					$after_crystals,
				) = (
					plugin::GetCurrency($client, $currency_id),
					plugin::GetCrystalType(1),
				);
				plugin::LogAugment(
					$item_type, 
					$shop_type, 
					$item_id, 
					$before_shards, 
					$after_shards, 
					$before_crystals, 
					$after_crystals
				);
			} else {
				plugin::Whisper("You do not have what I require, do not waste my time!");
				return;
			}
		}
	} else {
		plugin::Whisper("I only speak to those who have progressed to Tier Ten or higher.");
	}
}