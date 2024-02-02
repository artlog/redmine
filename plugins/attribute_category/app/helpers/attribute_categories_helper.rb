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

module AttributeCategoriesHelper

  # Return a html select custom fields for which we want id.
  def group_category_for_select(selected_attribute_category)
    selected_attribute_id = 0
    if selected_attribute_category.is_a?(String)
      selected_attribute_category=group_category_layout_attribute_category(selected_attribute_category)
      selected_attribute_category_id=selected_attribute_category.id if selected_attribute_category
    else
      selected_attribute_category_id=selected_attribute_category.to_i if selected_attribute_category.respond_to?(:to_i)
    end
    attribute_categories=AttributeCategory.all
    select='<select name="attribute_category[group_category_layout]" id="group_category_layout">'
    select+='<option value=""'
    select+=' selected="true"'
    select+=">None</option>\n"
    attribute_categories.each do |attribute_category|
      attribute_category_id = attribute_category.id
      select +='<option value="' + String(attribute_category_id)
      if attribute_category_id == selected_attribute_category_id
        select += '" selected="true'
      end
      select += '">' + attribute_category.name + "</option>\n"
    end
    select+='</select>'
    select.html_safe
  end

   # Return an array of custom fields for which we want id.
  def group_category_layout_for_select(selected_custom_field)
    attribute_categories=AttributeCategory.all
    select='<select name="custom_field[group_category_layout]" id="group_category_layout">'
    select+='<option value=""'
    if selected_custom_field.group_category_layout == ''
      select+=' selected="true"'
    end
    select+=">None</option>\n"
    attribute_categories.each do |attribute_category|
      id_str=String(attribute_category.id)
      select +='<option value="' + id_str
      if id_str == selected_custom_field.group_category_layout
        select += '" selected="true'
      end
      select += '">' + attribute_category.name + "</option>\n"
    end
    select+='</select>'
    select.html_safe
  end

  def group_category_layout_attribute_category(identifier)
    if identifier.respond_to?(:to_i)
      @attribute_category =  AttributeCategory.find(identifier)
    else
      if identifier.respond_to?(:to_s) and /\A\d+\z/.match(identifier.to_s)
        @attribute_category =  AttributeCategory.find(Integer(identifier))
      end
    end
    rescue ActiveRecord::RecordNotFound
      nil
  end

  def group_category_layout_display_name(identifier)
    @attribute_category = group_category_layout_attribute_category(identifier)
    @attribute_category ? @attribute_category.name : identifier
  end

  def group_category_layout_description(identifier)
    @attribute_category = group_category_layout_attribute_category(identifier)
    description = @attribute_category ? @attribute_category.description.presence : nil
    description
  end

end
