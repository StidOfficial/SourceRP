local Entity = FindMetaTable("Entity")

function Entity:IsChair()
	return self:IsValid() && (
			(
				self:GetParent() &&
				self:GetParent().Base == "base_chair"
			) || (
				getmetatable(self).MetaName == "Vehicle" && (
					self:GetVehicleClass() == "Seat_Airboat" ||
					self:GetVehicleClass() == "Chair_Office2" ||
					self:GetVehicleClass() == "phx_seat" ||
					self:GetVehicleClass() == "phx_seat2" ||
					self:GetVehicleClass() == "phx_seat3" ||
					self:GetVehicleClass() == "Chair_Plastic" ||
					self:GetVehicleClass() == "Seat_Jeep" ||
					self:GetVehicleClass() == "Chair_Office1" ||
					self:GetVehicleClass() == "Chair_Wood"
				)
			)
		)
end