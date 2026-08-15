class Views::Users::Modal < Views::Base
  def initialize(form: nil)
    @form = form
  end

  def view_template
    dialog_with_form(trigger: "user-dialog-trigger") do |f|
      turbo_frame_tag "user_form" do
        render Views::Shared::DialogFormSkeleton.new(title: "Users", num_of_fields: 5)
      end
    end
  end

  private

  attr_reader :form
end
