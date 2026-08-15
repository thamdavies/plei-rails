# frozen_string_literal: true

class Components::Base < Phlex::HTML
  include RubyUI
  include PhlexIcons

  # Include any helpers you want to be available across all components
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::T
  include Phlex::Rails::Helpers::FormAuthenticityToken

  register_output_helper :pagy_nav

  if Rails.env.development?
    def before_template
      comment { "Before #{self.class.name}" }
      super
    end
  end
end
