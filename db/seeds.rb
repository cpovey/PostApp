# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
users = User.create([{name: "Craig", city: "Oakland"}, {name: "Will", city: "San Francisco"}, {name: "Kumi", city: "San Francisco"}])
posts = Post.create([{title: "First Post", content: "This is my first post", user: users[0]},
             {title: "Will's First Post", content: "This is Will's first post", user: users[1]}])
Image.create([{url: "http://i.imgur.com/fSgnUKW.jpg", post: posts[0]}, 
              {url: "http://i.imgur.com/zV4Gfr3.jpg", post: posts[1]}])
Comment.create([{content: "This is such a great post! Very clever and insightful - keep up the good work!", 
                 post: posts[0],
                 user: users[1], 
                 comments: Comment.create([{content: "I totally agree!", post: posts[0], user: users[2]}])}, 
                {content: "Not bad, but a little cliche, don't you think?", 
                 post: posts[1], 
                 user: users[0],
                 comments: Comment.create([{content: "Oh come on, give the guy a break.", post: posts[1], user: users[2]}])}])