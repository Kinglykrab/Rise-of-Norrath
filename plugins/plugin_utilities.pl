sub var {
	$varName = shift;  
	$varName =~ s/^(\$|@|%)//g;
	if ($varName eq 'mob') {
		$entity_list = plugin::val('entity_list');  
		return $entity_list->GetMobID(plugin::val('mobid'));
	} else {
		my(@context, $level, $fullname);
		# Step back through the call stack until we get access to the main (non-plugin) variables
		for ($level = 1; $level < 10; $level++) {
			@context = caller($level);
			last if (($fullname = substr($context[3], 0, index($context[3], ':') + 2)) ne 'plugin::');
		}
    
		return '' if ($level >= 10);
		$fullname .= $varName;
		if ($varName eq 'itemcount' || $varName eq 'qglobals') {
			return \%$fullname;
		} elsif (0) {
			return \@$fullname;
		} else {
			return \$$fullname;
		}
  }
}

sub val {
  return ${plugin::var($_[0])};
}