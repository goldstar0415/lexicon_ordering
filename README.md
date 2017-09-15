# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...



User.all.includes(:orders).each do |u|
  u.orders.each do |o|
    o.update_column(:user_level_id, u.user_level_id)
  end
end