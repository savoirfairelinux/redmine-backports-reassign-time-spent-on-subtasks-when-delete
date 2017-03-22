Redmine Backports : Reassign Time Spent on Subtasks when delete parent
======================================================================

This plugin does backports the fix on Redmine 3.2.4 and older
http://www.redmine.org/issues/24693

Consider this plugin as unecessary if you use a Redmine with version greater
than 3.2.4 because this patch is directly applied stock.


Installation procedure
----------------------

We will show you how to install it on Debian family Linux distributions (such as Ubuntu), and Redmine installed with aptitude, but it can works on many other distros with similar procedures.

You may need to do those commands as root, depending on your particular case.

Feel free to replace the variable $REDMINE_PATH to your own Redmine instance path.

```bash
$REDMINE_PATH=/usr/share/redmine/

cd $REDMINE_PATH/plugins/
git clone git@github.com:savoirfairelinux/redmine-backports-reassign-time-spent-on-subtasks-when-delete.git
mv redmine-backports-reassign-time-spent-on-subtasks-when-delete redmine_backports_reassign_time_spent_on_subtasks_when_delete
bundle install
rake redmine:plugins:migrate RAILS_ENV=production
service apache2 reload  # or depending on which HTTP server you use
```
