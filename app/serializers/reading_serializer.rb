class ReadingSerializer < ActiveModel::Serializer
  attributes :temperature, :humidity, :battery_charge, :reading_id

  def reading_id
    @object.try(:number)
  end
end
