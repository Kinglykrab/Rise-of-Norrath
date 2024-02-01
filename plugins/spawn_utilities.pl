sub Spawned {
	my $entity_list = plugin::val('entity_list');
	my @npcs = @_;
	foreach my $npc (@npcs) {
		if ($entity_list->GetNPCByNPCTypeID($npc)) {
			return 1;
		}
	}
	
	return 0;
}

sub SpawnCount {
	my $entity_list = plugin::val('entity_list');
	my @npcs = @_;
	my $count = 0;
	foreach my $npc (@npcs) {
		if ($entity_list->GetNPCByNPCTypeID($npc)) {
			$count++;
		}
	}
	return $count;
}

sub Spawn2 {
	my $npcid = shift;
	my $amount = shift;
	my $x = shift;
	my $y = shift;
	my $z = shift;
	my $heading = shift;
	if ($amount > 1) {
		for my $i (1..$amount) {
			quest::spawn2($npcid, 0, 0, ($x + quest::ChooseRandom(-45..45)), ($y + quest::ChooseRandom(-45..45)), $z, $heading);
		}
	} else {
		quest::spawn2($npcid, 0, 0, $x, $y, $z, $heading);
	}
}

sub Proximity {
	my $npc = plugin::val('npc');
	my $variance = shift;
	quest::set_proximity(($npc->GetX() - $variance), ($npc->GetX() + $variance), ($npc->GetY() - $variance), ($npc->GetY() + $variance), ($npc->GetZ() - $variance), ($npc->GetZ() + $variance));
}