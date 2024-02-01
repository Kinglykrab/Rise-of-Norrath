sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 625000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 70000);
	$npc->ModifyNPCStat("max_hit", 80000);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1^35,1");
	quest::settimer("Spawn", 30);
}


sub EVENT_TIMER {
	if ($timer eq "Spawn") {
		quest::stoptimer("Spawn");
		plugin::Spawn2(2000243, 2, 182.57, -456.92, 407.20, 268.8);
		quest::settimer("Spawn", 30);
	}
}