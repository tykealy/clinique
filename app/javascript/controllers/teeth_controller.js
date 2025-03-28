import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooth" ,"noToothDiagnoses", "toothLabel", 
    "diagnosisForm",  "toothDeleteButton", "diagnosisButton", 
    "serviceSelect", "dropdown", "toothDiagnosisForm"]

  connect() {
    this.highlightedTooth = null;
    this.highlightDiagnosedTeeth();
  }

  highlightDiagnosedTeeth() {
    const diagnosedTeeth = this.element.querySelectorAll('[data-diagnosed="true"]');
    diagnosedTeeth.forEach(tooth => {
      this.highlightTooth(tooth);
    });
  }

  highlightTooth(tooth) {
    const paths = tooth.querySelectorAll('svg path');
    
    if (paths.length >= 1) {
      paths[0].setAttribute('style', 'fill:#e6f7ff; stroke:#0099cc; stroke-width:1');
    }
    
    if (paths.length >= 2) {
      paths[1].setAttribute('style', 'fill:#ccf2ff');
    }
  }

  dbClickTooth(event) {
    const clickedTooth = event.currentTarget;
    const toothNumber = clickedTooth.dataset.toothNumber;

    // If the tooth is already diagnosed, ignore the click
    if(clickedTooth.getAttribute('data-diagnosed') === 'true') {
      return;
    }
    
    //If the clicked tooth is not the currently highlighted tooth
    // unhighlight the currently highlighted tooth
    if (this.highlightedTooth && this.highlightedTooth !== clickedTooth) {
        this.unhighlightTooth(this.highlightedTooth);
    }
    
    if (this.hasNoToothDiagnosesTarget) {
      this.noToothDiagnosesTarget.classList.add("hidden")
    }
    
    this.highlightedTooth = clickedTooth;
    this.toothLabelTarget.textContent = `Tooth #${toothNumber}`
    this.highlightTooth(clickedTooth);
    
    const diagnosisFormWrapper = this.diagnosisFormTarget;
    const form = diagnosisFormWrapper.querySelector('form');
    diagnosisFormWrapper.classList.remove('hidden');

    this.updateFormForTooth(toothNumber, form);
  }

  unhighlightTooth(tooth) {
    const paths = tooth.querySelectorAll('svg path');
    
    if (paths.length >= 1) {
      paths[0].setAttribute('style', 'fill:#fff');
    }
    
    if (paths.length >= 2) {
      paths[1].setAttribute('style', '');
    }
  }

  updateFormForTooth(toothNumber, form) {
    const toothNumberField = form.querySelector('[name="tooth_diagnosis[tooth_number]"]');
    
    if (toothNumberField) {
      toothNumberField.value = toothNumber;
    }
  }

}
