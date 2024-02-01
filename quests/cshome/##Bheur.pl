sub EVENT_SPAWN {
	quest::setnexthpevent(50);
}

sub EVENT_HP {
	if($hpevent == 50) {
		quest::shout("Prepare yourselves to weather my storm!");
		quest::settimer("stun",5);
	}
}

sub EVENT_TIMER {
	if($timer eq "stun") {
		#stun everyone for 8s
		quest::stoptimer("stun");
		quest::settimer("debuff",10);
	}
	elsif($timer eq "debuff") {
		quest::stoptimer("debuff");
		#Once the players are out of stun Bheur will begin to apply a stacking debuff which slows attack speed and movement speed 
	}
}

sub EVENT_COMBAT {
	if($combat_state == 0) {
		##RESET
	} else {
		quest::shout("Your souls will rest here forever!");
	}
}