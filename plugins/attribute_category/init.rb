

# patch required ( current ActiveRecords 7.1.2 association bug ) for IssueCustmField.has_many
module ActiveRecord
  module Associations
    # Returns the association instance for the given name, instantiating it if it doesn't already exist
    def association(name) # :nodoc:
      association = association_instance_get(name)

      if association.nil?
        reflection = self.class._reflect_on_association(name)

        # if reflection is nil, try to get the parent class' reflection
        klass = self.class.superclass
        while reflection.nil? && klass.respond_to?(:_reflect_on_association)
          reflection = klass._reflect_on_association(name)
          klass = klass.superclass
        end

        unless reflection
          raise AssociationNotFoundError.new(self, name)
        end

        association = reflection.association_class.new(self, reflection)
        association_instance_set(name, association)
      end

      association
    end
  end
end

# Copyright Orange 2024
Redmine::Plugin.register :attribute_category do
  name 'Attribute Category plugin'
  author 'Philippe Lhardy'
  description 'Adds Category Groups for custom attributes. Sponsored by Orange.'
  version '5.1.1.0.1'
  url 'https://www.redmine.org/boards/1/topics/69072'
  author_url 'https://www.redmine.org/users/681631'

  # WARNING in redmine 4.x Rails.configuration.to_prepare
  Rails.application.config.after_initialize do
    Project.include ProjectModelPatch
    ProjectsController.include ProjectsControllerPatch
    Tracker.include TrackerModelPatch
    CustomField.include CustomFieldModelPatch
    CustomFieldsHelper.include CustomFieldsHelperPatch
    CustomField.safe_attributes :group_category_layout
    IssuesHelper.include IssuesHelperPatch
  end

  menu :admin_menu, :attribute_categories, { controller: :attribute_categories, action: :index }, caption:  :label_attribute_category_plural, :html => {:class => 'icon icon-custom-fields'}

  permission :group_issues_custom_fields, {:group_issues_custom_fields => [:group_issues_custom_fields, :index], :projects => [:save_group_issues_custom_fields]}, :require => :member
  menu :project_menu, :group_issues_custom_fields, { controller: :group_issues_custom_fields, action: :index }, caption: :grouped_cf, after: :setting, param: :project_id  

end
