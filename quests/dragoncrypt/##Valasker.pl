sub EVENT_COMBAT {
	if($combat_state == 1) {
		quest::worldwidemessage(15, "The skies churn with inky clouds of darkness. You get the feeling an intense battle is occuring somewhere in Norrath.");
		quest::shout("Yes... Come forward, " . $client->GetCleanName() . ".. Let me consume your power.");
		quest::settimer("Assign",5);
		quest::signalwith(2000311,2,10000);
	}
	if($combat_state == 0) {
		quest::signalwith(2000311,3,10);
		quest::depopall(2000309);
	}
}

sub EVENT_SIGNAL {
	#quest::shout("GOT SIGNAL");
	if($signal == 15) {
		$npc->SpellFinished($_,$npc,-1) for (42419,42420,42421);
		quest::shout("You fools! The elements will tear you apart!");
	}
	else {
		my %spells = (
			10		=>	"42419",
			11		=>	"42420",
			12		=>	"42421",
		);
		$npc->SpellFinished($spells{$signal},$npc,-1);	
	}
}


sub EVENT_TIMER {
	if($timer eq "CheckScaling") {
		quest::stoptimer("CheckScaling");
		#quest::shout("timer fired");
		Scale($npc);
	}
	elsif($timer eq "Assign") {
	my @HL = $npc->GetHateList();
	foreach my $player (@HL) {
		my $client = $player->GetEnt();
		my $cn = $client->GetCleanName();
		my $c_name = $entity_list->GetClientByName($cn);
		if($c_name->IsClient()) {$c_name->SetEntityVariable("Element","null"); }
			
			#quest::shout("Assign " . $c_name->GetEntityVariable("Element") . "");

			if($c_name->GetEntityVariable("Element") eq "null") {
				my $randelement = quest::ChooseRandom(1..3);
				$npc->SignalClient($c_name,$randelement);
			}
	}
		quest::stoptimer("Assign");
		#quest::settimer("Assign",10+int(rand(20)));
		quest::settimer("Assign",18+int(rand(20)));
	}
	elsif($timer eq "Depop") {
		quest::stoptimer("Depop");
		quest::depopall(2000309);
	}
}

sub EVENT_SPAWN {

	quest::settimerMS("CheckScaling",5);
	quest::settimer("Depop",600);
	quest::setnexthpevent(8);
}

sub EVENT_DEATH_COMPLETE {
	my $rank = 2000312+$npc->GetEntityVariable("Rank");
	
	if($rank >= 2000318) { $rank = 2000318; }

	plugin::Spawn2($rank,1,$x,$y,$z,$h);

}

sub Scale {
	my $npc = $_[0];
	my @CL = $entity_list->GetClientList();
	my $hp_mult = scalar(@CL);
	my $dmg_mult = ($hp_mult/10)+1.3;
	my $base = $npc->GetMaxHP();

	

	if($hp_mult < 1) { $hp_mult = 1; }
	if($dmg_mult < 1.3) { $dmg_mult = 1.3; }
	if($hp_mult > 10) { $hp_mult = 10; }
	
	%mult_to_word = (
	1	=>	"One",
	2	=>	"Two",
	3	=>	"Three",
	4	=> 	"Four",
	5	=>	"Five",
	6	=>	"Six",
	7	=>	"Seven",
	8	=>	"Eight",
	9	=>	"Nine",
	10	=>	"Ten"
	);
	$npc->SetEntityVariable("Rank",$hp_mult);
	$npc->TempName("" . $npc->GetCleanName() . " (" . $mult_to_word{$hp_mult} . ")");
	#quest::shout("HP/DMG Multipliers: (" . $hp_mult . "/" . $dmg_mult . ")");
	#quest::shout("HP Before/After: (" . $npc->GetMaxHP() . "/" . int($npc->GetMaxHP*$hp_mult) . ")");
	#quest::shout("MinDamage Before/After: (" . $npc->GetMinDMG . "/" . int($npc->GetMinDMG()*$dmg_mult) . ")");
	#quest::shout("MaxDamage Before/After: (" . $npc->GetMaxDMG . "/" . int($npc->GetMaxDMG()*$dmg_mult) . ")");
	
	if($hp_mult > 1) {
		$npc->ModifyNPCStat("max_hp",$base*$hp_mult);
		$npc->SetHP($npc->GetMaxHP());
	}
	if($dmg_mult >= 1) {
		$npc->ModifyNPCStat("min_hit", int($npc->GetMinDMG()*$dmg_mult));
		$npc->ModifyNPCStat("max_hit", int($npc->GetMaxDMG()*$dmg_mult));
	}
	
	
}