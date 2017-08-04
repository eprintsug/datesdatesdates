# To prevent citations, exports etc. from breaking, populate the default 'date' and 'date_type'
# fields using a suitable value from the new 'dates' field

$c->add_dataset_trigger( 'eprint', EPrints::Const::EP_TRIGGER_BEFORE_COMMIT, sub
{
	my( %args ) = @_;
	my( $repo, $eprint, $changed ) = @args{qw( repository dataobj changed )};

	# trigger is global - check that current repository actually has datesdatesdates enabled
	return unless $eprint->dataset->has_field( "dates" );
	
	# if this is an existing record, or a new record that has been imported, initialise
	# the 'dates' field first
	if( !$changed->{dates_date} && !$eprint->is_set( "dates" ) && $eprint->is_set( "date" ) )
	{
		$eprint->set_value( "dates", [
			{
				date => $eprint->value( "date" ),
				date_type => $eprint->value( "date_type" ),
			}
		]);
	}

	my $date_priorities = $repo->config("date_priorities");

	my $priority_zero = 0;

	my @dates = sort {
		($date_priorities->{$b->{date_type}} || $priority_zero) <=> ($date_priorities->{$a->{date_type}} || $priority_zero)
        } @{ $eprint->value( "dates" ) };

	my $date = scalar @dates ? $dates[0]->{date} : undef;
	my $date_type = scalar @dates ? $dates[0]->{date_type} : undef;

	$eprint->set_value( "date", $date );
	$eprint->set_value( "date_type", $date_type );

}, priority => 100 );

# Validation - ensure that only one of each type of date (published, accepted etc).
# has been entered
$c->add_trigger( EPrints::Const::EP_TRIGGER_VALIDATE_FIELD, sub
{
	my( %args ) = @_;
	my( $repo, $field, $eprint, $value, $problems ) = @args{qw( repository field dataobj value problems )};

	return unless $field->name eq "dates_date_type";

	my %seen;
	for( @{ $value } )
	{
		next unless defined $_;
		$seen{$_}++;
	}

	for( keys %seen )
	{
		if( $seen{$_} > 1 )
		{
			my $parent = $field->get_property( "parent" );
			my $fieldname = $repo->xml->create_element( "span", class=>"ep_problem_field:".$parent->get_name );
			$fieldname->appendChild( $parent->render_name( $repo ) );
			push @$problems, $repo->html_phrase( "validate:datesdatesdates:duplicate_date_type",
				fieldname => $fieldname,
				date_type => $repo->html_phrase( "eprint_fieldopt_dates_date_type_$_" ),
			);
		}
	}
}, priority => 100 );

# Validation - check that articles and conference items have a full acceptance date
# relevant to UK institutions to help comply with HEFCE Open Access guidelines
$c->add_trigger( EPrints::Const::EP_TRIGGER_VALIDATE_FIELD, sub
{
	my( %args ) = @_;
	my( $repo, $field, $eprint, $value, $problems ) = @args{qw( repository field dataobj value problems )};

	return unless $field->name eq "dates_date";
	return unless $eprint->value( "type" ) eq "article" || $eprint->value( "type" ) eq "conference_item";

	my $seen = 0;
	my $comp = 0;
	for( @{ $eprint->value( "dates" ) } )
	{
		next unless $_->{date_type} eq "accepted";
		$seen = 1;
		$comp = 1 if $_->{date} =~ /^\d{4}-\d{2}-\d{2}$/;
		last;
	}

	if( !$seen )
	{
		my $parent = $field->get_property( "parent" );
		my $fieldname = $repo->xml->create_element( "span", class=>"ep_problem_field:".$parent->get_name );
		$fieldname->appendChild( $parent->render_name( $repo ) );
		push @$problems, $repo->html_phrase( "validate:datesdatesdates:missing_accepted_date",
			fieldname => $fieldname,
		);
	}

	if( $seen && !$comp )
	{
		my $parent = $field->get_property( "parent" );
		my $fieldname = $repo->xml->create_element( "span", class=>"ep_problem_field:".$parent->get_name );
		$fieldname->appendChild( $parent->render_name( $repo ) );
		push @$problems, $repo->html_phrase( "validate:datesdatesdates:incomplete_accepted_date",
			fieldname => $fieldname,
		);
	}

}, priority => 100 );
