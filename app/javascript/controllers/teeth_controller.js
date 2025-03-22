import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooth"]

  connect() {
    console.log("Teeth controller connected")
  }

  dbClickTooth(event) {
    const toothNumber = event.currentTarget.dataset.toothNumber;
    console.log(`Tooth ${toothNumber} was double clicked`);
  }
}
