import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooth", "diagnosisForm", "toothLabel", "noToothDiagnoses", "toothDeleteButton", "teethContainer"]

  connect() {
    this.selectedTooth = null;
    this.highlightDiagnosedTeeth();
  }

  dbClickTooth(event) {
    const clickedTooth = event.currentTarget;
    const toothNumber = clickedTooth.dataset.toothNumber;
    const patientDiagnosisId = this.teethContainerTarget.dataset.patientDiagnosisId;
    
    if (this.selectedTooth && this.selectedTooth !== clickedTooth) {
      if (this.selectedTooth.getAttribute('data-diagnosed') !== 'true') {
        this.unhighlightTooth(this.selectedTooth);
      }
    }
    if (this.hasNoToothDiagnosesTarget) {
      this.noToothDiagnosesTarget.classList.add("hidden")
    }
    
    this.selectedTooth = clickedTooth;
    this.toothLabelTarget.textContent = `Tooth #${toothNumber}`
    this.highlightTooth(clickedTooth);
    
    const diagnosisForm = this.diagnosisFormTarget;
    diagnosisForm.classList.remove('hidden');

    this.updateFormForTooth(toothNumber, patientDiagnosisId);
  }

  deleteToothDiagnosis(event) {
    const toothDiagnosisId = event.currentTarget.dataset.toothDiagnosisId
    const patientDiagnosisId = event.currentTarget.dataset.patientDiagnosisId

    fetch(`/admin/patient_diagnoses/${patientDiagnosisId}/tooth_diagnoses/${toothDiagnosisId}`, {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => {
      if (response.ok) {
        window.location.reload();
      } else {
        console.error('Error deleting tooth diagnosis');
      }
    })
    .catch(error => {
      console.error('Error:', error);
    });
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

  highlightTooth(tooth) {
    const paths = tooth.querySelectorAll('svg path');
    
    if (paths.length >= 1) {
      paths[0].setAttribute('style', 'fill:#e6f7ff; stroke:#0099cc; stroke-width:1');
    }
    
    if (paths.length >= 2) {
      paths[1].setAttribute('style', 'fill:#ccf2ff');
    }
  }

  updateFormForTooth(toothNumber, patientDiagnosisId) {
    const form = this.diagnosisFormTarget.querySelector('form');
    const toothNumberField = form.querySelector('[name="tooth_diagnosis[tooth_number]"]');
    
    if (toothNumberField) {
      toothNumberField.value = toothNumber;
    }
  }

  handleDiagnosisSaved(toothNumber) {
    const diagnosedTooth = this.toothTargets.find(tooth => 
      tooth.dataset.toothNumber === toothNumber.toString()
    );
    
    if (diagnosedTooth) {
      diagnosedTooth.setAttribute('data-diagnosed', 'true');
    }
  }

  highlightDiagnosedTeeth() {
    const diagnosedTeeth = this.element.querySelectorAll('[data-diagnosed="true"]');
    diagnosedTeeth.forEach(tooth => {
      this.highlightTooth(tooth);
    });
  }
}
