sub EVENT_DEATH_COMPLETE {	#:: make these bad boys despawn
	quest::depopall(2000114);
}

sub EVENT_SPAWN {
	my %spawns = (
	0 => [-175, -150, -26, 96],
	1 => [-175, -125, -26, 96],
	2 => [-175, -100, -26, 96],
	3 => [-150, -150, -26, 96],
	4 => [-150, -125, -26, 96],
	5 => [-150, -100, -26, 96],
	6 => [-125, -150, -26, 96],
	7 => [-125, -125, -26, 96],
	8 => [-125, -100, -26, 96]);
	for (my $i = 0; $i < quest::ChooseRandom(1..2); $i++) {
		$npc->AddItem(168001, 1);
	}
	$npc->ModifyNPCStat("max_hp", 2000000);
	$npc->SetHP($npc->GetMaxHP());
	quest::setnexthpevent(80);
	quest::settimer($_, 1) for ("Spawn", "Summon");
	$npc->ModifyNPCStat("min_hit", 200);
	$npc->ModifyNPCStat("max_hit", 500);
	foreach my $key (keys %spawns) {
		plugin::Spawn2(2000114, 1, $spawns{$key}[0], $spawns{$key}[1], $spawns{$key}[2], $spawns{$key}[3]);
	}
}

sub EVENT_HP {
	my %spawns = (
	0 => [-175, -150, -26, 96],
	1 => [-175, -125, -26, 96],
	2 => [-175, -100, -26, 96],
	3 => [-150, -150, -26, 96],
	4 => [-150, -125, -26, 96],
	5 => [-150, -100, -26, 96],
	6 => [-125, -150, -26, 96],
	7 => [-125, -125, -26, 96],
	8 => [-125, -100, -26, 96]);
	if ($hpevent ~~ [20, 40, 60, 80, 100]) {
		quest::setnexthpevent($hpevent - 20);
		quest::setnextinchpevent($hpevent + 20);
		foreach my $key (keys %spawns) {
			plugin::Spawn2(2000114, 1, $spawns{$key}[0], $spawns{$key}[1], $spawns{$key}[2], $spawns{$key}[3]);
		}
	}
}


sub EVENT_TIMER {
	if ($timer eq "Spawn") {
		$addcount = CountSpawns(2000114);
		my $min_dmg = (200 + ($addcount * 100));
		my $max_dmg = (500 + ($addcount * 100));
		$npc->ModifyNPCStat("min_hit", $min_dmg);
		$npc->ModifyNPCStat("max_hit", $max_dmg);
		#quest::shout("timer: $addcount - $min_dmg / $max_dmg");
		quest::settimer("Spawn", 1);
	} elsif ($timer eq "Summon") {
		my @hatelist = $npc->GetHateList();
		my $summon = 0;
		foreach my $entity (@hatelist) {
			my $hate_entity = $entity->GetEnt();
			if ($hate_entity->IsClient()) {
				if (quest::ChooseRandom(0..100) > 75) {
					$hate_entity->CastToClient()->MovePC($zoneid, $x, $y, $z, $h);
					$summon = 1;
				}
			}
			quest::settimer("Summon", quest::ChooseRandom(15, 30, 45, 60, 75, 90));
		}
		if ($summon == 0) {
			quest::settimer("Summon", 1);
		}
	}
}

sub CountSpawns {
	my @NL = $entity_list->GetNPCList();
	my $count = 0;
	foreach my $npc (@NL) {
		if ($npc->GetNPCTypeID() == 2000114) {
			$count++;
		}
	}
	return $count;
}

sub EVENT_COMBAT {
	my %spawns = (
	0 => [-175, -150, -26, 96],
	1 => [-175, -125, -26, 96],
	2 => [-175, -100, -26, 96],
	3 => [-150, -150, -26, 96],
	4 => [-150, -125, -26, 96],
	5 => [-150, -100, -26, 96],
	6 => [-125, -150, -26, 96],
	7 => [-125, -125, -26, 96],
	8 => [-125, -100, -26, 96]);
	if ($combat_state == 0) {
		quest::depopall(2000114);
		foreach my $key (keys %spawns) {
			plugin::Spawn2(2000114, 1, $spawns{$key}[0], $spawns{$key}[1], $spawns{$key}[2], $spawns{$key}[3]);
		}		
	}
}