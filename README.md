# Dates Dates Dates #

Allows a publication record to have multiple dates.

By default, EPrints only allows one date to be entered per publication at any given time: either the date of publication, date of submission or date of completion.

This module provides a replacement for the default EPrints "Date" and "Date Type" fields which allows the entry of any combination of the following:

 * Date of publication
 * Date of online publication 
 * Date of acceptance
 * Date of submission
 * Date of completion

## RIOXX2 Support ##

If the RIOXX2 package is installed (https://github.com/eprintsug/rioxx2) it will be automatically configured to use the replacement dates field provided by this package.

## Setup ##

After installation the following steps are required:

### Add new field to workflow ###

Edit workflow file (usually archives/repoid/cfg/workflows/eprint/default.xml) and:

 1. replace all occurences of "date" with "dates" (be sure to retain the 'required' setting)
 2. remove all occurences of "date_type"
 3. remove rioxx2_dateAccepted and rioxx2_publication_date fields from rioxx2 stage if using RIOXX2 package

Recommended alternative to (1): remove all occurences of "date" and "date_type"* and add a single occurence of "dates" in its own component (ie. not in the Publication Details component) - this will give you extra validation warnings if a date is entered but an event not selected or vice versa.

````
  <stage name="core">

    [...]

    <component><field ref="divisions"/></component>

    <component show_help="always"><field ref="dates" required="yes"/></component>

    <component type="Field::Multi">
      <title>Publication Details</title>
      [...]
````
\* to comment out all occcurances of date and date_type
```` 
.,$s/\(<field ref="date"\/>\n\s*<field ref="date_type"\/>\)/<!-- \1 -->/gc
````
### Migrate existing records ###

To migrate all existing records to use the new date field, run the following command:

````
bin/epadmin recommit <repoid> eprint --verbose
````
