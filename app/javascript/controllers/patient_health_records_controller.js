import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['conditionInput', "conditionResults"];

  async conditionSearch(event){
    const query = event.target.value.trim();
    const patientId = this.conditionInputTarget.dataset.patientId

    if (query.length < 2) {
      this.conditionResultsTarget.classList.add("hidden");
      return; 
    }

    try {
      const response = await fetch(`/admin/patients/${patientId}/health_records/search?search=${query}`);
      const conditions = await response.json();
      if (conditions.length > 0) {
        this.generateConditionList(conditions);
      } 
      else{
        this.conditionResultsTarget.classList.add('hidden')
      }
    } catch (error) {
      console.error("Error fetching patients:", error);
    }
  }

  generateConditionList(conditions) {
    const conditionResult = conditions.map((condition)=> `
      <li class="p-2 rounded-md cursor-pointer hover:bg-gray-100" 
      data-condition-name = "${condition.name}"
      data-action="click->patient-health-records#selectCondition" 
      >
        ${condition.name}
      </li>
    ` ).join("")
    this.conditionResultsTarget.innerHTML= conditionResult
    this.conditionResultsTarget.classList.remove("hidden")
  }

  selectCondition(event){
    const selectCondition = event.target;
    const selectConditionName = selectCondition.dataset.conditionName;
    this.conditionInputTarget.value = selectConditionName;
    this.conditionResultsTarget.classList.add("hidden")
    }
}