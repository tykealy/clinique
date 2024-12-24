import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["container", "button", "closeButton", "form", "editButton", "appointmentCard" ];

  closeModal(e){
    this.containerTarget.classList.add("hidden");
  }

  async toggleModal(e) {
    const response = await fetch("/admin/appointments/new");

    if (response.ok) {
      const data = await response.text();
      this.formTarget.innerHTML = data;
    }
  }

  async toggleNewModal(e) {
    const date = e.currentTarget.dataset.date; // Get date from clicked column
    const time_hour = e.currentTarget.dataset.time; // Get time from clicked column

    const response = await fetch(`/admin/appointments/new?date=${date}&time_hour=${time_hour}`);  

    if (response.ok) {
      const data = await response.text();
      this.formTarget.innerHTML = data;
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
