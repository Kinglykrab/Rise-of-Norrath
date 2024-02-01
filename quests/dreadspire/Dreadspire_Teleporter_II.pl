sub EVENT_SPAWN {
	plugin::Proximity(10); 
}

sub EVENT_ENTER {
	if ($instanceid == 0) {
		quest::movepc(351, 0.38, 2474.16, 102.13, 509.5);
	} else {
		quest::MovePCInstance(351, $instanceid, 0.38, 2474.16, 102.13, 509.5);
	}
}