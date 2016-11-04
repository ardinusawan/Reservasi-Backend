class BookingSerializer < ActiveModel::Serializer
  attributes :id, :user, :type, :description
  belongs_to :user, key: "validation_by", if: :validation_by?

  def validation_by?
    true if object.validation_by!=0
  end

end
