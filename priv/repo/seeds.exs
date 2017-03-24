# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Halftame.Repo.insert!(%Halftame.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Halftame.Repo
alias Halftame.Place
alias Halftame.CourierOffer

google_id = "wekrh234#"
Repo.get_by(Place, google_id: google_id) || Repo.insert!(%Place{google_id: google_id, name: "Poznań", latitude: 31.231238, longitude: 31.23213138})
