sub EVENT_SAY {
	if($text=~/hail/i) {
		plugin::Popup("Aradune","Aradune, A.K.A Brad McQuaid passed away on November 18th, 2019. This was his in-game character. <br><br>
		Brad touched many lives through the art of Game Design. Without him and his creation, EverQuest, there would be no 'modern' MMOs of today.
		Brad was instrumental in creating the very world you are standing in right now. With great sadness we made this memorial to him. 
		<br><br>
		Finally, Aradune may put up his sword and forever rest here. <br> <br>
		 Thank you, Brad. Your legacy will forever live on at EQEmpires. <br> <br> 4/25/1969  -  11/18/2019
		",0);  #4/25/1969  -  11/18/2019~");
		quest::doanim(67);
		#quest::settimer("salute",1);
	}
}

sub EVENT_TIMER {
	if($timer eq "salute") {
		quest::emote("salutes you.");
		quest::doanim(67);
		quest::stoptimer("salute");
	}
}