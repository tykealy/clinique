// app/javascript/controllers/profile_preview_controller.js

import { Controller } from "@hotwired/stimulus";
export default class extends Controller {
  static targets = ["container", "button", "closeButton"];

  closeModal(e){
    console.log("closeModal");
    this.containerTarget.classList.add("hidden");
  }

  toggleModal(e) {
    console.log("toggleModal");
    this.containerTarget.classList.remove("hidden");
  }

}
