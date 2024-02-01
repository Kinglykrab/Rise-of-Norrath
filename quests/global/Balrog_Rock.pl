$chance = 0;

sub EVENT_SPAWN {
	$chance = quest::ChooseRandom(5..25);
	$npc->ChangeSize($chance, 1);
	quest::settimer("Proximity", 1);
}

sub EVENT_TIMER {
	if ($timer eq "Proximity") {
		quest::stoptimer("Proximity");
		my @client_list = $entity_list->GetClientList();
		my $range = 25;
		foreach my $rock_ent (@client_list) {
			if ($npc->CalculateDistance($rock_ent->GetX(), $rock_ent->GetY(), $rock_ent->GetZ()) <= $range) { #Within melee range
				my $aoe_hp = 5000;
				my $aoe_hp_final = ($aoe_hp * $chance);
				$rock_ent->SetHP($rock_ent->GetHP() - $aoe_hp_final);
				if ($rock_ent->IsClient()) {
					plugin::ClientMessage($rock_ent, "A piece of the tower hits YOU for " . plugin::commify($aoe_hp_final) . " health!");
				}
			}
		}
		quest::settimer("Depop", 1);
	} elsif ($timer eq "Depop") {
		quest::stoptimer("Depop");
		$npc->Kill();
	}
}
