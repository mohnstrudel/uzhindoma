class DeliverySerializer < ActiveModel::Serializer
  attributes :id, :name, :time

  def time
    object.intervals.each do |interval|
      id: interval.id,
      range: interval.value
    end
  end
end
