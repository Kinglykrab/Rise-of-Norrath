sub EVENT_SPAWN {
	$npc->SetLevel(85);
	$npc->ModifyNPCStat("max_hp", 500000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 25000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 5000);
	$npc->ModifyNPCStat("max_hit", 7500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1500000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 10);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	quest::setnexthpevent(75);
	$npc->AddToHateList($entity_list->GetNPCByNPCTypeID(2000184), 1000000);
	plugin::Emote("It has been far too long Mayong, but my power is still far greater than yours. Face me and die!");
}

sub EVENT_SIGNAL {
	if ($signal == 1) {
		plugin::Emote("Your foolishness has opened the door for corruption to enter this world. Your death is deserving of such betrayal...");
		plugin::Emote("I must go Champions world is in danger. Meet me in Arcstone should you wish to continue fighting the corruption."
		quest::depop(2000267);
	}
}