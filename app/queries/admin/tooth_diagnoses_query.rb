module Admin
  class ToothDiagnosesQuery
    def initialize(patient_diagnosis_id)
      @patient_diagnosis_id = patient_diagnosis_id
    end

    def fetch_tooth_diagnoses
      ToothDiagnosis
        .where(patient_diagnosis_id: @patient_diagnosis_id)
        .includes(:diagnosis, tooth_diagnosis_treatments: :treatment)
        .order('tooth_number')
        .group_by(&:tooth_number)
    end
  end
end
