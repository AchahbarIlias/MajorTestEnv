# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jmunited.Repo.insert!(%Jmunited.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
{:ok, _cs} =
  Jmunited.UserContext.create_user_admin(%{
    "password" => "t",
    "role" => "Admin",
    "email" => "i@a.com",
    "confirmed" => true,
    "street" => "ietstraat",
    "number" => 69,
    "zip" => 1337,
    "country" => "Belgium",
    "first_name" => "ilias",
    "last_name" => "Achahbar",
    "city" => "Mechelen"
  })