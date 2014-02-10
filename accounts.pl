#!/usr//bin/perl
#
# Script to balance accounts between servers
#

use warnings;

START:print "\nOperations:
1. List Mail Store servers
2. List total number of accounts
3. List total numbers of account per server
4. List disk usage per server (time consuming) NOT DONE
5. Redistribute users by number of accounts per server
Select your operation: ";
$answer = <STDIN>;

if ($answer == 1) {
    print "\nChecking for Zimbra Mail Store servers\n";
    $mailStoreServers = `zmprov gas mailbox`;
    $numbersOfMailServers = $mailStoreServers =~ tr/\n//;
    print "Found $numbersOfMailServers servers:\n";
    print "$mailStoreServers";
    goto START
} elsif ($answer == 2) {
    print "\nChecking for total numbers of accounts\n";
    $numbersOfAccounts = `zmprov -l gaa|wc -l`;
    print "Total numbers of accounts: $numbersOfAccounts";
    goto START
} elsif ($answer == 3) {
    print "\nChecking for total numbers of accounts per server\n";
    $numbersOfAccounts = `zmprov -l gaa|wc -l`;
    my @lines = split /\n/, `zmprov gas mailbox`;
    foreach my $line (@lines) {
        $count = `zmprov -l gaa -s $line |wc -l`;
        $percent = ($count*100)/$numbersOfAccounts;
        $percent = sprintf("%.1f", $percent);
        $count = chomp($count);
        print "$line: $count ($percent%)\n";
    }
    goto START
} elsif ($answer == 4) {
    print "\nChecking disk usage per user, per server\n";
    $mailStoreServers = `zmprov gas mailbox`;
    my @lines = split /\n/, `zmprov gas mailbox`;
    foreach my $line (@lines) {
        $count = `zmprov -l gaa -s $line |wc -l`;
        $percent = ($count*100)/$numbersOfAccounts;
        $percent = sprintf("%.1f", $percent);
        print "$line: $count ($percent%)\n";
    }
    goto START
} elsif ($answer == 5) {
    print "\nChecking for total numbers of accounts per server\n";

    $numbersOfAccounts = `zmprov -l gaa|wc -l`;
    $mailStoreServers = `zmprov gas mailbox`;
    $numbersOfMailServers = $mailStoreServers =~ tr/\n//;
    my @lines = split /\n/, `zmprov gas mailbox`;
    foreach my $line (@lines) {
        $count = `zmprov -l gaa -s $line |wc -l`;
        $percent = ($count*100)/$numbersOfAccounts;
        $percent = sprintf("%.1f", $percent);
        $count = chomp($count);
        print "$line: $count ($percent%)\n";
        $shouldHave = $numbersOfAccounts / $numbersOfMailServers;
        print "$line should have $shouldHave numbers of account, but currently have $count."
    }
    goto START
} else {
    print "Your selection is not valid\n";
    goto START
}
