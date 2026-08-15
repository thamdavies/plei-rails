class Views::Shared::DialogFormSkeleton < Views::Base
  def initialize(title: "Your title here", num_of_fields: 3)
    @title = title
    @num_of_fields = num_of_fields
  end

  def view_template
    DialogHeader do
      DialogTitle { title }
    end

    DialogMiddle do
      div(class: "space-y-6") do
        num_of_fields.times do
          div(class: "space-y-2") do
            Skeleton(class: "h-4 w-[80px]")
            Skeleton(class: "h-9 w-full rounded-md")
          end
        end

        DialogFooter do
          Button(variant: :outline, data: { action: "click->ruby-ui--dialog#dismiss" }) { "Cancel" }
          Button(type: "submit") { "Submit" }
        end
      end
    end
  end

  private

  attr_reader :title, :num_of_fields
end
