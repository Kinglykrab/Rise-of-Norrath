sub EVENT_SPAWN {
	$npc->SetLevel(70);
	$npc->ModifyNPCStat("max_hp", 2500000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat("ac", 1000000);
	$npc->ModifyNPCStat("special_abilities", "24,1");
}