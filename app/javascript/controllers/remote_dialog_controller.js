import { Controller } from "@hotwired/stimulus";
import { get } from '@rails/request.js';

// Connects to data-controller="remote-dialog"
export default class extends Controller {
  static values = {
    path: String,
    target: String
  };

  show(event) {
    event.preventDefault();
    if (!this.pathValue) return;

    const target = document.getElementById(this.targetValue);
    if (target) {
      target.click();
      get(this.pathValue, { responseKind: 'turbo-stream' });
    } else {
      console.error(`Element with ID '${this.targetValue}' not found.`);
    }
  }
}
