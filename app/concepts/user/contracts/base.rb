# frozen_string_literal: true

module User::Contracts
  class Base < ApplicationContract
    property :id
    property :email
    property :username
    property :first_name
    property :last_name
    property :password
    property :password_confirmation, virtual: true

    validation contract: DryContract do
      option :form

      params do
        required(:email).value(:filled?, max_size?: 255)
        required(:username).value(:filled?, max_size?: 255)
        required(:first_name).value(:filled?, max_size?: 255)
        required(:last_name).value(:filled?, max_size?: 255)

        optional(:password).maybe(:string, min_size?: 10)
        optional(:password_confirmation).maybe(:string)
      end

      rule(:email).validate(:email_format)
      rule(:email).validate(uniqueness: { model: User })

      rule(:password) do
        key.failure(:filled?) if form.id.blank? && !values[:password]
      end

      rule(:password, :password_confirmation) do
        if values[:password].present? && values[:password_confirmation].present? && values[:password] != values[:password_confirmation]
          key(:password_confirmation).failure(:password_mismatch)
        end
      end
    end
  end
end
