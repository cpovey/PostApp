# PostApp API
A simple Ruby on Rails application implementing some basic blogging functionality as a JSON API.  

Built using Ruby 2.2.2 and Rails 4.2.1

##Installing##
First things first: make sure you are running the same (or fully compatible) versions of Ruby and Rails mentioned above, then install the bundler gem (`gem install bundler`), and finally run `bundle install` from within the project directory. Once all the required gems are installed, simply start the server by running `rails s`, and start hitting the api endpoints described below with your favorite http request tool!

Example: hitting the following url from your browser should do the trick (although you should probably add some data to the database, or else the response won't be very interesting).

`http://localhost:3000/api/posts/`

##Seeding the database##
You can seed the database with a small amount of basic data by running the following from within the project directory: `rake db:setup` (or alternatively `rake db:reset` if you've already created it once), followed by `rake db:migrate`. If successful, hitting the url mentioned above should now display some nice JSON data in your browser!

##Running tests##
To run the full suite of rspec unit tests, simply run `rspec` from within the project directory. 

To run only the tests for a specific resource/endpoint, use `rspec spec/controllers/api/<name_of_spec_file>.rb`. For example, `rspec spec/controllers/api/posts_controller_spec.rb`

Finally, to run a specific test within a specific spec file, use `rspec spec/controllers/api/<name_of_spec_file>.rb:<line # of spcific test or test group>`. For example, `rspec spec/controllers/api/posts_controller_spec.rb:104`

##API Endpoints##
The following resources/endpoints are implemented as part of the API:  

###Posts###
1. List all posts that are no more than one month old
       GET '/api/posts'
Example response: 
```{
    "posts": [{
        "id": 2,
        "title": "Will's First Post",
        "author_name": "Will",
        "author_city": "San Francisco",
        "images": [{
            "url": "http://i.imgur.com/zV4Gfr3.jpg"
        }],
        "updated_at": "2015-04-06T02:58:04.772Z"
    }, {
        "id": 1,
        "title": "First Post",
        "author_name": "Craig",
        "author_city": "Oakland",
        "images": [{
            "url": "http://i.imgur.com/fSgnUKW.jpg"
        }],
        "updated_at": "2015-04-06T02:58:04.768Z"
    }]
}```
2. Create a new post
       POST '/api/posts'
Example ```POST``` params/data:
```
{
    "post" => {
        "title" => "Really Cool Post", "content" => "This is my first post, I hope you all like it!", "user" => {"id" => 1}
}```
3. View an individual post
       GET '/api/posts/:id'
Example response:
```
{
    "post": {
        "id": 1,
        "title": "First Post",
        "author_name": "Craig",
        "author_city": "Oakland",
        "images": [{
            "url": "http://i.imgur.com/fSgnUKW.jpg"
        }],
        "updated_at": "2015-04-06T02:58:04.768Z"
    }
}```
4. Update a post
       PUT '/api/posts/:id'
Example ```PUT``` params/data: 
```
{
    "post" => {
        "title" => "foo"
    }, 
    "id" => "1"
}```
5. Delete a post
       DELETE '/api/posts/:id'

###Images###
1. Add an image to a post
       POST '/api/images'
Example ```POST``` params/data:
```
{
    "image" => {
        "url" => "http://i.imgur.com/nruy8eg.jpg", "post" => {"id" => 1}
    }
}```
2. Delete an image from a post
       DELETE '/api/images/:id'

###Comments###
**Note:** Comments may be nested in a hierarchical tree structure within a post
1. List all the comments for a post
       GET '/api/comments?post_id=:id'
Example response: 
```
{
    "comments": [{
        "id": 4,
        "content": "This is such a great post! Very clever and insightful - keep up the good work!",
        "updated_at": "2015-04-06T02:58:04.840Z",
        "user": {
            "id": 2
        },
        "comments": [{
            "id": 2,
            "content": "I totally agree!",
            "updated_at": "2015-04-06T02:58:04.843Z",
            "user": {
                "id": 3
            },
            "comments": [{
                "id": 1,
                "content": "Me too!",
                "updated_at": "2015-04-06T02:58:04.824Z",
                "user": {
                    "id": 1
                },
                "comments": []
            }]
        }]
    }]
}```
2. Create a new comment for a post (either a "root" comment or nested within an existing comment thread)
       POST '/api/comments'
Example ```POST``` params/data: 
```
{
    "comment" => {
        "content" => "Nulla tempor est ex, vitae tempus justo facilisis tincidunt. Mauris.",
        "post" => {
            "id" => 1
        }, 
        "user" => {
            "id" => 1
        }
    }
}```
3. Delete an existing comment (and any/all comments nested beneath it)
       DELETE '/api/comments/:id'

##Next steps##
The following is a list of "next steps" that I would work on, given the time (prioritized with highest at the top):
1. Implement some reporting functionality that could aggregate data across dimensions such as: individual user activity (i.e. show me all the posts and comments for a given user) or regional activity (i.e. show me all the posts and/or comments made by any user in a given city).
2. Implement a UI to make use of the functionality provided by the API, so that normal users can actually use the thing :)
3. Add some user-friendly widgets for text editing/image uploading (e.g. currently an "image" in the system is nothing more than a url to an image elsewhere on the web, which is obviously not very robust). Instead, I'd be interested in trying something like the *ckeditor* library, as I've heard good things (https://github.com/galetahub/ckeditor)
4. Write more tests! The current test suite was intended as a light covering of the basic functionality, but by no means offers full or complete test coverage. You can **always** write more tests!
5. If this were to become a scalable, production-quality application, I'd of course have to address issues of concurrency, load balancing, redundancy, etc. 