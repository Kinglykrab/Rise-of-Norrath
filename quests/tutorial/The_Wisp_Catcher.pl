sub EVENT_SAY {
	if($text=~/hail/i) {
		plugin::Whisper("Greetings, $name. Right-click me to buy your Epic 1.0.");
		plugin::Whisper("You will notice that, like many things on this server, the stats may be quite different than what you are used to.. On Rise of Norrath, weapon damage is
		significantly higher, and each piece of gear will noticeably increase your character's power.");
	}
	if(quest::istaskactivityactive(1,1)) {
		plugin::Whisper("Head to the Guildhouse to speak with Grandmaster Jack. He will help you continue your journey");
	}
}