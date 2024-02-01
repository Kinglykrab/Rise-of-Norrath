# plugin::AddStats(type); - adds current player's stats to the leaderboard
# Type: 0 => NPC, 1 => Logged In or Zoned
sub AddStats {
	my $stat_type = shift;
	my $database_handler = plugin::LoadMysql();
	my $client = plugin::val('client');
	my $name = $client->GetCleanName();
	my $race = quest::getracename($client->GetRace());
	my $class = quest::getclassname($client->GetClass());
	my $level = $client->GetLevel();
	my $health = $client->GetMaxHP();
	my $mana = $client->GetMaxMana();
	my $armor_class = $client->GetDisplayAC();
	my $platinum = ($client->GetMoney(3, 0) + $client->GetMoney(3, 1) + $client->GetMoney(3, 2) + $client->GetMoney(3, 3));
	my $aa_points = ($client->GetAAPoints() + $client->GetSpentAA());
	my @privacy_settings = ("Public", "Private");
	my $private = (plugin::Data($client, 3, "Privacy") ? 1 : 0);
	my $privacy_setting = $privacy_settings[$private];
	my $stats_message =
	"<table>
		<tr>
			<td>" . plugin::PWColor("Name", "Red1") . "</td>
			<td>" . plugin::PWColor("Race", "Orange") . "</td>
			<td>" . plugin::PWColor("Class", "Yellow") . "</td>
			<td>" . plugin::PWColor("Level", "Green") . "</td>
			<td>" . plugin::PWColor("Health", "Royal Blue") . "</td>
			<td>" . plugin::PWColor("Mana", "Royal Blue") . "</td>
			<td>" . plugin::PWColor("Armor Class", "Purple") . "</td>
			<td>" . plugin::PWColor("AA Points", "Purple") . "</td>
			<td>" . plugin::PWColor("Platinum", "Purple") . "</td>
			<td>" . plugin::PWColor("Private", "Purple") . "</td>
		</tr>
		<tr>
			<td>" . plugin::PWColor($name, "Red1") . "</td>
			<td>" . plugin::PWColor($race, "Orange") . "</td>
			<td>" . plugin::PWColor($class, "Yellow") . "</td>
			<td>" . plugin::PWColor($level, "Green") . "</td>
			<td>" . plugin::PWColor(plugin::commify($health), "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($mana), "Royal Blue") . "</td>
			<td>" . plugin::PWColor(plugin::commify($armor_class), "Purple") . "</td>
			<td>" . plugin::PWColor(plugin::commify($aa_points), "Purple") . "</td>
			<td>" . plugin::PWColor(plugin::commify($platinum), "Purple") . "</td>
			<td>" . plugin::PWColor($privacy_setting, "Purple") . "</td>
		</tr>
	</table>";
	$database_handler->do("DELETE FROM `leaderboard` WHERE `name` = '$name'");
	$database_handler->do("INSERT INTO `leaderboard` (`name`, `race`, `class`, `level`, `health`, `mana`, `armor_class`, `aa_points`, `platinum`, `private`) VALUES ('$name', '$race', '$class', '$level', '$health', '$mana', '$armor_class', '$aa_points', '$platinum', '$private')");
	$stats_message .=
	"";
	$stats_message .= "";
	if ($stat_type == 0) {
		plugin::Whisper("Your stats have been added to the leaderboard.");
		quest::popup("Leaderboard Stats", "$stats_message");
	}

	$database_handler->disconnect();
}

# plugin::DeleteStats(); - deletes current player's stats from the leaderboard
sub DeleteStats {
	my $database_handler = plugin::LoadMysql();
	my $name = plugin::val('name');
	$database_handler->do("DELETE FROM `leaderboard` WHERE `name` = '$name'");
	plugin::Whisper("Your stats have been deleted from the leaderboard.");
	$database_handler->disconnect();
}

