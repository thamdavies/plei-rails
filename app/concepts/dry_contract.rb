# frozen_string_literal: true

class DryContract < Dry::Validation::Contract
  config.messages.backend = :i18n
  config.messages.default_locale = I18n.default_locale
  config.messages.load_paths << Rails.root.join("config/locales/dry_validation.#{I18n.locale}.yml")

  include Macros::EmailFormat
  include Macros::Uniqueness
end
