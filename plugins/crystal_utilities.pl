sub GetCrystalType {
	use Scalar::Util qw(looks_like_number);
	my $client = plugin::val('client');
	my $send_crystals = 0;
	if (defined $_[0]) {
		$send_crystals = $_[0];
	}
	my %crystal_type_hash = (
		40902 => [
			"Warrior", "Paladin", "Ranger", "Shadowknight",
			"Monk", "Bard", "Rogue", "Beastlord", "Berserker"
		],
		40903 => [
			"Cleric", "Druid", "Shaman", "Necromancer",
			"Wizard", "Magician", "Enchanter"
		],
	);
	my $class = plugin::val('class');
	foreach my $crystal_type (keys %crystal_type_hash) {
		if ($class ~~ @{$crystal_type_hash{$crystal_type}}) {
			if (looks_like_number($send_crystals)) {
				if ($send_crystals == 1) {
					return ($crystal_type == 40902 ? $client->GetEbonCrystals() : $client->GetRadiantCrystals());
				} elsif ($send_crystals == 2) {
					return ($crystal_type == 40902 ? "Ebon" : "Radiant");
				} elsif ($send_crystals == 3) {
					return ($crystal_type == 40902 ? "Radiant" : "Ebon");
				} elsif ($send_crystals == 40902) {
					return $client->GetEbonCrystals();
				} elsif ($send_crystals == 40903) {
					return $client->GetRadiantCrystals();
				}
			} else {
				if ($send_crystals eq "Ebon") {
					return $client->GetEbonCrystals();
				} elsif ($send_crystals eq "Radiant") {
					return $client->GetRadiantCrystals();
				} else {
					return $crystal_type;
				}
			}
		}
	}
}