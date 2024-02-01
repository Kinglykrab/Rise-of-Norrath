sub EVENT_SAY {
	
	my %Files = (
		"Coral" => [12674..12699,12807..12832],
		"Mermaid" => [12726..12805],
		"Swashbuckler" => [67900..67919],
		"SwashbucklerRaid" => [67920..67939],
		"ArxMentis" => [12700..12778,112708],
		"Allyrian" => [101294..101339],
		"RingofScale" => [101227..101260,101360..101385],
		"RingofScaleRaid" => [101386..101411],
		"Halloween" => [101061..101068],
		"AnastiSulGood" => [101015..101025,101069,101070,101077],
		"Disease" => [101050..101060,101075,101076,101080],
		"Dwarven" => [101038..101049,101073,101074,101079],
		"Health" => [101026..101037,101071,101072,101078,101033,101071,101072,101078],
		"Nightmare" => [101186..101202],
		"NightmareBlue" => [101203..101219,101223],
		"BloodironGreen" => [101168..101185,101221],
		"BloodironRed" => [101150..101167,101220],
		"BloodironBlue" => [101270..101289],
		"BloodironBlueRaid" => [101340..101359],
		"SKU26" => [101437..101524],
		"DwarvenTwo" => [101532..101723]
		);
	
	if($npc->GetEntityVariable("CurrModel")) { $CurrModel = $npc->GetEntityVariable("CurrModel"); } else { $CurrModel = "NONE"; }
	if($text=~/hail/i) {
		plugin::Whisper("Open the following files and then click on the model number to view it.");
		foreach my $file (keys %Files) {
			plugin::Message("" . quest::saylink("showfile $file",1,"$file") . "");
		}
		plugin::Message("WARNING: This will send a lot of messages. Some models may not be weapons, there are other things included as well such as things used to decorate zones.");
		plugin::Whisper("My current secondary slot model is: $CurrModel");
	}
	if($text=~/showfile/i) {
		my @arg = split(' ', $text);
		if($arg[1]) {
			foreach my $model (@{@Files{$arg[1]}}) {
				plugin::Message("File: " . $arg[1] . " - [" . quest::saylink("showmodel $model",1,"$model") . "]");
			}
		}
	}
	if($text=~/showmodel/i) {
		my @arg = split(' ', $text);
		if($arg[1]) {
			quest::wearchange(8,$arg[1]);
			$npc->SetEntityVariable("CurrModel",$arg[1]);
			plugin::Whisper("Changing my secondary slot model to: $arg[1]");
		}
	}
}