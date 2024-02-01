sub Changelog {
	my $database_handler = plugin::LoadMysql();
	my $query_handler = $database_handler->prepare("SELECT * FROM changelog ORDER BY entry_id DESC LIMIT 20");
	my %message = 
	(
		0 => plugin::PWColor("Type #commands to view our custom commands!", "Purple") .
			"<br>" .
			plugin::PWHyperLink(
				"https://discordapp.com/channels/736465097815228426/736672978154029096/737519708471033927",
				"Click here to download the most recent patch files!"
			)
	);
	my $visible_id = 1;
	$query_handler->execute();
	my %visible_dates = ();
	my $display_message = "";
	if ($query_handler->rows() > 0) {
		while (my($entry_id, $entry_data, $entry_author, $entry_date) = $query_handler->fetchrow_array()) {
			my $show_date = (
				defined $visible_dates{$entry_date} ? 
				"" : 
				(
					"<br>" .
					plugin::PWColor("[" . plugin::ProcessDate($entry_date) . "]<br>", "Yellow")
				)
			);
			$visible_dates{$entry_date} = 1;
			$message{$visible_id} .=
				$show_date . 
				plugin::PWColor("• ", "Purple") .
				plugin::PWColor("$entry_author: ", "Gray") .
				plugin::PWColor($entry_data, "Royal Blue");
			$visible_id++;
		}
	}
	
	$message{$visible_id} = 
	plugin::PWColor(
		"<br>
		Stay tuned for more changes. 
		Thank you to the players who are actively submitting bug reports and testing content!",
		"Purple"
	);
	foreach my $message_id (sort {$a <=> $b} keys %message) {
		$display_message .= "$message{$message_id}<br>";
	}
	plugin::Popup(
		"Rise of Norrath: Reborn Patch 1.0",
		$display_message,
		0, 999,
	);
}

sub ProcessDate {
	use Time::Piece;
	my $date = shift;
	return Time::Piece->strptime($date, '%Y-%m-%d')->strftime("%B %d, %Y");
}