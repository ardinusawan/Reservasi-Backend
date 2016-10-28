class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :booking, :start, :end
end
