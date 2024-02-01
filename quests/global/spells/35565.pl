sub EVENT_SPELL_EFFECT_NPC {
	quest::say($caster_id);
}

sub EVENT_SPELL_EFFECT_CLIENT {
	$client->Message(15, "Wtf");
}