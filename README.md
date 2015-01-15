# Dates Dates Dates #

Allows a publication record to have multiple dates.

By default, EPrints only allows one date to be entered per publication at any given time: either the date of publication, date of submission or date of completion.

This module provides a replacement for the default EPrints "Date" and "Date Type" fields which allows the entry of any number of the following:

 * Date of publication
 * Date of acceptance
 * Date of submission
 * Date of deposit
 * Date of completion

 ## Setup ##

After installation the following steps are required:

1. Add new field to workflow

Edit workflow file (usually archives/repoid/cfg/workflows/eprint/default.xml) and:

 * replace all occurences of "date" with "dates" (be sure to retain the 'required' setting)
 * remove all occurences of "date_type"

2. Migrate existing records

To migrate all existing records to use the new date field, run the following command:

````
 bin/epadmin recommit <repoid>
````
