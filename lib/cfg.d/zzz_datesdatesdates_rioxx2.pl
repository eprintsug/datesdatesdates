# If the rioxx2 package is installed, configure it to look in the
# new 'dates' field to find values for dateAccepted and publication_date
for( @{$c->{fields}->{eprint}} )
{
	$_->{rioxx2_value} = "rioxx2_value_dateAccepted" if $_->{name} eq "rioxx2_dateAccepted";	
	$_->{rioxx2_value} = "rioxx2_value_publication_date" if $_->{name} eq "rioxx2_publication_date";
}

$c->{rioxx2_value_dateAccepted} = sub {
	my ( $eprint ) = @_;

	for( @{ $eprint->value( "dates" ) } )
	{
		next unless defined $_->{date_type};
		next unless $_->{date_type} eq "accepted";
		return $_->{date};
	}
	return undef;
};

$c->{rioxx2_value_publication_date} = sub {
	my( $eprint ) = @_;

	# attempt to get the 'best' date - see description:
	# http://www.rioxx.net/schema/v2.0/rioxx/rioxxterms_.html#publication_date
	my $pub_online_date;
	
	for( @{ $eprint->value( "dates" ) } )
	{
		next unless defined $_->{date_type};
		$pub_online_date = $_->{date} if ( $_->{date_type} eq "published_online" );
		
		# return published date as best match
		next unless $_->{date_type} eq "published";
		return $_->{date};
	}
	#return published_online date as second best
	return $pub_online_date if ( defined $pub_online_date );
	
	return undef;
};
