import { Controller } from "@hotwired/stimulus"

// Handles the alert component functionality
export default class extends Controller {
  connect() {
    // Auto-dismiss after 5 seconds
    setTimeout(() => this.dismiss(), 3000)
  }

  dismiss() {
    // Remove the alert from the DOM
    this.element.remove()
  }
}
