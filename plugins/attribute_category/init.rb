Redmine::Plugin.register :attribute_category do
  name 'Attribute Category plugin'
  author 'Philippe Lhardy'
  description 'Adds Category Caption for custom attributes'
  version '0.0.1'
  url 'https://www.redmine.org/boards/1/topics/69072'
  author_url 'https://www.redmine.org/users/681631'

  menu :admin_menu, :attribute_categories, { controller: 'attribute_categories', action: 'index' }, caption: 'AttributeCategories'
  
end
