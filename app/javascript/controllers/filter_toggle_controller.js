// app/javascript/controllers/filter_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    this.element.submit()
  }
}
