import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [  "toothDeleteButton", "diagnosisButton", 
    "serviceSelect", "dropdown", "toothDiagnosisForm"]

  // This is used to check if the user has added or removed a treatment from the tooth diagnosis
  hasChanged = false;

  updateFormForTooth(toothNumber, form) {
    const toothNumberField = form.querySelector('[name="tooth_diagnosis[tooth_number]"]');
    
    if (toothNumberField) {
      toothNumberField.value = toothNumber;
    }
  }

  toggleDiagnosisForm(event) {
    const toothNumber = event.currentTarget.dataset.toothNumber
    const form = this.toothDiagnosisFormTargets.find(
      form => form.dataset.toothNumber === toothNumber
    )
    this.updateFormForTooth(toothNumber, form)
    form.classList.toggle('hidden')
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


  toggleServiceSelect(event) {
    // Prevent the event from triggering twice
    if (!event.target.closest('[data-tooth-diagnoses-target="diagnosisButton"]')) return
    
    const button = event.currentTarget
    const toothDiagnosisId = button.dataset.toothDiagnosisId

    // Hide all other dropdowns first
    this.serviceSelectTargets.forEach(select => {
      if (select.dataset.toothDiagnosisId !== toothDiagnosisId) {
        select.classList.add('hidden')
      }
    })
    
    // Toggle the clicked dropdown
    const dropdown = this.serviceSelectTargets.find(
      select => select.dataset.toothDiagnosisId === toothDiagnosisId
    )
    dropdown.classList.toggle('hidden')
  }

  filterServices(event) {
    const searchTerm = event.target.value.toLowerCase()
    const dropdown = event.target.closest('[data-tooth-diagnoses-target~="serviceSelect"]')
    const labels = dropdown.querySelectorAll('label')
    
    labels.forEach(label => {
      const text = label.textContent.toLowerCase()
      label.style.display = text.includes(searchTerm) ? '' : 'none'
    })
  }

  handleClickAway(event) {
    // Don't close if clicking inside a dropdown or on a button that opens the dropdown
    const isClickInsideDropdown = this.dropdownTargets.some(dropdown => 
      dropdown.contains(event.target)
    )
    const isClickOnButton = this.diagnosisButtonTargets.some(button => 
      button.contains(event.target)
    )

    if (!isClickInsideDropdown && !isClickOnButton) {
      // Hide all dropdowns
      this.serviceSelectTargets.forEach(select => {
        select.classList.add('hidden')
      })
      if (this.hasChanged) {
        window.location.reload();
      }
    }
  }

  updateMultiDiagnosis(event) {
    const checkbox = event.target
    const serviceId = checkbox.dataset.serviceId
    const toothDiagnosisId = checkbox.dataset.toothDiagnosisId
    const isChecked = checkbox.checked
    const patientDiagnosisId = checkbox.dataset.patientDiagnosisId
    const treatmentId = event.target.dataset.treatmentId;
    const url = `/admin/patient_diagnoses/${patientDiagnosisId}/tooth_diagnoses/${toothDiagnosisId}/tooth_diagnosis_treatments`

    if (isChecked) {
      // Add treatment
      fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          tooth_diagnosis_treatment: {
            service_id: serviceId,
            tooth_diagnosis_id: toothDiagnosisId
          }
        })
      })
      .then(response => response.json())
      .then(data => {
        if(!data.success) {
          checkbox.checked = false; 
          alert('Error:', data.errors)
        }else {
          this.hasChanged = true;
        }
      })
      .catch(error => {
        alert('An error occurred while adding the treatment');
        checkbox.checked = false; 
      })
    } else {
      // Remove treatment
      fetch(`${url}/${treatmentId}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        if(!data.success) {
          checkbox.checked = true; 
          alert.error('Error:', data.errors)
        }else {
          this.hasChanged = true;
        }
      })
      .catch(error => {
        alert('An error occurred while deleting the treatment');
        checkbox.checked = true; 
      })
    }
  }
}
