sub EVENT_SIGNAL {
    if ($signal ~~ [2..5]) {
        $npc->SetEntityVariable("Signal_$signal", 1);
    }
    
    if ($signal == 1) {
        quest::settimer("Shake1" , 5);
    } elsif ($signal == 2) {
        quest::depopall(2000278);
    } elsif ($signal == 3) {
        quest::depopall(2000279);
    } elsif ($signal == 4) {
        quest::depopall(2000280);
    } elsif ($signal == 5) {
        quest::depopall(2000281);
    }
    
    if (CheckForVariables(2..5)) {
        quest::settimer("Timer_1", 1);
    }    
}

sub EVENT_TIMER {
	if ($timer eq "Shake1") {
		quest::stoptimer("Shake1");
		quest::depopall(2000265);
		plugin::ZoneAnnounce("You feel the tower shift slightly.");
		my @client_list = $entity_list->GetClientList();
		foreach my $client_entity (@client_list) {
			$client_entity->CameraEffect(2000, 3, 1, 0);
		}
		quest::settimer("Shake2", 5);
	}
	elsif ($timer eq "Shake2") {
		quest::stoptimer("Shake2");
		plugin::ZoneAnnounce("You can't help but feel hopeless as the tower shakes slightly.");
		my @client_list = $entity_list->GetClientList();
		foreach my $client_entity (@client_list) {
			$client_entity->CameraEffect(2000, 5, 1, 0);
		}
		quest::settimer("Shake3", 5);
	}
	elsif ($timer eq "Shake3") {
		quest::stoptimer("Shake3");
		plugin::ZoneAnnounce("Ayonae Ro shouts, 'They are here champion my fate is in your hands...'");
		my @client_list = $entity_list->GetClientList();
		foreach my $client_entity (@client_list) {
			$client_entity->CameraEffect(2000, 7, 1, 0);
		}
		quest::settimer("Portals", 1);
	}
	elsif ($timer eq "Portals") {
		quest::stoptimer("Portals");
		plugin::ZoneAnnounce("Portals appear in each corridor of the tower and agents of corruption begin to pour from them.");
		my %portal_spawns = (0 => [128.68, -0.18, 4.44, 384.0],
		1 => [0.60, 127.53, 4.44, 257.8],
		2 => [-125.95, 0.92, 4.44, 126.3],
		3 => [0.06, -126.24, 4.44, 0.0]);
			foreach my $portal (sort {$a <=> $b} keys %portal_spawns) {
			plugin::Spawn2(2000277, 1, @{$portal_spawns{$portal}});
		}
		quest::settimer("Invaders", 1);
	}
	elsif ($timer eq "Invaders") {
		quest::stoptimer("Invaders");
		plugin::ZoneAnnounce("Helion the Corrupter whispers in your mind, 'The bell will fall, my minions will see to your destruction...'");
		plugin::Spawn2(2000278, 1, 0.06, -126.24, 4.44, 0.0);
		plugin::Spawn2(2000279, 1, 128.68, -0.18, 4.44, 384.0);
		plugin::Spawn2(2000280, 1, 0.60, 127.53, 18.81, 257.8);
		plugin::Spawn2(2000281, 1, -125.95, 0.92, 4.44, 126.3);
	}
	elsif ($timer eq "Timer_1") {
        quest::stoptimer("Timer_1");
        plugin::Spawn2(2000282, 1, 0.60, 127.53, 18.81, 257.8);
        plugin::ZoneAnnounce("The_Keeper of the Bell shouts, 'No the bell must not fall! I am here to help champion!'");
        plugin::ZoneAnnounce("Helion the Corrupter whispers within your mind, 'Such a fool... Soon he will belong to me and there will be nothing you can do to stop me. You should leave this place now, it is the only way you will survive...'");
        quest::settimer("Timer_2", 2);
	}
	 elsif ($timer eq "Timer_2") {
        quest::stoptimer("Timer_2");
        plugin::ZoneAnnounce("Keeper of the Bell begins to writhe in agony, and then, abruptly stops and stands up as his eyes glaze over.");
        plugin::ZoneAnnounce("Keeper of the Bell pulls an ornate intrument from his pocket and blows into it sharply.");
        quest::settimer("Timer_3", 2);
	}
	 elsif ($timer eq "Timer_3") {
        quest::stoptimer("Timer_3");
        plugin::ZoneAnnounce("Ayonae Ro's bell begins to crack as the sharp note ends. You can hear Ayonae Ro's screams echo through the halls as the bell crumbles to pieces.");
        plugin::ZoneAnnounce("Helion the Corrupter whispers within your mind, 'My corruption is complete. Everything in this place is mine, as is Ayonae Ro.'");
        plugin::ZoneAnnounce("The Keeper of the Bell glowers at you with glossy eyes.");
    } 
}	


sub CheckForVariables {
    my @variables = @_;
    my $required = ($#variables - 1);
    my $count = 0;
    foreach my $variable (@variables) {
        if ($npc->EntityVariableExists("Signal_$variable") && $npc->GetEntityVariable("Signal_$variable") != 0) {
            $count++;
        }
    }
    
    if ($count == $required) {
        $npc->SetEntityVariable($_, 0) for ("Signal_2", "Signal_3", "Signal_4", "Signal_5");
        return 1;
    }
}