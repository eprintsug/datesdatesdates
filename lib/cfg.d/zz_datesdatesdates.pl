# Add a new compound field called 'dates' to allow multiple dates to be entered against a record
$c->add_dataset_field( "eprint",
	{
		name => 'dates',
		type => 'compound',
		multiple => 1,
		fields => [
			{ 
				sub_name => 'date',
				type => 'date',
				min_resolution => 'year'
			},
			{
				sub_name => 'date_type',
				type => 'set',
				options => [qw( published accepted submitted deposited completed )],
				required => 'yes'
			},
		],
		input_boxes => 1
	}
);

# To prevent citations, exports etc. from breaking, populate the default 'date' and 'date_type'
# fields using a suitable value from the new 'dates' field
$c->add_dataset_trigger( 'eprint', EPrints::Const::EP_TRIGGER_BEFORE_COMMIT, sub
{
	my( %args ) = @_;
	my( $repo, $eprint, $changed ) = @args{qw( repository dataobj changed )};

    # if this is an existing record, or a new record that has been imported, initialise
    # the 'dates' field first
	if( !$eprint->is_set( "dates" ) && $eprint->is_set( "date" ) )
	{
		$eprint->set_value( "dates", [
			{
				date => $eprint->value( "date" ),
				date_type => $eprint->value( "date_type" ),
			}
		]);
	}

	# set a suitable 'date' and 'date_type' value
    # use published date for preference - if not available use accepted date, and so on
	my %priority = (
		published => 1,
		accepted => 2,
		submitted => 3,
		completed => 4,
		default => 99,
	);

	my @dates = sort {
		$priority{$a->{date_type}||"default"} <=> $priority{$b->{date_type}||"default"}
	} @{ $eprint->value( "dates" )||[] };

	my $date = scalar @dates ? $dates[0]->{date} : undef;
	my $date_type = scalar @dates ? $dates[0]->{date_type} : undef;

	$eprint->set_value( "date", $date );
	$eprint->set_value( "date_type", $date_type );

}, priority => 100 );
