namespace :db do
  
  desc "Seed database with lookup table data"
  
  task seed_lookups: :environment do
  
    # Role Table for Users

    Role.create!(name:'Agent')
    Role.create!(name:'Dev Manager')
    Role.create!(name:'Admin') 

    # Status Table for Ideas

    Status.create!(name:'Active', category:'Rankable')
    Status.create!(name:'Analysis', category:'Rankable')
    Status.create!(name:'Ready', category:'Rankable')
    Status.create!(name:'Working', category:'Unrankable')
    Status.create!(name:'Finished', category:'Unrankable')
    Status.create!(name:'Tabled', category:'Unrankable')

  end


end