module ToothDiagnosesHelper
  def sort_services_for_diagnosis(services, tooth_diagnosis)
    services.sort_by do |service|
      treatment = tooth_diagnosis.tooth_diagnosis_treatments.find { |t| t.service_id == service.id }
      [treatment.present? ? 0 : 1, service.name]
    end
  end
end
