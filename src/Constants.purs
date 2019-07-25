module Constants (
  jwtSecret,
  roles,
  serviceGroupDefaultName
) where


jwtSecret = "JWT_SECRET"

roles = {
  consumer: "consumer",
  serviceProvider: "serviceprovider",
  marketer: "marketer",
  administrator: "administrator"
}

serviceGroupDefaultName = "Default"
