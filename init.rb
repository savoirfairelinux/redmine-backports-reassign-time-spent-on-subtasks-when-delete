# Redmine - project management software
# Copyright (C) 2006-2016  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redmine'
require 'backports_issues_controller_patch'

Redmine::Plugin.register :redmine_backports_reassign_time_spent_on_subtasks_when_delete do

    name 'Backports : Reassign Time Spent on Subtasks when delete parent'
    author 'Redmine & Savoir-faire Linux'
    description 'This plugin does backports the fix on Redmine 3.2.4 and older.'
    version '0.1.0'

end
