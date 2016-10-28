class BookingSerializer < ActiveModel::Serializer
  attributes :id, :user, :validation_by, :type, :description
end
