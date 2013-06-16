#!/usr/bin/perl
use v5.14;

# Get entries from a BibSonomy user via its BibTeX key

use LWP::Simple qw(get);
use Text::BibTeX::Entry;

my $user = shift @ARGV;

my $list = @ARGV ? \@ARGV : [<>];
foreach my $key (@$list) {
	$key =~ s/\n$//;

	my $entry = getbibtex($user, $key);
	next unless $entry;

# TODO: catch warnings
	my $s = $entry->print_s;
#	if ($@) {
#	  say STDERR "$key: $@";
#	}
	print $s;
}

sub getbibtex {
	my ($user, $key) = @_;
	$key =~ s/^@//;
	my $url = "http://www.bibsonomy.org/bibtexkey/$key?format=bibtex";

	my $count = 0;

	foreach ( split /^\@/m, get($url) ) {
		next unless $_;
		my $entry = eval {
		  Text::BibTeX::Entry->new('@'.$_);
		};
		if ( $entry->get('biburl') ~~ /\/$user$/ ) {
			return $entry;
		}
		$count++;
	}

	say STDERR "$key not found for user $user ($count records)";
	return;
}