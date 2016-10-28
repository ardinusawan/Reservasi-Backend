class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :hp, :nrp_nip, :password, :is_admin
end
