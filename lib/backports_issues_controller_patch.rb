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

require_dependency 'issues_controller'


module BackportsIssuesControllerPatch

  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :destroy, :reassign_children_time_spent
    end
  end

  module InstanceMethods

    # this method is all copied from a more recent version containing the fix
    def destroy_with_reassign_children_time_spent
      self_and_descendants = @issues.collect(&:self_and_descendants).flatten
      issues_and_descendants_time_entries = TimeEntry.where([
        'issue_id IN (?)', self_and_descendants
      ])
      @hours = issues_and_descendants_time_entries.sum(:hours).to_f
      if @hours > 0
        case params[:todo]
        when 'destroy'
          # nothing to do
        when 'nullify'
          issues_and_descendants_time_entries.update_all('issue_id = NULL')
        when 'reassign'
          reassign_to = @project.issues.find_by_id(params[:reassign_to_id])
          if reassign_to.nil?
            flash.now[:error] = l(:error_issue_not_found_in_project)
            return
          elsif self_and_descendants.include? reassign_to
            flash.now[:error] = l(:cannot_reassign_time_entries_to_an_issue_going_to_be_deleted)
            return
          else
            issues_and_descendants_time_entries.update_all("issue_id = #{reassign_to.id}")
          end
        else
          # display the destroy form if it's a user request
          return unless api_request?
        end
      end
      @issues.each do |issue|
        begin
          issue.reload.destroy
        rescue ::ActiveRecord::RecordNotFound # raised by #reload if issue no longer exists
          # nothing to do, issue was already deleted (eg. by a parent)
        end
      end
      respond_to do |format|
        format.html { redirect_back_or_default _project_issues_path(@project) }
        format.api  { render_api_ok }
      end
    end

  end
end

IssuesController.send :include, BackportsIssuesControllerPatch
