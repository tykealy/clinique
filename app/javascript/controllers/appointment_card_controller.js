import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = [ "appointmentCard"];

  async show(e){
    // Add your logic to show the appointment details
    console.log(this.appointmentCardTarget);
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
