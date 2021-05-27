Most of the developers do take online courses across various platforms like Udemy, Coursera, Edx, etc... In this post, I will explain how to build a basic course tracker application using Ruby on Rails, which can help to track the progress of your courses.

For this tutorial, I will be using
- Ruby 2.6.3
- Rails 5.2.6
- Bootstrap 5
- SQLite Database

But this step-by-step tutorial should work for the latest Ruby & Rails versions as well.

Index:

* [Create a project](#create-a-project)
* [Start server](#start-server)
* [Create Model, Controller and Views](#create-model-controller-and-views)
* [Database Migration](#database-migration)
* [Change Application Root](#change-application-root)
* [Integrate Bootstrap](#integrate-bootstrap)
* [Add Navigation Bar](#add-navigation-bar)
* [Add Course status Select option](#add-course-status-select-option)
* [Styling Course Forms](#styling-course-forms)


## Create a project

```
rails new course-tracker
```

This command will create a project `course-tracker` with the following structure.

```
cd course-tracker/
```

```.
├── Gemfile
├── Gemfile.lock
├── README.md
├── Rakefile
├── app
├── bin
├── config
├── config.ru
├── db
├── lib
├── log
├── package.json
├── public
├── storage
├── test
├── tmp
└── vendor

11 directories, 6 files
```

## Start server

- Run `rails server` or `rails s` (shortcut) to start the server and visit [`http://localhost:3000`](http://localhost:3000) in your browser. If there are no errors you will see the following screen.


![rails-start-server](https://cdn.hashnode.com/res/hashnode/image/upload/v1622114422070/J3jCp5Oo8.png)

## Create Model, Controller and Views

Let's create `Course` Model and corresponding Controller using `rails scaffold`.

A scaffold in Rails is a full set of model, database migration for that model, a controller to manipulate it, views to view and manipulate the data, and a test suite for each of the above. Our `Course` model will have following fields
- title - string 
- image_url - string
- url - string
- status - string
- started - datetime
- completed - datetime

```
rails g scaffold Course title:string image_url:string url:string status:string started:datetime completed:datetime
```
 
This will generate the following files with Book Model, Views & Controller. 
```
      invoke  active_record
      create    db/migrate/20210527131258_create_courses.rb
      create    app/models/course.rb
      invoke    test_unit
      create      test/models/course_test.rb
      create      test/fixtures/courses.yml
      invoke  resource_route
       route    resources :courses
      invoke  scaffold_controller
      create    app/controllers/courses_controller.rb
      invoke    erb
      create      app/views/courses
      create      app/views/courses/index.html.erb
      create      app/views/courses/edit.html.erb
      create      app/views/courses/show.html.erb
      create      app/views/courses/new.html.erb
      create      app/views/courses/_form.html.erb
      invoke    test_unit
      create      test/controllers/courses_controller_test.rb
      create      test/system/courses_test.rb
      invoke    helper
      create      app/helpers/courses_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/courses/index.json.jbuilder
      create      app/views/courses/show.json.jbuilder
      create      app/views/courses/_course.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/courses.coffee
      invoke    scss
      create      app/assets/stylesheets/courses.scss
      invoke  scss
      create    app/assets/stylesheets/scaffolds.scss
```

## Database Migration

- Scaffold command also generated database migration for creating `Course` table at `db/migrate/20210527131258_create_courses.rb`

```
class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :image_url
      t.string :url
      t.string :status
      t.datetime :started
      t.datetime :completed

      t.timestamps
    end
  end
end
```

- Let's execute database migration using `rails db:migrate` command.

```
➜  course-tracker git:(master) ✗ rails db:migrate
== 20210527131258 CreateCourses: migrating ====================================
-- create_table(:courses)
   -> 0.0008s
== 20210527131258 CreateCourses: migrated (0.0008s) ===========================
```

## Change Application Root

- Now our migration is completed. Lets point our application home page to `Course#Index` page. 
- Update `config/routes.rb` to point root to course controller index action.

```
Rails.application.routes.draw do
  resources :courses
  root 'courses#index'
end
```

## Integrate Bootstrap

- Import bootstrap css and dependent js files in `app/views/layouts/application.html.erb` 

```
<!DOCTYPE html>
<html>
  <head>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>

    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">

    <title>Course Tracker</title>

  </head>

  <body>
    <div class="container">
     <%= yield %>
    </div>
    <!-- Option 1: Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
  </body>
</html>
```

## Add Navigation Bar

- Let's add a navigation bar to all pages. Adding this in the application layout will take care of loading navigation bar in all web pages.

- create file `app/views/layouts/_navbar.html.erb` with the following html content.

```
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">Course Tracker</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
      <div class="navbar-nav">
        <a class="nav-link active" aria-current="page" href="/courses">Courses</a>
      </div>
    </div>
  </div>
</nav>
```

- Now render this `navbar` in `app/views/layouts/application.html.erb` . Add `<%= render 'layouts/navbar' %>` in application layout `<body>` as follows.

```
<body>
    <%= render 'layouts/navbar' %>
    <div class="container">
     <%= yield %>
    </div>
    ..
    ..
</body>
```

## Add Course status Select option

We have `status` field in `Course` Model. Now we want this to have only 3 values for this.
- Upcoming - use this status if u are yet to start the course and it is on your wishlist.
- In Progress - use this status if u are currently doing the course.
- Completed - use this status if u already completed the course.

Open `app/views/courses/_form.html.erb` and update `status` field to the following.
```
  <div class="field">
    <%= form.label :status %>
    <%= form.select :status , ['Upcoming','In Progress','Completed']%>
  </div>
```

After adding this your create form will look like this [`http://localhost:3000/courses/new`](http://localhost:3000/courses/new)


![create-course.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1622122192074/Stf2MiF-B.png)


## Styling Course Forms

Now we will add styling to our Course Index, Create, Edit forms.

### 1. Add Styles to Edit/Create Form

- Change `app/views/courses/_form.html.erb` to the following html.

```
<%= form_with(model: course, local: true) do |form| %>
  <% if course.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(course.errors.count, "error") %> prohibited this course from being saved:</h2>

      <ul>
      <% course.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= form.label :title %>
    <%= form.text_field :title, class: "form-control" %>
  </div>

  <div class="field">
    <%= form.label :image_url %>
    <%= form.text_field :image_url, class: "form-control" %>
  </div>

  <div class="field">
    <%= form.label :url %>
    <%= form.text_field :url, class: "form-control" %>
  </div>

  <div class="field">
    <%= form.label :status %>
    <%= form.select :status , ['Upcoming','In Progress','Completed'], class: "form-select"%>
  </div>

  <div class="field">
    <%= form.label :started %>
    <%= form.datetime_select :started, class: "form-control" %>
  </div>

  <div class="field">
    <%= form.label :completed %>
    <%= form.datetime_select :completed, class: "form-control" %>
  </div>

  <div class="actions">
    <%= form.submit 'Submit', class: "btn btn-primary"  %>
  </div>
<% end %>

```

- Change `app/views/courses/edit.html.erb` to the following html.

```
<h1>Edit Course</h1>

<%= render 'form', course: @course %>

<br/>
<%= link_to 'Show', @course , class: "btn btn-primary active" %> 
<%= link_to 'Back', courses_path , class: "btn btn-primary active" %>

```

After styling, Edit Course Form Looks like this.


![edit-course.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1622123120031/xHdtyKCBO.png)

### 2. Add Styles to Show Form

- Add `can_show_started?` and `can_show_completed?` methods in `app/models/course.rb`. These methods will be useful to show `started` and `completed` timestamps based on the `status`.

```
class Course < ApplicationRecord

    def can_show_started?
        self.status.eql?("In Progress") || self.status.eql?("Completed")
    end

    def can_show_completed?
        self.status.eql?("Completed")
    end
end
```

- Change `app/views/courses/show.html.erb` to the following html.

```
<p id="notice"><%= notice %></p>

<br/> <br/>

<div class="card w-50">
  <div class="card-header">
    <h3> <%= @course.title %> <h3>
  </div>
  <div class="card-body">
    <img src="<%= @course.image_url %>"/>

    <h5 class="card-title"><strong>Status : </strong> <%= @course.status %></h5>

    <% if @course.can_show_started? %>
      <h5 class="card-title"><strong>Started : </strong><%= @course.started %></h5>
    <% end %>

    <% if @course.can_show_completed? %>
      <h5 class="card-title"><strong>Completed : </strong><%= @course.completed %></h5>
    <% end %>

    <a href="<%= @course.url %>" class="btn btn-primary active">Go To Course</a>
  </div>
</div>

<br/> <br/>
<%= link_to 'Edit', edit_course_path(@course) , class: "btn btn-primary active"%>
<%= link_to 'Back', courses_path , class: "btn btn-primary active"%>

```

After styling, Show Course Form Looks like this.



![show-course.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1622128310863/zQvn8Cdzv.png)


### 3. Add Styles to the courses List page

- Now we reached the final stage of our project. We just need to style our Home page. i.e Courses Listing Page.

- Create new file `app/views/courses/_card_section_title.html.erb` with the following html.

```
<div class="row">
    <div class="card border-light">
      <div class="card-body">
        <h3 class="card-title text-primary"><%= section %></h3>
      </div>
    </div>
</div>
<br/>
```

- Create new file `app/views/courses/_course_cards.html.erb` with the following html.

```
<div class="row row-cols-1 row-cols-md-4 g-4">
  <% courses.each do |course| %>
    <div class="card border-dark">
      <img src="<%= course.image_url %>" class="card-img-top" alt="<%= course.title %>">
      <div class="card-body">
        <h5 class="card-title"><a href="<%= course.url%>"><%= course.title %></a></h5>
      </div>
      <ul class="list-group list-group-flush">
        <h4 class="list-group-item"><strong><%= course.status %><strong></h4>
        <% if course.can_show_started? %>
          <li class="list-group-item"><strong>Started : </strong><%= course.started.strftime('%d-%b-%Y') %></li>
        <% end %>

        <% if course.can_show_completed? %>
          <li class="list-group-item"><strong>Completed : </strong><%= course.completed.strftime('%d-%b-%Y') %></li>
        <% end %>
      </ul>
      <div class="card-body">
        <%= link_to 'Show', course, class: "card-link" %>
        <%= link_to 'Edit', edit_course_path(course) , class: "card-link"%>
        <%= link_to 'Delete', course, method: :delete, data: { confirm: 'Are you sure?' }, class: "card-link" %>

      </div>
    </div>
  <% end %>
</div>

<br/>
```

- Update `app/controllers/courses_controller.rb` to return Courses filtered by status

```
  def index
    @upcoming_courses = Course.all.select {|c| c.status.eql?("Upcoming")}
    @completed_courses = Course.all.select {|c| c.status.eql?("Completed")}
    @inprogress_courses = Course.all.select {|c| c.status.eql?("In Progress")}
  end

```

- Update file `app/views/courses/index.html.erb` to the following html.

```
<p id="notice"><%= notice %></p>

<% if @upcoming_courses.length > 0 %>
  <%= render 'courses/card_section_title', section: "Upcoming Courses" %>
  <%= render 'courses/course_cards', courses: @upcoming_courses %>
<% end %>

<% if @inprogress_courses.length > 0 %>
  <%= render 'courses/card_section_title', section: "Inprogress Courses" %>
  <%= render 'courses/course_cards', courses: @inprogress_courses %>
<% end %>

<% if @completed_courses.length > 0 %>
  <%= render 'courses/card_section_title', section: "Completed Courses" %>
  <%= render 'courses/course_cards', courses: @completed_courses %>
<% end %>


<br>

<%= link_to 'New Course', new_course_path , class: "btn btn-primary active"%>
```

- Add `Create New Course` link in navigation bar `app/views/layouts/_navbar.html.erb`

```
<nav class="navbar navbar-expand-lg  navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">Course Tracker</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
      <div class="navbar-nav">
        <a class="nav-link active" aria-current="page" href="/courses">Courses</a>
        <a class="nav-link active" aria-current="page" href="/courses/new">New Course</a>
      </div>
    </div>
  </div>
</nav>
```

- After Styling Courses Index Page, It finally looks like this :)


![fullpage.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1622128168272/ztuLhuXRO.png)

This is a long tutorial to follow. Hope you enjoyed this ...!!
If you like this, please give star for this Github repository.


<hr>

## Thank you for reading
Hope you find these resources useful. If you like what you read and want to see more about system design, microservices, and other technology-related stuff... You can follow me on 

- #### Twitter - <a href="https://twitter.com/vishnuchi?ref_src=twsrc%5Etfw" class="twitter-follow-button" data-size="large" data-show-count="false">Follow @vishnuchi</a>
- #### Subscribe to my weekly newsletter [here](https://www.getrevue.co/profile/vishnuch).

<hr>
<a href="https://www.buymeacoffee.com/vishnuchi" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 20px !important;width: 100px !important;" ></a>
