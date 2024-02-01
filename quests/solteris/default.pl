sub EVENT_SPAWN {
	my $nn = $npc->GetCleanName();
	if($nn=~/mephit|spark/i) {
		$npc->SpellFinished(42482,$npc,-1);
		quest::settimer("SmallRoam", 5+int(rand(30)));
	}
}

sub EVENT_TIMER {
	if ($timer eq "SmallRoam") {
		quest::stoptimer("SmallRoam");
		plugin::RandomRoam(25, 25);
		quest::settimer("SmallRoam", 5+int(rand(30)));
	}
	if ($timer eq "MediumRoam") {
		quest::stoptimer("MediumRoam");
		plugin::RandomRoam(75, 75);
		quest::settimer("MediumRoam", 5+int(rand(30)));
	}
}
