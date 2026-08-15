// Entry point for the build script in your package.json
import { Turbo } from "@hotwired/turbo-rails"
import "./controllers"

Turbo.StreamActions.close_dialog = function() {
	const selector = this.getAttribute("selector")
	let dialog = null

	if (selector) {
		dialog = document.querySelector(selector)
	} else {
		const dialogs = document.querySelectorAll("body > div[data-controller='ruby-ui--dialog']")
		dialog = dialogs[dialogs.length - 1]
	}

	if (dialog) {
		document.body.classList.remove("overflow-hidden")
		dialog.remove()
	}
}
