sub EVENT_SAY {
	if ($ulevel == 70) {
		if ($text=~/Hail/i) {
			my $wares_link = quest::saylink("wares", 1);
			plugin::Whisper("Hail $name, would you like to view my $wares_link?");
		} elsif ($text=~/Wares/i) {
			my (
				$molds_link,
				$offset_link,
			) = (
				quest::saylink("molds", 1),
				quest::saylink("offset", 1),
			);
			plugin::Whisper("Are you looking for $molds_link or $offset_link pieces?");
		} elsif ($text ~~ ["molds", "offset"]) {
			my $type = ($text =~ /Molds/i ? "Molds" : "Offset");
			my $type_text = ($type eq "Molds" ? "molds" : "offset pieces");
			my $tier_flag = plugin::Data($client, 3, "Progression");
			plugin::Whisper("I have the following $type_text available for you.");
			for (my $tier = 1; $tier <= $tier_flag; $tier++) {
				my $tier_name = plugin::Tier($tier);
				my $tier_link = quest::saylink("tier $tier $type", 1, "View");
				plugin::Message("= | Tier $tier_name $type | $tier_link");
			}
		} elsif ($text=~/^Tier/i) {
			my %tier_merchant_hash = plugin::TierMerchantHash();
			if (length($text) > 5) {
				my ($tier, $type) = split(" ", substr($text, 5));
				my $tier_pattern = (166200 + ($tier - 1));
				my $tier_pattern_link = quest::varlink($tier_pattern);
				my @tier_items = ($type eq "Offset" ? @{$tier_merchant_hash{$tier}[0]} : @{$tier_merchant_hash{$tier}[1]});
				my $tier_cost = $tier_merchant_hash{$tier}[2];
				my $tier_name = plugin::Tier($tier);
				plugin::Whisper("I see you're interested in recipes.");
				foreach my $tier_item (@tier_items) {
					my $tier_item_count = quest::countitem($tier_item);
					if (
						$type eq "Molds" || 
						(
							$type eq "Offset" && 
							(
								$client->CanClassEquipItem($tier_item) && 
								(
									$tier_item_count == 0 || 
									(
										$tier_item_count < 2 && 
										(
											$client->GetItemStat($tier_item, "slots") & 18 || 
											$client->GetItemStat($tier_item, "slots") & 98304
										)
									)
								)
							)
						)
					) {
						my $tier_item_link = quest::varlink($tier_item);
						my $tier_view_link = quest::saylink("view $tier $type $tier_item", 1, "View");
						plugin::Message("= | $tier_item_link | $tier_view_link");
					}
				}
			}
		} elsif ($text=~/^View/i) {
			my %tier_merchant_hash = plugin::TierMerchantHash();
			if (length($text) > 5) {
				my ($tier, $type, $tier_item) = split(" ", substr($text, 5));
				my $tier_pattern = (166200 + ($tier - 1));
				my $tier_pattern_link = quest::varlink($tier_pattern);
				my @tier_items = ($type eq "Offset" ? @{$tier_merchant_hash{$tier}[0]} : @{$tier_merchant_hash{$tier}[1]});
				my $tier_cost = $tier_merchant_hash{$tier}[2];
				my $tier_name = plugin::Tier($tier);
				my $tier_item_link = quest::varlink($tier_item);
				my $tier_craft_link = quest::saylink("craft $tier $type $tier_item", 1, "Craft");
				plugin::Whisper("So you've finally found an item you want to craft? First, make sure you have what I need.");
				plugin::Message("= | $tier_item_link");
				plugin::Message("== | $tier_cost $tier_pattern_link");
				plugin::Message("=== | $tier_craft_link");
			}
		} elsif ($text=~/^Craft/i) {
			my %tier_merchant_hash = plugin::TierMerchantHash();
			if (length($text) > 6) {
				my ($tier, $type, $tier_item) = split(" ", substr($text, 6));
				my $tier_pattern = (166200 + ($tier - 1));
				my $tier_pattern_link = quest::varlink($tier_pattern);
				my $tier_cost = $tier_merchant_hash{$tier}[2];
				my $tier_name = plugin::Tier($tier);
				my $tier_currency_id = quest::getcurrencyid($tier_pattern);
				my $before_tier_currency = plugin::GetCurrency($client, $tier_currency_id);
				if ($before_tier_currency >= $tier_cost) {
					plugin::TakeCurrency($client, $tier_currency_id, $tier_cost);
					my $after_tier_currency = plugin::GetCurrency($client, $tier_currency_id);
					plugin::LogMoldOffset(
						$tier, 
						$type, 
						$tier_item, 
						$before_tier_currency, 
						$after_tier_currency,
					);
					quest::summonitem($tier_item);
					plugin::GearAnnounce($tier_item);
				} else {
					plugin::Whisper("You do not have the necessary crafting components!");
				}
			}
		}
	} else {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}