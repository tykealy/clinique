import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = [ "appointmentCard"];

  stopPropagation(event) {
    event.stopPropagation();
  }

  async show(e){
    const id = e.target.dataset.appointmentId;
    const response = await fetch(`/admin/appointments/${id}`);

    if(response.ok){
      const data = await response.text();
      this.appointmentCardTarget.innerHTML = data;
    }
  }

  close(e) {
    this.appointmentCardTarget.innerHTML = "";
  }
}
