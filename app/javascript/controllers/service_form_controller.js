import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "fixedSection", 
    "rangeSection", 
    "modeSelect",
    "fixedPriceInput",
    "minPriceInput",
    "maxPriceInput"
  ]

  connect() {
    this.togglePriceFields()
  }

  togglePriceFields(event) {
    const priceMode = event ? event.target.value : this.modeSelectTarget.value
    
    // Update both selects to have the same value
    const selects = this.element.querySelectorAll('select[name="service[price_type]"]')
    selects.forEach(select => {
      select.value = priceMode
    })
    
    if (priceMode === "fixed") {
      this.fixedSectionTarget.classList.remove("hidden")
      this.rangeSectionTarget.classList.add("hidden")
      
      // Disable and clear range price inputs
      this.minPriceInputTarget.disabled = true
      this.maxPriceInputTarget.disabled = true
      this.minPriceInputTarget.value = ""
      this.maxPriceInputTarget.value = ""
      
      // Enable fixed price input
      this.fixedPriceInputTarget.disabled = false
    } else {
      this.fixedSectionTarget.classList.add("hidden")
      this.rangeSectionTarget.classList.remove("hidden")
      
      // Disable and clear fixed price input
      this.fixedPriceInputTarget.disabled = true
      this.fixedPriceInputTarget.value = ""
      
      // Enable range price inputs
      this.minPriceInputTarget.disabled = false
      this.maxPriceInputTarget.disabled = false
    }
  }
}
