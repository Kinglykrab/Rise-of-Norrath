sub EVENT_SAY {
	if ($text=~/Hail/i) {
		my $buff_cost = plugin::BuffCost();
		my $buff_cost_message = ($buff_cost > 0 ? " " . plugin::commify($buff_cost) . " Platinum" : " free");
		my $buff_link = quest::saylink("buffs", 1);
		plugin::Whisper("Hail, $name. I can provide you with $buff_link for $buff_cost_message.");
	} elsif ($text=~/Buffs/i) {
		plugin::HandleBuffs("NPC", $client);
	}
}