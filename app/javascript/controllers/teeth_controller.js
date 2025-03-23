import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooth", "diagnosisForm", "toothLabel"]

  connect() {
    console.log("Teeth controller connected")
  }

  dbClickTooth(event) {
    const toothNumber = event.currentTarget.dataset.toothNumber
    const toothNumberInput = this.diagnosisFormTarget.querySelector('input[name="tooth_diagnosis[tooth_number]"]')

    this.diagnosisFormTarget.classList.remove("hidden")
    this.toothLabelTarget.textContent = `Tooth #${toothNumber}`

    if (toothNumberInput) {
      toothNumberInput.value = toothNumber
    }
    this.diagnosisFormTarget.scrollIntoView({ behavior: "smooth" })

    // Optionally, scroll to the form
    // const toothNumber = event.currentTarget.dataset.toothNumber;
    // const patientDiagnosisId = event.currentTarget.dataset.patientDiagnosisId;
    // try {
    //   fetch(`/admin/patient_diagnoses/${patientDiagnosisId}/tooth_diagnoses/new?tooth_number=${toothNumber}`, {
    //     method: "GET",
    //     headers: {
    //       "Content-Type": "application/json",
    //       "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
    //     }
    //   })
    //   .then(response => response.text())
    //   .then(html => {
    //     if (this.hasDiagnosisFormTarget) {
    //       this.diagnosisFormTarget.innerHTML = html;
    //       this.diagnosisFormTarget.classList.remove('hidden');
    //     } else {
    //       console.error("Missing diagnosis form target");
    //     }
    //   });
    // } catch (error) {
    //   console.error("Error creating tooth diagnosis:", error);
    // }
  }
}
