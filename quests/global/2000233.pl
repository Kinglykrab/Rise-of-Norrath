sub EVENT_SAY {
	if (($ulevel == 70 && plugin::Data($client, 3, "Prestige") >= 2) || $status >= 80) {
		if ($text=~/Hail/i) {
			plugin::Whisper("Hail $name, I am thankful you came. You must stop the corruption before it reaches Deathknell and all is lost.
			Will you " . quest::saylink("do", 1) . " this for me hero?");
		} elsif ($text=~/Do/i) {
			quest::taskselector(203);
		}
	} elsif ($ulevel < 70) {
		plugin::Whisper("I only speak to the most elite of soldiers.");
	} elsif (plugin::Data($client, 3, "Prestige") < 2) {
		plugin::Whisper("If you would like to become my champion you must prove yourself in Dreadspire first.");
	}
}