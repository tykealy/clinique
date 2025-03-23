import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooth", "diagnosisForm", "toothLabel", "noToothDiagnoses", "toothDeleteButton"]

  connect() {
    console.log("Teeth controller connected")
  }

  dbClickTooth(event) {
    const toothNumber = event.currentTarget.dataset.toothNumber
    const toothNumberInput = this.diagnosisFormTarget.querySelector('input[name="tooth_diagnosis[tooth_number]"]')

    this.diagnosisFormTarget.classList.remove("hidden")
    this.toothLabelTarget.textContent = `Tooth #${toothNumber}`
    if (this.hasNoToothDiagnosesTarget) {
      this.noToothDiagnosesTarget.classList.add("hidden")
    }
    if (toothNumberInput) {
      toothNumberInput.value = toothNumber
    }
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
}
