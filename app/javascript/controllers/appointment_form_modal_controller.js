import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["container", "button", "closeButton", "form", "editButton", "appointmentCard" ];

  closeModal(e){
    this.containerTarget.classList.add("hidden");
  }

  toggleNewModal(e) {
    const date = e.currentTarget.dataset.date;
    const timeHour = e.currentTarget.dataset.time; 
    this.containerTarget.classList.remove("hidden");

    const dateField = this.containerTarget.querySelector('input[type="date"]');
    if (dateField) {
      dateField.value = date || '';
    }

    const timeHourField = this.containerTarget.querySelector('select[name$="[time_hour]"]');
    if (timeHourField) {
      timeHourField.value = timeHour || '';
    }
  }

  async edit(e){
    const id = e.target.dataset.appointmentId;
    const response = await fetch(`/admin/appointments/${id}/edit`);

    if(response.ok){
      const data = await response.text();
      this.appointmentCardTarget.innerHTML = "";
      this.formTarget.innerHTML = data;
    }
  }
}
