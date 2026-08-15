# frozen_string_literal: true

# Reusable uniqueness validator.
# Usage in a rule:
#   rule(:email).validate(uniqueness: { model: User })
#   rule(:email).validate(uniqueness: { model: User, scope: %i[account_id] })
#   rule(:contact_email).validate(uniqueness: { model: User, field: :email, message: :taken })
# Notes:
# - scope accepts one or many fields.
# - current record is excluded automatically (form.model.id, values[:id], or form.id).
module Macros
  module Uniqueness
    def self.included(base)
      base.register_macro(:uniqueness) do |macro:|
        next if value.blank?

        options = macro.args.first || {}
        model = options[:model]
        next unless model

        field = (options[:field] || key.path.keys.last).to_sym
        scope_fields = Array(options[:scope]).map(&:to_sym)
        message = options[:message] || :taken

        relation = model.where(field => value)

        scope_fields.each do |scope_field|
          scoped_value = if values.key?(scope_field)
            values[scope_field]
          elsif form.respond_to?(scope_field)
            form.public_send(scope_field)
          elsif form.respond_to?(:model) && form.model.respond_to?(scope_field)
            form.model.public_send(scope_field)
          end

          relation = relation.where(scope_field => scoped_value)
        end

        if form.respond_to?(:model) && form.model.respond_to?(:id) && form.model.id.present?
          relation = relation.where.not(id: form.model.id)
        elsif values.key?(:id) && values[:id].present?
          relation = relation.where.not(id: values[:id])
        elsif form.respond_to?(:id) && form.id.present?
          relation = relation.where.not(id: form.id)
        end

        key.failure(message) if relation.exists?
      end
    end
  end
end
