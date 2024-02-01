sub RandomTextArray {
	my $aug_link = quest::varlink(51716);
	my $reborn_link = quest::varlink(187000);
	my $pass_link = quest::varlink(187002);
	my @random_text_array = (
		"Need to urgently contact staff? Type \@Splose in ooc or message me directly on Discord @ Splose#5349",
		"As of 8/19/2020 there was a TOTAL rework of the Custom Stat scaling. We are still in the process of retuning the numbers.",
		"Melee players.. make sure you pick up a $aug_link from Merchant Zamthos to drastically increase your survivability!",
		"Your stats (STR/DEX/INT/WIS/CHA) increase your Melee Damage, Skill Damage, Spell Damage, Healing, and Pet Scaling respectively.",
		"Donations are now open! Visit the Discord for more information.",
		"Please join our Discord to join the community! You can submit bug reports and will find the latest news & file updates @ https://discord.gg/XGdBJG8",
		"There was a HUGE spell update on 8/7/2020. We may have overlooked a few spells.. If so please post in the bug channel to get it fixed. We will be monitoring this closely.",
		"The $pass_link is now live! Hand these to Lord Potato to reset your instance lockout! You may buy these from the Potato Farmer in the hub for 50 $reborn_link."
	);
	return @random_text_array;
}

sub EVENT_SPAWN {
	if ($instanceversion < 1) {
		quest::settimer("announce", 10);
	}
}

sub EVENT_SAY {
	my @random_text_array = RandomTextArray();
	my $text = quest::ChooseRandom(@random_text_array);
	if($status > 100) {
		quest::worldwidemessage(14, "[ANNOUNCEMENT] ~ $text");
	} else {
		plugin::Whisper($text);
	}
}

sub EVENT_TIMER {
	if($timer eq "announce") {
		quest::stoptimer("announce");
		my @random_text_array = RandomTextArray();
		my $text = quest::ChooseRandom(@random_text_array);
		quest::worldwidemessage(14, "[ANNOUNCEMENT] ~ $text");
		quest::settimer("announce",600);
	}
}

