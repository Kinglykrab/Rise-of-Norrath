sub EVENT_SPAWN {
	plugin::Proximity(10); 
}

sub EVENT_ENTER {
	plugin::Popup("a mysterious voice says,", plugin::PWColor("This door will take you into the depths of Deathknell.<br><br>
				Would you like to descend it?<br><br>
				Or have you had enough?", "Orange"), 2, 45, 999, "Unlock", "Stay");	
}
