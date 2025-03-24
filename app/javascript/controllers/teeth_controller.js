import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tooth", "diagnosisForm", "toothLabel", "noToothDiagnoses", "toothDeleteButton", "teethContainer", "diagnosisButton", "serviceSelect", "dropdown"]

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

  toggleServiceSelect(event) {
    // Prevent the event from triggering twice
    if (!event.target.closest('[data-teeth-target="diagnosisButton"]')) return
    
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

    // After toggling visibility, scroll the dropdown into view
    if (!dropdown.classList.contains('hidden')) {
      setTimeout(() => {
        dropdown.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'nearest' });
      }, 100);
    }
  }

  filterServices(event) {
    const searchTerm = event.target.value.toLowerCase()
    const dropdown = event.target.closest('[data-teeth-target="serviceSelect"]')
    const labels = dropdown.querySelectorAll('label')
    
    labels.forEach(label => {
      const text = label.textContent.toLowerCase()
      label.style.display = text.includes(searchTerm) ? '' : 'none'
    })
  }

  updateMultiDiagnosis(event) {
    const checkbox = event.target
    const serviceId = checkbox.dataset.serviceId
    const toothDiagnosisId = checkbox.dataset.toothDiagnosisId
    const isChecked = checkbox.checked

    // Make AJAX call to update the diagnoses
    fetch(`/admin/tooth_diagnoses/${toothDiagnosisId}/update_services`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ 
        service_id: serviceId,
        checked: isChecked 
      })
    })
    .then(response => response.json())
    .then(data => {
      // Update the button text with all selected services
      const button = this.diagnosisButtonTargets.find(
        btn => btn.dataset.toothDiagnosisId === toothDiagnosisId
      ).querySelector('button')
      button.textContent = data.selected_services.join(' | ')
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
    }
  }
}
