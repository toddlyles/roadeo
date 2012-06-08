namespace :db do
  desc "Fill database with sample data"
  
  task populate: :environment do
    @admin_role = 3
    @agent_role = 1
    @active_status = 1

   
      User.create!(email: "admin@example.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 role_id: @admin_role)  #had to add this to attr_accessible for this to work
      
      50.times do |n|
        first_name  = Faker::Name.first_name
        email = "#{first_name}-#{n+1}@example.com"
        password  = "password"
        User.create!(email: email,
                   password: password,
                   password_confirmation: password,
                   role_id:@agent_role)
      end
  end
  

  task ideate: :environment do
      users = User.all
      
      # Create a bunch of Ideas
      users.each do |user| 
        idea_name = Faker::Lorem.sentence(2)
        idea_desc = Faker::Lorem.sentence(5)
        user.ideas.create!(title: idea_name, pitch: idea_desc, status_id:@active_status) 
      end
  end


  task rankify: :environment do
      # Rank a bunch of Ideas
      users = User.all
      last_idea = Idea.last.id
      
      users.each do |user| 
        # I was doing this in one line, but it kept complaining about unexpected tlabels and BS like that
        @new_rank = user.ranks.new

        @new_rank.transaction do
          @new_rank.idea_id = rand 1..last_idea
          @new_rank.value = rand 1..10
          @new_rank.save
        end
     end
  end

end