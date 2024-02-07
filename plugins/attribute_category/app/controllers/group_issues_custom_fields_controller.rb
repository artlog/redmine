class GroupIssuesCustomFieldsController < ApplicationController

  helper :attribute_categories

  def index
    group_issues_custom_fields
  end
  
  def group_issues_custom_fields
    if not params[:project_id].nil?
      @project = Project.find(params[:project_id])
      # redirect_to projects_path(@source_project, :tab => :group_issues_custom_fields)

      if not @project.nil?
        @trackers = Tracker.sorted.to_a
        @cfs=AttributeGroup.joins(:custom_fields).joins(:tracker).
               where(project_id: @project, tracker_id: @trackers, :custom_fields => {id: @project.all_issue_custom_fields.pluck(:id)}).
               pluck("trackers.id", "id", "name", "position","attribute_group_fields.id", "attribute_group_fields.position",
                     "custom_fields.id", "custom_fields.name", "custom_fields.position","full_width_layout").sort_by{|x| [x[3], x[5]]}

        logger.info 'WITHIN GroupIssuesCustomFieldsController with project'
        render 'projects/settings/_group_issues_custom_fields'
      end
    else
      logger.info 'WITHIN GroupIssuesCustomFieldsController without project'
    end
  end
end
