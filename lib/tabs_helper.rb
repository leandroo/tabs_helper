require 'tabs_helper/controller'
require 'tabs_helper/view'

ActionController::Base.extend(TabsHelper::Controller)
ActionView::Base.send(:include, TabsHelper::ViewHelpers)
