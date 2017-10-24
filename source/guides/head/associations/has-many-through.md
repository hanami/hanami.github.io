---
title: "Guides - Associations: Has Many Through"
version: head
---

# Has Many Through

Also known as _many-to-many_, is an association between an entity (`Story`) and a collection of many entities (`User`), passing via an intermediate entity (`Comment`).

## Setup

```shell
% bundle exec hanami generate model user
      create  lib/bookshelf/entities/user.rb
      create  lib/bookshelf/repositories/user_repository.rb
      create  db/migrations/20171024083639_create_users.rb
      create  spec/bookshelf/entities/user_spec.rb
      create  spec/bookshelf/repositories/user_repository_spec.rb

% bundle exec hanami generate model story
      create  lib/bookshelf/entities/story.rb
      create  lib/bookshelf/repositories/story_repository.rb
      create  db/migrations/20171024085712_create_stories.rb
      create  spec/bookshelf/entities/story_spec.rb
      create  spec/bookshelf/repositories/story_repository_spec.rb

% bundle exec hanami generate model comment
      create  lib/bookshelf/entities/comment.rb
      create  lib/bookshelf/repositories/comment_repository.rb
      create  db/migrations/20171024085858_create_comments.rb
      create  spec/bookshelf/entities/comment_spec.rb
      create  spec/bookshelf/repositories/comment_repository_spec.rb
```

Edit the migrations:

```ruby
# db/migrations/20171024083639_create_users.rb
Hanami::Model.migration do
  change do
    create_table :users do
      primary_key :id

      column :name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

```ruby
# db/migrations/20171024085712_create_stories.rb
Hanami::Model.migration do
  change do
    create_table :stories do
      primary_key :id

      foreign_key :user_id, :users, null: false, on_delete: :cascade

      column :text, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

```ruby
# db/migrations/20171024085858_create_comments.rb
Hanami::Model.migration do
  change do
    create_table :comments do
      primary_key :id

      foreign_key :user_id,  :users,   null: false, on_delete: :cascade
      foreign_key :story_id, :stories, null: false, on_delete: :cascade

      column :text, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
```

Now we can prepare the database:

```shell
% bundle exec hanami db prepare
```

## Usage

### Basic usage

Let's edit the repositories:

```ruby
# lib/bookshelf/repositories/user_repository.rb
class UserRepository < Hanami::Repository
  associations do
    has_many :stories
    has_many :comments
  end
end
```

```ruby
# lib/bookshelf/repositories/story_repository.rb
class StoryRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :comments
    has_many :users, through: :comments
  end

  def find_with_comments(id)
    aggregate(:user, comments: :user).where(id: id).map_to(Story).one
  end

  def find_with_commenters(id)
    aggregate(:users).where(id: id).map_to(Story).one
  end
end
```

```ruby
# lib/bookshelf/repositories/comment_repository.rb
class CommentRepository < Hanami::Repository
  associations do
    belongs_to :story
    belongs_to :user
  end
end
```

