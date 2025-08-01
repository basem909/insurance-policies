# Roles
admin    = User.create!(email: "admin@example.com",    password: "password", role: :admin)
operator = User.create!(email: "operator@example.com", password: "password", role: :operator)
client   = User.create!(email: "client@example.com",   password: "password", role: :client)

# A sample policy
Policy.create!(
  policy_number: "123456789012",
  user:          client,
  start_date:    1.week.ago.to_date,
  end_date:      1.month.from_now.to_date,
  status:        "active"
)
