sub EVENT_SPELL_EFFECT_BUFF_TIC_CLIENT {
	#if(!$zonesn ~~ ["tutorial","freeporttemple"]) {
		plugin::PlayerPercentHP($client,3);
	#} 
}