# plugin::ViewStats(type, row_modifier);
# Type: 0 => Health, 1 => Mana, 2 => Platinum, 3 => AA Points, 4 => Armor Class
# Row Modifier: Rows = Row Modifier + 1 to Row Modifier + 10
sub ViewStats {
	my %stat_types_data = plugin::StatTypesData();
	my $database_handler = plugin::LoadMysql();
	my ($stat_type, $row_modifier) = (shift, shift);
	my ($sort_type, $sort_name) = @{$stat_types_data{$stat_type}};
	my $start_row = $row_modifier;
	my $rank = ($start_row ? ($start_row + 1) : 1);
	my $min_rank = $rank;
	my $max_rank = ($min_rank + 9);
	my $stats_message =
	"<table>
		<tr>
			<td>" . plugin::PWColor("Name", "Red1") . "</td>
			<td>" . plugin::PWColor("Race", "Orange") . "</td>
			<td>" . plugin::PWColor("Class", "Yellow") . "</td>
			<td>" . plugin::PWColor("Level", "Green") . "</td>
			<td>" . plugin::PWColor("Health", "Royal Blue") . "</td>
			<td>" . plugin::PWColor("Mana", "Royal Blue") . "</td>
			<td>" . plugin::PWColor("Armor Class", "Purple") . "</td>
			<td>" . plugin::PWColor("AA Points", "Purple") . "</td>
			<td>" . plugin::PWColor("Platinum", "Purple") . "</td>
		</tr>";
	my $query = "";
	$query = 
	"
		SELECT
		  `name`,
		  race,
		  class,
		  level,
		  health,
		  mana,
		  armor_class,
		  aa_points,
		  platinum,
		  private
		FROM leaderboard
		WHERE private = 0
		ORDER BY health DESC LIMIT $start_row, 10
	";
	my $query_handler = $database_handler->prepare($query);
	$query_handler->execute();
	if ($query_handler->rows() > 0) {
		while (my($name, $race, $class, $level, $health, $mana, $armor_class, $aa_points, $platinum, $private) = $query_handler->fetchrow_array()) {
			$stats_message .= 
			"<tr>
				<td>" . plugin::PWColor($name, "Red1") . "</td>
				<td>" . plugin::PWColor($race, "Orange") . "</td>
				<td>" . plugin::PWColor($class, "Yellow") . "</td>
				<td>" . plugin::PWColor($level, "Green") . "</td>
				<td>" . plugin::PWColor(plugin::commify($health), "Royal Blue") . "</td>
				<td>" . plugin::PWColor(plugin::commify($mana), "Royal Blue") . "</td>
				<td>" . plugin::PWColor(plugin::commify($armor_class), "Purple") . "</td>
				<td>" . plugin::PWColor(plugin::commify($aa_points), "Purple") . "</td>
				<td>" . plugin::PWColor(plugin::commify($platinum), "Purple") . "</td>
			</tr>";
		}		
		$stats_message .= "</table>";
		plugin::Popup("| Ranks $min_rank to $max_rank | $sort_name |", $stats_message, 0, 999);
		return;
	}
	plugin::Whisper("There appears to be no rows for that search criteria.");
	$query_handler->finish();
	$database_handler->disconnect();
}

