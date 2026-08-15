module Views::Formable
  def dialog_with_form(**options, &block)
    trigger = options[:trigger] || "dialog-trigger"
    Dialog do
      DialogTrigger(class: "hidden", id: trigger) do
        Button { "Hidden Trigger" }
      end
      DialogContent(size: :md, class: "overflow-visible") do
        block.call(self)
      end
    end
  end

  def simple_form(**options, &block)
    url = options[:url] || "#"
    method = options[:method] || "post"

    Form(action: url, method: method) do
      input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)

      block.call(self)
    end
  end

  def simple_dialog_form(**options, &block)
    url = options[:url] || "#"
    method = options[:method] || "post"

    Form(action: url, method: method) do
      input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)

      DialogHeader do
        DialogTitle { options[:title] || "Your dialog title" }
      end

      DialogMiddle do
        block.call(self)
      end

      DialogFooter do
        Button(variant: :outline, data: { action: "click->ruby-ui--dialog#dismiss" }) { t("button.close") }
        Button(type: "submit") { t("button.save") }
      end
    end
  end

  def auto_submit_form(**options, &block)
    url = options[:url] || "#"
    method = options[:method] || "post"

    Form(action: url, method: method, data: { controller: "auto-submit" }) do
      input(type: "hidden", name: "authenticity_token", value: form_authenticity_token)

      block.call(self)
    end
  end
end
