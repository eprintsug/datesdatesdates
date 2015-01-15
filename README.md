# Dates Dates Dates #

Allows a publication record to have multiple dates.

By default, EPrints only allows one date to be entered per publication at any given time: either the date of publication, date of submission or date of completion.

This module provides a replacement for the default EPrints "Date" and "Date Type" fields which allows the entry of any number of the following:

 * Date of publication
 * Date of acceptance
 * Date of submission
 * Date of deposit
 * Date of completion

## RIOXX2 Support ##

If the RIOXX2 package is installed (https://github.com/eprintsug/rioxx2) it will be automatically configured to use the replacement dates field provided by this package.

## Setup ##

After installation the following steps are required:

### Add new field to workflow ###

Edit workflow file (usually archives/repoid/cfg/workflows/eprint/default.xml) and:

 * replace all occurences of "date" with "dates" (be sure to retain the 'required' setting)
 * remove all occurences of "date_type"
 * remove rioxx2_dateAccepted and rioxx2_publication_date fields from rioxx2 stage if using RIOXX2 package

### Migrate existing records ###

To migrate all existing records to use the new date field, run the following command:

````
bin/epadmin recommit <repoid> --verbose
````
