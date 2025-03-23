module Admin
  class ToothDiagnosesQuery
    def initialize(patient_diagnosis_id)
      @patient_diagnosis_id = patient_diagnosis_id
    end

    def fetch_tooth_diagnoses
      records = ToothDiagnosis.where(patient_diagnosis_id: @patient_diagnosis_id)
                              .order('tooth_number, created_at DESC')
                              .includes(:diagnosis)

      # Group the records by tooth_number
      records.group_by(&:tooth_number)
    end
  end
end
