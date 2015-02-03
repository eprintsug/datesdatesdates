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
				min_resolution => 'month',
				required => 1
			},
			{
				sub_name => 'date_type',
				type => 'set',
				options => [qw( published accepted submitted deposited completed )],
				required => 1
			},
		],
		input_boxes => 1
	}
);
