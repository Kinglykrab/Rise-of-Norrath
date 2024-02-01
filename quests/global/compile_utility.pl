foreach my $script (glob('*.pl')) {
   system ("perl -cw $script>$script.log 2 > &1"); 
}