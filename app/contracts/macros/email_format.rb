# frozen_string_literal: true

module Macros
  module EmailFormat
    def self.included(base)
      base.register_macro(:email_format) do
        next if value.blank?

        key.failure(:invalid_format) unless URI::MailTo::EMAIL_REGEXP.match?(value)
      end
    end
  end
end
