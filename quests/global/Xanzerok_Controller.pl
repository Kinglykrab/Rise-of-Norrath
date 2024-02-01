sub EVENT_SPAWN {
	$npc->ModifyNPCStat("special_abilities", "24,1^35,1");
	my %spawns_hash = (0 => [2000245, -827.40, 653.95, 263.56, 423.5],
	1 => [2000246, -71.09, 925.97, 213.26, 474.5],
	2 => [2000247, 527.49, 1349.71, 208.60, 194.5],
	3 => [2000248, -1328.66, 653.85, 205.47, 132.8]);
	foreach my $spawn (sort {$a <=> $b} keys %spawns_hash) {
		plugin::Spawn2($spawns_hash{$spawn}[0], 1, $spawns_hash{$spawn}[1], $spawns_hash{$spawn}[2], $spawns_hash{$spawn}[3], $spawns_hash{$spawn}[4]);
	}
	quest::settimer("Trees", 1);
}

sub EVENT_TIMER {
	if ($timer eq "Trees") {
		quest::stoptimer("Trees");
		if (!plugin::Spawned(2000245..2000248)) {
			plugin::ZoneAnnounce("Xanzerok, the Tree of Life emerges from the earth, ready to attack.");
			plugin::Spawn2(2000201, 1, $x, $y, $z, $h);
			quest::depopall(2000244);
		} else {
			quest::settimer("Trees", 1);
		}
	}
}