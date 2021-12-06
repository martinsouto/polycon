json.extract! appointment, :id, :date, :first_name, :last_name, :phone, :notes, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
