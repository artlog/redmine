# Copyright Orange 2024
Redmine::Plugin.register :attribute_category do
  name 'Attribute Category plugin'
  author 'Philippe Lhardy'
  description 'Adds Category Groups for custom attributes. Sponsored by Orange.'
  version '0.9'
  url 'https://www.redmine.org/boards/1/topics/69072'
  author_url 'https://www.redmine.org/users/681631'

  # WARNING in redmine 4.x Rails.configuration.to_prepare
  Rails.application.config.after_initialize do
    Project.send(:include, ProjectModelPatch)
    ProjectsController.send(:include, ProjectsControllerPatch)
    Tracker.send(:include, TrackerModelPatch)
    CustomField.send(:include, CustomFieldModelPatch)
    CustomFieldsHelper.send(:include, CustomFieldsHelperPatch)
    CustomField.safe_attributes :group_category_layout
    IssuesHelper.send(:include, IssuesHelperPatch)
  end

  menu :admin_menu, :attribute_categories, { controller: 'attribute_categories', action: 'index' }, caption: 'Attribute Categories'

  permission :group_issues_custom_fields, {:group_issues_custom_fields => [:group_issues_custom_fields, :index], :projects => [:save_group_issues_custom_fields]}, :require => :member
  menu :project_menu, :group_issues_custom_fields, { controller: :group_issues_custom_fields, action: :index }, caption: :grouped_cf, after: :setting, param: :project_id  

end
