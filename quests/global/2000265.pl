sub EVENT_SAY {
	if ($text=~/Hail/i) {
		plugin::Whisper("We struck a blow against the forces of corruption in Arcstone thanks to you hero.
		But I fear the forces of evil will soon be at my door... 
		Will you " . quest::saylink("stand", 1) . " with me?");	
	} elsif ($text=~/Stand/i) {
		plugin::Whisper(
			"You are a true champion for being so brave in the face of corruption.
			The bell that resides within these walls is the source of all my power, should it fall, so will I.
			I must prepare the rest of my forces for the imminent battle.
			I will leave the defense of my bell in your charge, you have earned my trust hero."
		);
		quest::signalwith(2000266, 1);
	}
}