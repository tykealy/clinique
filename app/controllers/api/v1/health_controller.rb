class Api::V1::HealthController < ApplicationController
  def check
    render json: {
      status: 'OK',
      timestamp: Time.current.iso8601
    }
  end
end
