#encoding: UTF-8
module IssuesHelperPatch
  def self.included(base)
    base.class_eval do
      prepend AttributeCategoryIssuesHelper
    end
  end
end
