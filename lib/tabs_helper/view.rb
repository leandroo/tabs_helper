module TabsHelper
  module ViewHelpers
    class Tab

      def initialize(context)
        @context = context
      end

      def current_tab
        @context.instance_variable_get('@current_tab')
      end

      def current_tab?(tab)
        current_tab.to_s == tab.to_s
      end

      def create_tab(tab, content)
        css_class = "class='current'" if tab.to_s == current_tab.to_s
        "<li #{css_class}>#{content}</li>"
      end

      def method_missing(tab, *args, &block)
        if block_given?
          options      = args.first || {}
          html_options = args.second || {}
          link_content = @context.capture(&block)
          link         = @context.link_to(link_content, options, html_options)

          create_tab(tab, link)
        else
          name         = args.first
          options      = args.second || {}
          html_options = args.third || {}
          link         = @context.link_to(name, options, html_options)

          create_tab(tab, link)
        end
      end

    end

    def tabs(options={}, &block)
      raise ArgumentError, "Missing block" unless block_given?
      concat("<ul#{tag_options(options)}>")
      yield Tab.new(self)
      concat('</ul>')
    end

  end
end
