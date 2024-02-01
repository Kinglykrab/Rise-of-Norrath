sub EVENT_SPAWN {
	$npc->SetLevel(90);
	$npc->ModifyNPCStat("max_hp", 200000000);
	$npc->SetHP($npc->GetMaxHP());
	$npc->ModifyNPCStat($_, 10000) for ("agi", "cha", "dex", "_int", "sta", "str", "wis");
	$npc->ModifyNPCStat($_, 50) for ("cr", "dr", "fr", "mr", "pr", "phr");
	$npc->ModifyNPCStat("min_hit", 17500);
	$npc->ModifyNPCStat("max_hit", 22500);
	$npc->ModifyNPCStat("avoidance", 65);
	$npc->ModifyNPCStat($_, 1000000) for ("ac", "atk", "accuracy");
	$npc->ModifyNPCStat("attack_delay", 22);
	$npc->ModifyNPCStat("special_abilities", "3,1^4,1^5,1^6,1^7,1^21,1");
	quest::setnexthpevent(90);
	$npc->ModifyNPCStat("spellscale", 16000);
}

sub EVENT_HP {
    if ($hpevent ~~ [10, 20, 30, 40, 50, 60, 70, 80, 90]) {
        my $next_event = ($hpevent - 10);
        quest::setnexthpevent($next_event);
        quest::UpdateZoneHeader("fog_minclip", 10);
        quest::UpdateZoneHeader("fog_maxclip", 50);
        quest::UpdateZoneHeader("fog_density", 1);
        quest::UpdateZoneHeader("fog_" . $_, 1) for ("red", "green", "blue");
        quest::settimer("Clear", 10);
    }
}

sub EVENT_TIMER {
    if ($timer eq "Clear") {
        quest::stoptimer("Clear");
        quest::UpdateZoneHeader("fog_minclip", 10);
        quest::UpdateZoneHeader("fog_maxclip", 500);
        quest::UpdateZoneHeader("fog_density", 0);
        quest::UpdateZoneHeader("fog_" . $_, 255) for ("red", "green", "blue");
    }
}