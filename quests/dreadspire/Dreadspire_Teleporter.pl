sub EVENT_SPAWN {
	plugin::Proximity(50); 
}

sub EVENT_ENTER {
	if ($instanceid == 0) {
		quest::movepc(351, -56.59, -0.46, -1287.01, 382.5);
	} else {
		quest::MovePCInstance(351, $instanceid, -56.59, -0.46, -1287.01, 382.5);
	}
}
