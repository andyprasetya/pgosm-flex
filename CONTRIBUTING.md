# Contributing

We encourage pull requests from everyone.

Fork the project into your own repo, create a topic branch there and then make one or more pull requests back to the main repository. Your pull requests can then be reviewed and discussed.


## Adding new feature layers

Checklist for adding new feature layers:

* Create `flex-config/style/<feature>.lua`
* Create `flex-config/sql/<feature>.sql`
* Update `flex-config/run-no-tags.lua`
* Update `flex-config/run-no-tags.sql`
* Update `db/qc/features_not_in_run_all.sql`
