# frozen_string_literal: true

# Copyright Orange 2024

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

module AttributeCategoryIssuesHelper

  def group_by_keys(project_id, tracker_id, custom_field_values)

    keys_grouped = AttributeGroupField.joins(:attribute_group).
      where(:attribute_groups => {project_id: project_id, tracker_id: tracker_id}).
      order("attribute_groups.position", :position).pluck("attribute_groups.name", :custom_field_id).
      group_by{ |row| row.shift() }

    if keys_grouped[nil].nil?
      keys_grouped[nil] = []
    end

    attribute_group_custom_fields_id = keys_grouped.values.flatten
    default_group = custom_field_values.select{|custom_field_value| ! attribute_group_custom_fields_id.include?(custom_field_value.custom_field[:id])}

    if ! default_group.empty?
      default_keys_grouped = CustomField.where(id: default_group.map{ |custom_field_value| custom_field_value.custom_field_id}).pluck(:group_category_layout,:id).group_by{ |row| row.shift()}
      logger.error default_keys_grouped
      default_keys_grouped.each {|group,custom_field_id_array|
        if keys_grouped[group].nil?
          keys_grouped[group] = custom_field_id_array
        else
          keys_grouped[group].concat custom_field_id_array
        end
      }
    end

    custom_fields_grouped={ nil => [] }

    keys_grouped.each do |internal_group_name,v|
      attribute_group = AttributeGroup.where(:attribute_groups => {project_id: project_id, tracker_id: tracker_id, name: internal_group_name}).first()
      attribute_group_category = AttributeGroupCategory.new( attribute_group, group_category_layout_attribute_category(internal_group_name))
      custom_fields_grouped[attribute_group_category] = v.map{|custom_field_id_array| custom_field_values.select{|custom_field_value| custom_field_value.custom_field[:id] == custom_field_id_array[0]}}.flatten
    end
    custom_fields_grouped
  end

  def render_custom_field_value_full_width(value)
    content = content_tag('div', custom_field_name_tag(value.custom_field) + ":", :class => 'label') +
              content_tag('div', custom_field_value_tag(value), :class => 'value')
    content = content_tag('div', content, :class => "#{value.custom_field.css_classes} attribute")
    content_tag('div', content, :class => 'splitcontent')
  end

  def render_custom_fields_rows(issue)
    s = ''.html_safe
    group_by_keys(issue.project_id, issue.tracker_id, issue.visible_custom_field_values).
      each do |attribute_group_category, values|
      if values.present?
        group_content = ''.html_safe
        unless attribute_group_category.nil?
          if attribute_group_category.name.present?
            title = attribute_group_category.name
            group_content << content_tag('legend', title, :style => 'background: #0001; padding: 0.3em;') unless title.nil?
          end
          if attribute_group_category.description.present?
            description = attribute_group_category.description
            group_content << content_tag('div', textilizable(description), :class => 'wiki') unless description.nil?
          end
        end
        full_width_layout = ( not attribute_group_category.nil? ) && ( attribute_group_category.respond_to?(:full_width_layout) && attribute_group_category.full_width_layout )
        if full_width_layout
          while values.present?
            value=values.shift
            group_content << render_custom_field_value_full_width(value)
          end
        else
          while values.present?
            unless values[0].custom_field.full_width_layout?
              lr_values = []
              while values.present? && ! values[0].custom_field.full_width_layout?
                lr_values += [ values.shift ]
              end
              half = (lr_values.size / 2.0).ceil
              group_content<< issue_fields_rows do |rows|
                lr_values.each_with_index do |value, i|
                  m = (i < half ? :left : :right)
                  rows.send m, custom_field_name_tag(value.custom_field), custom_field_value_tag(value), :class => value.custom_field.css_classes
                end
              end
            else
              while values.present? && values[0].custom_field.full_width_layout?
                value=values.shift
                group_content << render_custom_field_value_full_width(value)
              end
            end
          end
        end
        s << content_tag('fieldset', group_content, :class => 'group_category_layout');
      end
    end
    s
  end


  def email_issue_attributes(issue, user, html)
    items = []
    %w(author status priority assigned_to category fixed_version start_date due_date parent_issue).each do |attribute|
      if issue.disabled_core_fields.grep(/^#{attribute}(_id)?$/).empty?
        attr_value = (issue.send attribute).to_s
        next if attr_value.blank?

        if html
          items << content_tag('strong', "#{l("field_#{attribute}")}: ") + attr_value
        else
          items << "#{l("field_#{attribute}")}: #{attr_value}"
        end
      end
    end
    group_by_keys(issue.project_id, issue.tracker_id, issue.visible_custom_field_values(user)).each do |title, values|
      if values.present?
        unless title.nil?
          if html
            items << content_tag('strong', "#{title}")
          else
            items << "#{title}"
          end
        end
        values.each do |value|
          cf_value = show_value(value, false)
          if html
            items << content_tag('strong', "#{value.custom_field.name}: ") + cf_value
          else
            items << "#{value.custom_field.name}: #{cf_value}"
          end
        end
      end
    end
    items
  end

  def render_email_issue_attributes(issue, user, html=false)
    items = email_issue_attributes(issue, user, html)
    if html
      content_tag('ul', items.select{|s| s.is_a? String}.map{|s| content_tag('li', s)}.join("\n").html_safe, :class => "details") + "\n" +
        items.select{|s| !s.is_a? String}.map{|item| content_tag('div', item.shift) + "\n" +
        content_tag('ul', item.map{|s| content_tag('li', s)}.join("\n").html_safe, :class => "details")}.join("\n").html_safe
    else
      items.select{|s| s.is_a? String}.map{|s| "* #{s}"}.join("\n") + "\n" +
        items.select{|s| !s.is_a? String}.map{|item| "#{item.shift}\n" + item.map{|s| "* #{s}"}.join("\n")}.join("\n")
    end
  end

end
