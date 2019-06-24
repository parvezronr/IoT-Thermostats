class ThermoStatSerializer < ActiveModel::Serializer
  attributes :id, :household_token, :location, :created_at, :updated_at
end
