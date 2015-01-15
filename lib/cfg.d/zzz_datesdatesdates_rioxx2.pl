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

	for( @{ $eprint->value( "dates" ) } )
	{
		next unless defined $_->{date_type};
		next unless $_->{date_type} eq "published";
		return $_->{date};
	}
	return undef;
};
