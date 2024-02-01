sub EVENT_SAY {
	if ($text=~/Hail/i) {
		plugin::Whisper("Hello $name, would you like to " . quest::saylink("view", 1, "view the rules") . " or " . quest::saylink("set", 1, "modify the rules") . "?");
	} elsif ($text=~/View/i) {
		if (length(substr($text, 5)) > 0) {
			my $rule_name = substr($text, 5);
			quest::shout("$rule_name: " . quest::get_rule($rule_name));
		} else {
			plugin::Whisper("Please say your command in the following format: \"view [rule_name]\"");
		}
	} elsif ($text=~/Set/i) {
		if (length(substr($text, 4)) > 0) {
			my $data = substr($text, 4);
			my @player_command = split(/ /, $data);
			my $rule_name = $player_command[0];
			my $rule_value = $player_command[1];
			quest::set_rule($rule_name, $rule_value);
			plugin::Whisper("Set Rule '$rule_name' to value '$rule_value', checking get_rule value now.");
			plugin::Whisper("$rule_name: " . quest::get_rule($rule_name));
		} else {
			plugin::Whisper("Please say your command in the following format: \"set [rule_name] [rule_value]\"");
		}
	}
}