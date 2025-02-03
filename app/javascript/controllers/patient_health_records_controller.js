import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["recordInput", "addKeyInput", "addValueInput"];

  connect() {
    console.log("Patient Health Records Controller connected");
  }

  editRecord(event) {
    const recordId = event.target.getAttribute("data-id");
    const inputs = this.element.querySelectorAll(`#patient-search-${recordId}, #value-${recordId}`);
    inputs.forEach((input) => {
      input.disabled = false;
      input.classList.remove("disabled:opacity-50");
      input.focus();
    });
  }

  saveRecord(event) {
    const recordId = event.target.getAttribute("data-id");
    const conditionInput = this.element.querySelector(`#patient-search-${recordId}`);
    const valueInput = this.element.querySelector(`#value-${recordId}`);

    const payload = {
      condition: conditionInput.value,
      value: valueInput.value,
    };

    // Example: Send the updated data to your backend via fetch
    fetch(`/admin/health_records/${recordId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify(payload),
    })
      .then((response) => {
        if (response.ok) {
          alert("Record updated successfully");
          conditionInput.disabled = true;
          valueInput.disabled = true;
          conditionInput.classList.add("disabled:opacity-50");
          valueInput.classList.add("disabled:opacity-50");
        } else {
          alert("Failed to update record");
        }
      });
  }

  deleteRecord(event) {
    const recordId = event.target.getAttribute("data-id");

    if (!confirm("Are you sure you want to delete this record?")) return;

    // Example: Send delete request to your backend
    fetch(`/admin/health_records/${recordId}`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
    }).then((response) => {
      if (response.ok) {
        alert("Record deleted successfully");
        this.element.querySelector(`#record-${recordId}`).remove();
      } else {
        alert("Failed to delete record");
      }
    });
  }

  addRecord() {
    const conditionInput = this.addKeyInputTarget;
    const valueInput = this.addValueInputTarget;

    if (!conditionInput.value.trim() || !valueInput.value.trim()) {
      alert("Both fields are required");
      return;
    }

    const payload = {
      condition: conditionInput.value,
      value: valueInput.value,
    };

    // Example: Send the new record data to your backend via fetch
    fetch(`/admin/health_records`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify(payload),
    })
      .then((response) => response.json())
      .then((data) => {
        // Add the new record to the DOM
        const newRow = `
          <div id="record-${data.id}" class="grid grid-cols-12 gap-4">
            <input id="patient-search-${data.id}" type="text"
              value="${data.condition}"
              class="block w-full col-span-5 mt-1 border-gray-300 rounded-md shadow-sm focus:border-gray-300 focus:ring-primary disabled:opacity-50"
              disabled
            />
            <input type="text"
              id="value-${data.id}"
              value="${data.value}"
              class="block w-full col-span-5 mt-1 border-gray-300 rounded-md shadow-sm focus:border-gray-300 focus:ring-primary disabled:opacity-50"
              disabled
            />
            <div class="flex justify-center col-span-2 gap-4">
              <button class="text-primary hover:text-primary-700" data-id="${data.id}" data-action="click->patient-health-records#editRecord">
                Edit
              </button>
              <button class="text-red-500 hover:text-red-700" data-id="${data.id}" data-action="click->patient-health-records#deleteRecord">
                Remove
              </button>
            </div>
          </div>
        `;
        this.element.insertAdjacentHTML("beforeend", newRow);

        // Clear input fields
        conditionInput.value = "";
        valueInput.value = "";
      });
  }
}