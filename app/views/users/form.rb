class Views::Users::Form < Views::Base
  def initialize(form:)
    @form = form
  end

  def view_template
    simple_dialog_form(url: form_url, method: form_method, title:) do
      FormField(class: "mb-2") do
        FormFieldLabel(for: "form_username") { "Username" }
        Input(id: "form_username", placeholder: "eg. johndoe", name: "form[username]", value: form.username)
        FormFieldError(for: "form_username") { form.errors[:username].first }
      end

      div(class: "mb-2 grid gap-2 sm:grid-cols-2") do
        FormField do
          FormFieldLabel(for: "form_first_name") { "First Name" }
          Input(id: "form_first_name", placeholder: "eg. John", name: "form[first_name]", value: form.first_name)
          FormFieldError(for: "form_first_name") { form.errors[:first_name].first }
        end

        FormField do
          FormFieldLabel(for: "form_last_name") { "Last Name" }
          Input(id: "form_last_name", placeholder: "eg. Doe", name: "form[last_name]", value: form.last_name)
          FormFieldError(for: "form_last_name") { form.errors[:last_name].first }
        end
      end

      FormField(class: "mb-2") do
        FormFieldLabel(for: "form_email") { "Email" }
        Input(id: "form_email", placeholder: "eg. johndoe@example.com", name: "form[email]", value: form.email)
        FormFieldError(for: "form_email") { form.errors[:email].first }
      end

      FormField(class: "mb-2") do
        FormFieldLabel(for: "form_password") { "Password" }
        Input(id: "form_password", placeholder: "", name: "form[password]", value: form.password)
        FormFieldError(for: "form_password") { form.errors[:password].first }
      end

      FormField(class: "mb-2") do
        FormFieldLabel(for: "form_password_confirmation") { "Password Confirmation" }
        Input(id: "form_password_confirmation", placeholder: "", name: "form[password_confirmation]", value: form.password_confirmation)
        FormFieldError(for: "form_password_confirmation") { form.errors[:password_confirmation].first }
      end
    end
  end

  private

  attr_reader :form

  def title
    form.model.new_record? ? "Create User" : "Edit User"
  end

  def form_url
    form.model.new_record? ? users_path : user_path(form.model)
  end

  def form_method
    form.model.new_record? ? :post : :patch
  end
end
