# TabsForRails
module TabsHelper
  
  def self.included(base) # base is the class that included the module
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class DashboardController < ApplicationController
  #     current_tab :mydashboard
  #   end
  #
  #   # View
  #   <% tabs do |tab| %>
  #     <%= tab.account 'Account', account_path, :style => 'float: right' %>
  #     <%= tab.users 'Users', users_path, :style => 'float: right' %>
  #     <%= tab.mydashboard 'Dashboard', '/' %>
  #     <%= tab.projects 'Projects', projects_path %>
  #   <% end %>
  #   The HTML Result will be:
  #   <ul id="tabs">
  #     <li><a href="/accounts">Account</a></li>
  #     <li><a href="/users">Users</a></li>
  #     <li><a href="/" class="current">Dashboard</a></li>
  #     <li><a href="/projects">Projects</a></li>    
  #   </ul>  
  
  module ClassMethods
    def current_tab(name, options = {})
      before_filter(options) do |controller|
        controller.instance_variable_set('@current_tab', name)
      end
    end
  end

  module Helpers
    module ViewHelpers
      class Tab
        def initialize(context)
          @context = context
        end

        def current_tab
          @context.instance_variable_get('@current_tab')
        end

        def method_missing(tab, name, options = {}, html_options = {})
          html_options[:class].nil? ? html_options[:class] = 'current' : html_options[:class] << 'current' if tab.to_s == current_tab.to_s
          "<li>#{@context.link_to(name, options, html_options)}</li>"
        end
      end

      def tabs(&block)
        raise ArgumentError, "Missing block" unless block_given?

        concat('<ul id="tabs">')
        yield(Tab.new(self))
        concat('</ul>')
      end

    end
  end
end
