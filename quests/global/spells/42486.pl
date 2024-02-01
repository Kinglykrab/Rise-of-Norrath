sub EVENT_SPELL_EFFECT_CLIENT {
	plugin::Data($client, 2, "Loot-Clicky", 2, "H24");
	plugin::ClientMessage($client, "Enabling Double Loot for 24 hours.");
}