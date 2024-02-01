sub EVENT_SPAWN {
	quest::settimerMS("invul",1);
}

sub EVENT_TIMER {
	if($timer eq "invul") {
		quest::stoptimer("invul");
		$npc->ModifyNPCStat("max_hp", "90000000");
		$npc->ModifyNPCStat("hp_regen", $npc->GetMaxHP()-1);
		$npc->ModifyNPCStat("special_abilities", "14,1^17,1^18,1^21,1^24,1^31,1");
		$npc->ModifyNPCStat("attack_delay", 0);
		$npc->SetHP($npc->GetMaxHP());
	}
}