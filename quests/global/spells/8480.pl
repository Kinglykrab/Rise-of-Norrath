sub EVENT_SPELL_EFFECT_CLIENT {

	$client->Message(15, "Tunare proc");

	plugin::HandleCast($client,8480,$client);
	
}