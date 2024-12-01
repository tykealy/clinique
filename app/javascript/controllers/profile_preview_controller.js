// app/javascript/controllers/profile_preview_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview", "container", "handler", "icon"];

  previewImage() {
    const file = this.inputTarget.files[0];

    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result;
        this.containerTarget.classList.remove("hidden"); // Show profile container
        this.iconTarget.classList.remove("hidden"); // Show profile icon
        this.handlerTarget.classList.add("hidden"); // Hide the handler
      };
      reader.readAsDataURL(file);
    }
  }
}
