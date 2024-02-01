sub EVENT_SPAWN {	
	for (my $i = 0; $i < quest::ChooseRandom(1..2); $i++) {
		$npc->AddItem(quest::ChooseRandom(167000..167015), 1);
	}
	quest::setnexthpevent(90);
}

sub EVENT_HP {
	if ($hpevent ~~ [10, 20, 30, 40, 50, 60, 70, 80, 90]) {
		$npc->SetHP($npc->GetHP() + ($npc->GetMaxHP() / 10));
		quest::setnexthpevent($hpevent - 10);
	}
}

sub EVENT_ITEM {
	plugin::return_items();
}