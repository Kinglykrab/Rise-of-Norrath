sub EVENT_SPELL_EFFECT_CLIENT {
	plugin::Data($client, 2, "Loot-Clicky", 2, "M30");
	plugin::ClientMessage($client, "Enabling Double Loot for 30 minutes.");
}