import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["results", "patientSelect", "container"];
  async search(event) {
    const query = event.target.value.trim();

    if (query.length < 2) {
      this.resultsTarget.classList.add("hidden");
      return; 
    }

    try {
      const response = await fetch(`/admin/patients/search?search=${query}`);
      const patients = await response.json();

      if (patients.length > 0) {
        this.generatePatientList(patients);
        this.updateOptions(patients);
      } else {
        this.resultsTarget.innerHTML = `<li class="p-2 text-gray-500">No patients found</li>`;
        this.resultsTarget.classList.remove("hidden");
      }
    } catch (error) {
      console.error("Error fetching patients:", error);
    }
  }

  generatePatientList(patients) {
    const resultItems = patients
    .map(
      (patient) => `
        <li class="p-2 hover:bg-gray-100 cursor-pointer rounded-md" 
            data-action="click->live-search#selectPatient" 
            data-patient-id="${patient.id}" 
            data-patient-phone-number="${patient.phone_number}"
            data-patient-name="${patient.first_name} ${patient.last_name}">
          ${patient.first_name} ${patient.last_name} - ${patient.phone_number}
        </li>
      `
    )
    .join("");
  this.resultsTarget.innerHTML = resultItems;
  this.resultsTarget.classList.remove("hidden");
  }


  updateOptions(patients) {
    this.patientSelectTarget.innerHTML = "";
    patients.forEach(patient => {
      const option = document.createElement("option");
      option.value = patient.id;
      option.textContent = `${patient.first_name} ${patient.last_name}`;
      this.patientSelectTarget.appendChild(option);
    });
  }

  selectPatient(event) {
    const selectedPatient = event.target;
    const patientName = selectedPatient.dataset.patientName;
    const patientPhoneNumber = selectedPatient.dataset.patientPhoneNumber;
    const patientId = selectedPatient.dataset.patientId;

    this.patientSelectTarget.value = patientId;
    const searchInput = document.getElementById("patient-search");
    searchInput.value = `${patientName} - ${patientPhoneNumber}`;

    this.resultsTarget.classList.add("hidden");
  }

}
