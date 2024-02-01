sub LoadMysql {
	use DBI;
	use DBD::mysql;
	use JSON;
	my $json = new JSON();
	my $content;
	open(my $fh, '<', "eqemu_config.json") or die "Cannot open eqemu_config.json"; {
		local $/;
		$content = <$fh>;
	}
	close($fh);
	my $config = $json->decode($content);
	my $db = $config->{"server"}{"database"}{"db"};
	my $host = $config->{"server"}{"database"}{"host"};
	my $user = $config->{"server"}{"database"}{"username"};
	my $pass = $config->{"server"}{"database"}{"password"};
	my $dsn = "dbi:mysql:$db:$host:3306";
	my $connect = DBI->connect($dsn, $user, $pass);	
	return $connect;
}