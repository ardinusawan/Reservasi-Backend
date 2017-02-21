class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :booking, :start, :end

  belongs_to :booking, key: "booking", if: :booking?

  def booking?
    true if object.id!=0
  end
end
