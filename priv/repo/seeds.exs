# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InnCheck.Repo.insert!(%InnCheck.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
InnCheck.Accounts.create_user(%{name: "admin", password: "admin"})
InnCheck.Accounts.create_user(%{name: "operator", password: "operator", roles: ["operator"]})
