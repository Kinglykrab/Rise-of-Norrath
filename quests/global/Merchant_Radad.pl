sub EVENT_SAY {
	my %augment_cost_data = plugin::AugmentCostData();
	my $progression_flag = plugin::Data($client, 3, "Progression");
	my $crystal_type = plugin::GetCrystalType(2);
	if ($progression_flag >= 10) {
		my $wares_link = quest::saylink("wares", 1);
		if ($text=~/Hail/i) {
			plugin::Whisper("Hail $name, would you like to view my $wares_link?");
		} elsif ($text=~/Wares/i) {
			foreach my $item_type (sort {$a cmp $b} keys %augment_cost_data) {
				my $type_link = quest::saylink("type $item_type", 1, "$item_type Augments");
				plugin::Message("= | $type_link");
			}
		} elsif ($text=~/Type/i) {
			my $item_type = substr($text, 5);			
			foreach my $augment_type (sort {$a cmp $b} keys %{$augment_cost_data{$item_type}}) {
				my $shop_link = quest::saylink("shop $item_type $augment_type", 1, $augment_type);
				plugin::Message("== | $shop_link");
			}
		} elsif ($text=~/Shop/i) {
			my ($item_type, $shop_type) = split(/ /, substr($text, 5));
			my @item_ids = @{$augment_cost_data{$item_type}{$shop_type}[0]};
			my $item_cost_crystals = plugin::commify($augment_cost_data{$item_type}{$shop_type}[1][0]);
			my $item_cost_shards = $augment_cost_data{$item_type}{$shop_type}[2];
			my $tier_shard = quest::varlink(1);
			my $crystal_id = $crystal_type eq "Ebon" ? 40902 : 40903;
			my $crystal_link = quest::varlink($crystal_id);
			my $item_id = $item_ids[0];
			my $item_link = quest::varlink($item_id);
			my $craft_link = quest::saylink("craft $item_type $shop_type $item_id", 1, "Craft");
			plugin::Message("= | $item_link");
			plugin::Message("== | $item_cost_crystals $crystal_link | $item_cost_shards $tier_shard");
			plugin::Message("=== | $craft_link");
		} elsif ($text=~/Craft/i) {
			my $cursor_slot = quest::getinventoryslotid("cursor");
			if($client->GetItemIDAt($cursor_slot) == -1) {	#Splose: Check item @ cursor
				my ($item_type, $shop_type, $item_id) = split(/ /, substr($text, 6));
				my $item_cost_crystals = plugin::commify($augment_cost_data{$item_type}{$shop_type}[1][0]);
				my $item_cost_shards = $augment_cost_data{$item_type}{$shop_type}[2];
				my $tier_shard = 1;
				my $currency_id = quest::getcurrencyid($tier_shard);
				my $before_shards = plugin::GetCurrency($client, $currency_id);
				my $before_crystals = plugin::GetCrystalType(1);
				if (
					$before_shards >= $item_cost_shards && 
					$before_crystals >= $item_cost_crystals
				) {
					plugin::AddCrystals(
						$client,
						$crystal_type,
						1,
						$item_cost_crystals
					);					
					plugin::TakeCurrency(
						$client,
						quest::getcurrencyid($tier_shard),
						$item_cost_shards
					);
					quest::summonitem($_) for (52023, $item_id);
					plugin::Whisper("I was able to gather together my energy into a new augment for you, enjoy.");
					if ($client->Admin() != 255) {
						plugin::GearAnnounce($item_id);
					}
					my (
						$after_shards, 
						$after_crystals,
					) = (
						plugin::GetCurrency(
							$client,
							$currency_id
						),
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
			} else {
				plugin::Whisper("How can I craft your augment when your hands are full?! Drop the item on your cursor!");
			}
		}
	} else {
		plugin::Whisper("I only speak to those who have progressed to Tier Ten or higher.");
	}
}