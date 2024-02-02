#encoding: UTF-8
module ProjectsControllerPatch
  def self.included(base)
    base.class_eval do
      def save_group_issues_custom_fields
        # clean invalid values: invalid cfs, empty cf lists, empty groups
        group_issues_custom_fields = (JSON.parse params[:group_issues_custom_fields]).
                                       each{|tid,v| v.replace(v.select{|k,v| v["cfs"] ? v["cfs"].delete_if{|k,v| @project.all_issue_custom_fields.pluck(:id).include?(v)} : v})}.
                                       each{|tid,v| v.delete_if{|k,v| v["cfs"].blank?}}.
                                       delete_if{|k,v| v.blank?}

        groups = AttributeGroup.where(project_id: @project.id).collect(&:id)
        fields = AttributeGroupField.where(attribute_group_id: groups).collect(&:id)
        group_issues_custom_fields.each do |tid,v|
          v.each do |gp, g|
            gid = groups.shift
            if gid.nil?
              gid=AttributeGroup.create(project_id: @project.id, tracker_id: tid, name: g["name"].nil? ? nil : g["name"], position: gp).id
            else
              AttributeGroup.update(gid, project_id: @project.id, tracker_id: tid, name: g["name"].nil? ? nil : g["name"], position: gp)
            end
            g['cfs'].each do |cfp, cf|
              cfid = fields.shift
              if cfid.nil?
                AttributeGroupField.create(attribute_group_id: gid, custom_field_id: cf, position: cfp)
              else
                AttributeGroupField.update(cfid, attribute_group_id: gid, custom_field_id: cf, position: cfp)
              end
            end
          end
        end
        AttributeGroupField.where(id: fields).delete_all
        AttributeGroup.where(id: groups).destroy_all
        flash[:notice] = l(:notice_successful_update)
        redirect_to project_path(@project)
      end

    end
  end
end
