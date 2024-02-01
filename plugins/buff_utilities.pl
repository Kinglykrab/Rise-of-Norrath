# plugin::BuffCost();
sub BuffCost {
	my $client = plugin::val('client');
	my $ulevel = $client->GetLevel();
	my %buffs_hash = plugin::BuffsHash();
	my $buffs_cost = 0;
	foreach my $buff_cost (sort {$a <=> $b} keys %buffs_hash) {
		my (
			$buff_min_level,
			$buff_max_level,
		) = (
			$buffs_hash{$buff_cost}[0],
			$buffs_hash{$buff_cost}[1],
		);
		my @buff_level_range = ($buff_min_level..$buff_max_level);
		if ($ulevel ~~ @buff_level_range) {
			$buffs_cost = $buff_cost;
		}
	}
	return $buffs_cost;
}

# plugin::BuffsHash();
sub BuffsHash {
	my %buffs_hash = (
		0 => [1, 10, [219, 279, 269, 266, 40, 39, 697, 2524, 46, 129, 13, 11274]],
		10 => [11, 20, [89, 283, 148, 2512, 147, 170, 174, 2524, 46, 432, 13, 11274]],
		25 => [21, 30, [244, 149, 148, 349, 151, 10, 1693, 4055, 356, 13, 11274]],
		50 => [31, 40, [312, 161, 160, 152, 153, 171, 1694, 169, 1727, 13, 11274]],
		100 => [41, 50, [4053, 158, 154, 157, 159, 172, 1695, 2517, 1560, 13, 11274]],
		250 => [51, 60, [1447, 1580, 1579, 1596, 1581, 1729, 2570, 2517, 1561, 13, 11274]],
		500 => [61, 65, [3467, 3397, 4883, 3234, 1710, 3350, 2519, 2517, 3448, 13, 11274]],
		5000 => [66, 100, [27030, 14282, 3472, 3479, 5415, 5355, 5352, 5513, 3444, 3185, 1708, 13, 432, 11274]],
	);
	return %buffs_hash;
}

# plugin::HandleBuffs($type, $client);
sub HandleBuffs {
	my %buffs_hash = plugin::BuffsHash();
	my $type = shift;
	my $client = plugin::val('client');
	my $client_level = $client->GetLevel();
	foreach my $buff_cost (sort {$a <=> $b} keys %buffs_hash) {
		my ($buff_min_level, $buff_max_level) = ($buffs_hash{$buff_cost}[0], $buffs_hash{$buff_cost}[1]);
		my @buff_level_range = ($buff_min_level..$buff_max_level);
		my @buff_spell_ids = sort @{$buffs_hash{$buff_cost}[2]};
		my $cost = ($type eq "Command" ? ($buff_cost * 10) : $buff_cost);
		if ($client_level ~~ @buff_level_range) {
			if ($cost == 0 || ($cost > 0 && plugin::GetPlatinum($client) >= $cost)) {
				plugin::TakePlatinum($client, $cost);
				$client->SpellFinished($_, $client, 0) for @buff_spell_ids;
			} else {
				if ($type eq "NPC") {
					plugin::Whisper("You do not have enough Platinum, buffs for your level cost " . plugin::commify($cost) . " Platinum!");
				} elsif ($type eq "Command") {
					plugin::Message("You do not have enough Platinum, buffs for your level cost " . plugin::commify($cost) . " Platinum!");
				}
			}
			last;
		}
	}
}