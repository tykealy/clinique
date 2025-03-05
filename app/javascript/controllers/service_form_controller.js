import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fixedSection", "rangeSection", "modeSelect"]

  connect() {
    this.togglePriceFields()
  }

  togglePriceFields(event) {
    // Get the value from the select that triggered the event, or from the modeSelect target if no event
    const priceMode = event ? event.target.value : this.modeSelectTarget.value
    
    // Update both selects to have the same value
    const selects = this.element.querySelectorAll('select[name="service[price_type]"]')
    selects.forEach(select => {
      select.value = priceMode
    })
    
    if (priceMode === "fixed") {
      this.fixedSectionTarget.classList.remove("hidden")
      this.rangeSectionTarget.classList.add("hidden")
    } else {
      this.fixedSectionTarget.classList.add("hidden")
      this.rangeSectionTarget.classList.remove("hidden")
    }
  }
}
