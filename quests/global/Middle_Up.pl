sub EVENT_SPAWN {
	plugin::Proximity(25); 
}

sub EVENT_ENTER {
	plugin::Popup(
		"A mysterious voice says,",
		"This door will take you to the top of Deathknell.<br><br>
		Would you like to unlock it?<br><br>
		Or will you brave the rest?", 2, 10000, 999, "Unlock", "Stay"
	);	
}