# plugin::ViewStatsByClass(type, row_modifier, class_list);
# Type: 0 => Health, 1 => Mana, 2 => Platinum, 3 => AA Points, 4 => Armor Class
# Row Modifier: Rows = Modifier + 1 to Modifier + 10
# Class List: Multiple => Warrior, Cleric, Enchanter
# Class List: Single => Warrior
sub ViewStatsByClass {
	my %stat_types_data = plugin::StatTypesData();
	my $database_handler = plugin::LoadMysql();
	my ($stat_type, $row_modifier) = (shift, shift);
	my @class_list = @_;
	my ($sort_type, $sort_name) = @{$stat_types_data{$stat_type}};
	my $start_row = $row_modifier;
	my $rank = ($start_row + 1);
	my $min_rank = $rank;
	my $max_rank = ($min_rank + 9);
	my $stats_message =
	"<table>
		<tr>
			<td>" . plugin::PWColor("Name", "Red1") . "</td>
			<td>" . plugin::PWColor("Race", "Orange") . "</td>
			<td>" . plugin::PWColor("Class", "Yellow") . "</td>
			<td>" . plugin::PWColor("Level", "Green") . "</td>
			<td>" . plugin::PWColor("Health", "Royal Blue") . "</td>
			<td>" . plugin::PWColor("Mana", "Royal Blue") . "</td>
			<td>" . plugin::PWColor("Armor Class", "Purple") . "</td>
			<td>" . plugin::PWColor("AA Points", "Purple") . "</td>
			<td>" . plugin::PWColor("Platinum", "Purple") . "</td>
		</tr>";
	my %class_short_names = (
		"Warrior" => "WAR",
		"Cleric" => "CLR",
		"Shadowknight" => "SHD",
		"Ranger" => "RNG",
		"Druid" => "DRU",
		"Paladin" => "PAL",
		"Monk" => "MNK",
		"Bard" => "BRD",
		"Rogue" => "ROG",
		"Shaman" => "SHM",
		"Wizard" => "WIZ",
		"Magician" => "MAG",
		"Necromancer" => "NEC",
		"Enchanter" => "ENC",
		"Beastlord" => "BST",
		"Berserker" => "BER",
	);
	my $class_window_string = "";
	my $class_list_string = "(";
	$class_list_string .= "'$_'" . ($_ eq $class_list[$#class_list] ? "" : ", ") for @class_list;
	$class_window_string .= " $class_short_names{$_} " . ($_ eq $class_list[$#class_list] ? "" : "|") for @class_list;
	$class_list_string .= ")";
	my $query_handler = $database_handler->prepare("SELECT `name`, `race`, `class`, `level`, `health`, `mana`, `armor_class`, `aa_points`, `platinum`, `private` FROM `leaderboard` WHERE `class` IN $class_list_string AND `private` = '0' ORDER BY `$sort_type` DESC LIMIT $start_row, 10");
	$query_handler->execute();
	my $display;
	my $count = 1;
	if ($query_handler->rows() > 0) {
		while (my($name, $race, $class, $level, $health, $mana, $armor_class, $aa_points, $platinum) = $query_handler->fetchrow_array()) {
			$stats_message .= 
			"<tr>
				<td>" . plugin::PWColor($name, "Red1") . "</td>
				<td>" . plugin::PWColor($race, "Orange") . "</td>
				<td>" . plugin::PWColor($class, "Yellow") . "</td>
				<td>" . plugin::PWColor($level, "Green") . "</td>
				<td>" . plugin::PWColor(plugin::commify($health), "Royal Blue") . "</td>
				<td>" . plugin::PWColor(plugin::commify($mana), "Royal Blue") . "</td>
				<td>" . plugin::PWColor(plugin::commify($armor_class), "Purple") . "</td>
				<td>" . plugin::PWColor(plugin::commify($aa_points), "Purple") . "</td>
				<td>" . plugin::PWColor(plugin::commify($platinum), "Purple") . "</td>
			</tr>";
			$rank++;
			$display = 1;
		}
	} else {
		$display = 0;
	}
	$stats_message .= "</table>";
	my $classes = join(", ", @class_list);
	if ($display == 1) {
		quest::popup("| Ranks $min_rank to $max_rank | $sort_name | $class_window_string | ", "$stats_message");
	} else {
		plugin::Whisper("There appears to be no rows for that search criteria.");
	}
	$query_handler->finish();
	$database_handler->disconnect();
}

# plugin::SetPrivacy(setting);
# Setting: 0 => Public, 1 = Private
sub SetPrivacy {
	my $database_handler = plugin::LoadMysql();
	my $client = plugin::val('client');
	my $name = $client->GetCleanName();
	my $setting = shift;
	if ($setting ~~ [0, 1]) {
		my @setting_messages = ("Public", "Private");
		$database_handler->do("UPDATE `leaderboard` SET `private` = '$setting' WHERE `name` = '$name'");
		plugin::Data($client, 1, "Privacy", $setting);
		plugin::Whisper("Your stats are now $setting_messages[$setting].");
	} else {
		plugin::Whisper("The setting you provided was invalid.");
	}
	$database_handler->disconnect();
}

sub StatTypesData {
	my %stat_types_data = (
		0 => ["health", "Health"],
		1 => ["mana", "Mana"],
		2 => ["platinum", "Platinum"],
		3 => ["aa_points", "AA Points"],
		4 => ["armor_class", "Armor Class"],
	);
	return %stat_types_data;
}