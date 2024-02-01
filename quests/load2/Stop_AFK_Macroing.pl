sub EVENT_SPAWN {
	quest::settimerMS("memes",1);
}

sub EVENT_TIMER {
	if($timer eq "memes") {
		quest::stoptimer("memes");
		$npc->ModifyNPCStat("max_hp", "900000000");
		$npc->ModifyNPCStat("min_hit", "100000");
		$npc->ModifyNPCStat("max_hit", "500000");
		$npc->ModifyNPCStat("hp_regen", $npc->GetMaxHP()-1);
		#$npc->ModifyNPCStat("special_abilities", "14,1^17,1^18,1^21,1^24,1^31,1");
		$npc->ModifyNPCStat("attack_delay", 5);
		$npc->SetHP($npc->GetMaxHP());
	}
}