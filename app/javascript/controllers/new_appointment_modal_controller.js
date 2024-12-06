import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["container", "button", "closeButton"];

  closeModal(e){
    this.containerTarget.classList.add("hidden");
  }

  toggleModal(e) {
    this.containerTarget.classList.remove("hidden");
  }

  // async show(e){
  //   console.log(e.target.dataset.appointmentId);
  //   const id = e.target.dataset.appointmentId;
  //   const response = await fetch(`/admin/appointments/${id}`);

  //   if(response.ok){
  //     const data = await response.text();
  //     this.appointmentCardTarget.innerHTML = data;
  //   }
  // }

  // close(e) {
  //   this.appointmentCardTarget.innerHTML = "";
  // }
}
