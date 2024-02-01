sub PrestigeItemsHash {
	my %prestige_items_hash = (
		1 => [[182462..182503, 185101, 185201, 185211, 185221, 185231, 185241, 185251, 185261, 185271, 185281, 185291,
		185301, 185311, 185321, 185331, 185341, 185351, 185361, 185371, 185381, 185391, 185401, 185411, 185421, 185431, 185441, 185451], 100],
		2 => [[182504..182545, 185102, 185202, 185212, 185222, 185232, 185242, 185252, 185262, 185272, 185282, 185292,
		185302, 185312, 185322, 185332, 185342, 185352, 185362, 185372, 185382, 185392, 185402, 185412, 185422, 185432, 185442, 185452], 101],
		3 => [[182546..182587, 185103, 185203, 185213, 185223, 185233, 185243, 185253, 185263, 185273, 185283, 185293,
		185303, 185313, 185323, 185333, 185343, 185353, 185363, 185373, 185383, 185393, 185403, 185413, 185423, 185433, 185443, 185453], 102],
		4 => [[182588..182629, 185104, 185204, 185214, 185224, 185234, 185244, 185254, 185264, 185274, 185284, 185294,
		185304, 185314, 185324, 185334, 185344, 185354, 185364, 185374, 185384, 185394, 185404, 185414, 185424, 185434, 185444, 185454], 103],
		5 => [[182630..182671, 185105, 185205, 185215, 185225, 185235, 185245, 185255, 185265, 185275, 185285, 185295,
		185305, 185315, 185325, 185335, 185345, 185355, 185365, 185375, 185385, 185395, 185405, 185415, 185425, 185435, 185445, 185455], 104],
		6 => [[182672..182713, 185106, 185206, 185216, 185226, 185236, 185246, 185256, 185266, 185276, 185286, 185296,
		185306, 185316, 185326, 185336, 185346, 185356, 185366, 185376, 185386, 185396, 185406, 185416, 185426, 185436, 185446, 185456], 105],
		7 => [[182714..182755, 185107, 185207, 185217, 185227, 185237, 185247, 185257, 185267, 185277, 185287, 185297,
		185307, 185317, 185327, 185337, 185347, 185357, 185367, 185377, 185387, 185397, 185407, 185417, 185427, 185437, 185447, 185457], 106],
		8 => [[182756..182797, 185108, 185208, 185218, 185228, 185238, 185248, 185258, 185268, 185278, 185288, 185298,
		185308, 185318, 185328, 185338, 185348, 185358, 185368, 185378, 185388, 185398, 185408, 185418, 185428, 185438, 185448, 185458], 107],
		9 => [[182798..182839, 185109, 185209, 185219, 185229, 185239, 185249, 185259, 185269, 185279, 185289, 185299,
		185309, 185319, 185329, 185339, 185349, 185359, 185369, 185379, 185389, 185399, 185409, 185419, 185429, 185439, 185449, 185459], 108]
	);
	return %prestige_items_hash;
}

sub ListPrestigeItems {
	my $rank = shift;
	my %prestige_items_hash = plugin::PrestigeItemsHash();
	my $index = 1;
	my @prestige_items = @{$prestige_items_hash{$rank}[0]};
	plugin::Message("= | Prestige Item +$rank Recipes");
	foreach my $prestige_item (@prestige_items) {
		plugin::Message("$index. " . quest::varlink($prestige_item) . " - " . quest::saylink("recipe $prestige_item", 1, "View Recipe"));
		$index++;
	}
}

sub ListPrestigeRecipe {
	my $recipe = shift;
	my %prestige_items_hash = plugin::PrestigeItemsHash();
	foreach my $rank (sort {$a <=> $b} keys %prestige_items_hash) {
		my @prestige_items = @{$prestige_items_hash{$rank}[0]};
		if ($recipe ~~ @prestige_items) {
			my $previous_item = ($recipe < 185101 ? ($recipe - 42) : ($recipe - 1));
			my $prestige_item_id = $prestige_items_hash{$rank}[1];
			plugin::Message("= | " . quest::varlink($recipe) . " Requirements");
			plugin::Message("== | " . quest::varlink($previous_item) . " and " . quest::varlink($prestige_item_id) . ".");
			plugin::Message("=== | " . quest::saylink("upgrade $recipe", 1, "Craft"));
		}
	}
}

sub PrestigeZone {
	my $zonesn = plugin::val('zonesn');
	my $type = shift;
	my %zones_hash = (
		0 => ["soldungb", "permafrost", "skyfire", "emeraldjungle"],
		1 => ["dreadspire"],
		2 => ["arcstone"],
		3 => ["theatera"]
	);
	my $prestige = 0;
	foreach my $prestige (sort {$a <=> $b} %zones_hash) {
		if ($zonesn ~~ @{$zones_hash{$prestige}}) {
			$prestige = (($type == 0) ? 1 : $prestige);
		}
	}
	return $prestige;
}

sub UpgradePrestigeItem {
	my $prestige_item = shift;
	my %prestige_items_hash = plugin::PrestigeItemsHash();
	my $client = plugin::val('client');
	foreach my $rank (sort {$a <=> $b} keys %prestige_items_hash) {
		my @prestige_items = @{$prestige_items_hash{$rank}[0]};
		if ($prestige_item ~~ @prestige_items) {			
			my $previous_item = ($prestige_item < 185101 ? ($prestige_item - 42) : ($prestige_item - 1));
			my $prestige_item_id = $prestige_items_hash{$rank}[1];
			my $previous_check = quest::countitem($previous_item);
			my $token_check = quest::countitem($prestige_item_id);
			if ($previous_check >= 1 && $token_check >= 1) {
				$previous_check--;
				$token_check--;
				quest::summonitem($prestige_item, 1);
				plugin::Whisper("You have successfully crafted your " . quest::varlink($prestige_item) . "!");
				plugin::GearAnnounce($prestige_item);
				quest::collectitems($_, 1) for ($previous_item, $prestige_item_id);
				if ($previous_check > 0) {
					quest::summonitem($previous_item, $previous_check);
				}
				
				if ($token_check > 0) {
					quest::summonitem($prestige_item_id, $token_check);
				}
				return 1;
			}
		}
	}
	plugin::Whisper("You do not have the necessary crafting components!");
	return 0;
}