We have defined [explicit methods](/guides/head/associations/overview#explicit-interface) only for the operations that we need for our model domain.
In this way, we avoid to bloat `StoryRepository` with dozen of unneeded methods.

Let's create a couple of users, a story, then a comment:

```ruby
users = UserRepository.new
author = users.create(name: "Luca")
  # => #<User:0x00007ffe71bc3b18 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 09:06:57 UTC, :updated_at=>2017-10-24 09:06:57 UTC}>

commenter = users.create(name: "Maria G")
  # => #<User:0x00007ffe71bb3010 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>
```

```ruby
stories = StoryRepository.new

story = stories.create(user_id: author.id, text: "Hello, folks")
  # => #<Story:0x00007ffe71b4ace0 @attributes={:id=>1, :user_id=>1, :text=>"Hello folks", :created_at=>2017-10-24 09:09:59 UTC, :updated_at=>2017-10-24 09:09:59 UTC}>
```

```ruby
comments = CommentRepository.new

comment = comments.create(user_id: commenter.id, story_id: story.id, text: "Hi and welcome!")
  # => #<Comment:0x00007ffe71af9598 @attributes={:id=>1, :user_id=>2, :story_id=>1, :text=>"Hi and welcome!", :created_at=>2017-10-24 09:12:30 UTC, :updated_at=>2017-10-24 09:12:30 UTC}>
```

What happens if we load the user with `StoryRepository#find`?

```ruby
story = stories.find(story.id)
  # => #<Story:0x00007ffe71ae2cd0 @attributes={:id=>1, :user_id=>1, :text=>"Hello folks", :created_at=>2017-10-24 09:09:59 UTC, :updated_at=>2017-10-24 09:09:59 UTC}>

story.comments
  # => nil
```

Because we haven't [explicitly loaded](/guides/head/associations/overview#explicit-loading) the associated records `story.comments` is `nil`.
We can use the method that we have defined on before (`#find_with_comments`):

```ruby
story = stories.new.find_with_comments(story.id)
  # => #<Story:0x00007fd45e327e60 @attributes={:id=>2, :user_id=>1, :text=>"Hello folks", :created_at=>2017-10-24 09:09:59 UTC, :updated_at=>2017-10-24 09:09:59 UTC, :user=>#<User:0x00007fd45e326bc8 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 09:06:57 UTC, :updated_at=>2017-10-24 09:06:57 UTC}>, :comments=>[#<Comment:0x00007fd45e325930 @attributes={:id=>1, :user_id=>2, :story_id=>2, :text=>"Hi and welcome!", :created_at=>2017-10-24 09:12:30 UTC, :updated_at=>2017-10-24 09:12:30 UTC, :user=>#<User:0x00007fd45e324490 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>}>]}>

story.comments
  # => [#<Comment:0x00007fd45e325930 @attributes={:id=>1, :user_id=>2, :story_id=>2, :text=>"Hi and welcome!", :created_at=>2017-10-24 09:12:30 UTC, :updated_at=>2017-10-24 09:12:30 UTC, :user=>#<User:0x00007fd45e324490 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>}>]

story.comments.map(&:user)
  # => [#<User:0x00007fd45e324490 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>]
```

This time `story.comments` has the associated records.

Similarly, we can find directly the associated commenters:

```ruby
story = stories.find_with_commenters(story.id)
  # => #<Story:0x00007f8e28b79d88 @attributes={:id=>2, :user_id=>1, :text=>"Hello folks", :created_at=>2017-10-24 09:09:59 UTC, :updated_at=>2017-10-24 09:09:59 UTC, :users=>[#<User:0x00007f8e28b78b40 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>]}>

story.users
  # => [#<User:0x00007f8e28b78b40 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>]
```

### Aliasing

In the examples above `story.users` was the way to go, because of the Hanami conventions, but that isn't a great name for an association.
We can alias `users` with something more meaningful like `commenters`:

```ruby
# lib/bookshelf/repositories/story_repository.rb
class StoryRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :comments
    has_many :users, through: :comments, as: :commenters
  end

  def find_with_comments(id)
    aggregate(:user, comments: :commenter).where(id: id).map_to(Story).one
  end
end
```

```ruby
# lib/bookshelf/repositories/comment_repository.rb
class CommentRepository < Hanami::Repository
  associations do
    belongs_to :story
    belongs_to :user, as: :commenter
  end
end
```

```ruby
story = stories.find_with_comments(2)
  # => #<Story:0x00007fe289f2f800 @attributes={:id=>2, :user_id=>1, :text=>"Hello folks", :created_at=>2017-10-24 09:09:59 UTC, :updated_at=>2017-10-24 09:09:59 UTC, :user=>#<User:0x00007fe289f2e810 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 09:06:57 UTC, :updated_at=>2017-10-24 09:06:57 UTC}>, :comments=>[#<Comment:0x00007fe289f2d618 @attributes={:id=>1, :user_id=>2, :story_id=>2, :text=>"Hi and welcome!", :created_at=>2017-10-24 09:12:30 UTC, :updated_at=>2017-10-24 09:12:30 UTC, :commenter=>#<User:0x00007fe289f2c420 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>}>]}>

story.comments
  # => [#<Comment:0x00007fe289f2d618 @attributes={:id=>1, :user_id=>2, :story_id=>2, :text=>"Hi and welcome!", :created_at=>2017-10-24 09:12:30 UTC, :updated_at=>2017-10-24 09:12:30 UTC, :commenter=>#<User:0x00007fe289f2c420 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>}>]

story.comments.map(&:commenter)
  # => [#<User:0x00007fe289f2c420 @attributes={:id=>2, :name=>"Maria G", :created_at=>2017-10-24 09:07:16 UTC, :updated_at=>2017-10-24 09:07:16 UTC}>]
```
