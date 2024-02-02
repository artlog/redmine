
# get 'attribute_category', to: 'attribute_category#index'
# get 'attribute_category/:id', to: 'attribute_category#show'


resources :attribute_categories

# required for menu
get :group_issues_custom_fields, to: 'group_issues_custom_fields#index'

get 'projects/:id/group_issues_custom_fields', to: 'group_issues_custom_fields#group_issues_custom_fields'

post 'projects/:id/group_issues_custom_fields', to: 'projects#save_group_issues_custom_fields'
