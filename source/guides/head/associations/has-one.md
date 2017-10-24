---
title: "Guides - Associations: Has One"
version: head
---

# Has One

Also known as _one-to-one_, is an association between an entity (`User`) associated to one child entity (`Avatar`).

## Setup

```shell
% bundle exec hanami generate model user
      create  lib/bookshelf/entities/user.rb
      create  lib/bookshelf/repositories/user_repository.rb
      create  db/migrations/20171024083639_create_users.rb
      create  spec/bookshelf/entities/user_spec.rb
      create  spec/bookshelf/repositories/user_repository_spec.rb

% bundle exec hanami generate model avatar
      create  lib/bookshelf/entities/avatar.rb
      create  lib/bookshelf/repositories/avatar_repository.rb
      create  db/migrations/20171024083725_create_avatars.rb
      create  spec/bookshelf/entities/avatar_spec.rb
      create  spec/bookshelf/repositories/avatar_repository_spec.rb
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
# db/migrations/20171024083725_create_avatars.rb
Hanami::Model.migration do
  change do
    create_table :avatars do
      primary_key :id

      foreign_key :user_id, :users, null: false, on_delete: :cascade

      column :url, String, null: false

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

Let's edit `UserRepository` with the following code:

```ruby
# lib/bookshelf/repositories/user_repository.rb
class UserRepository < Hanami::Repository
  associations do
    has_one :avatar
  end

  def create_with_avatar(data)
    assoc(:avatar).create(data)
  end

  def find_with_avatar(id)
    aggregate(:avatar).where(id: id).map_to(User).one
  end
end
```

We have defined [explicit methods](/guides/head/associations/overview#explicit-interface) only for the operations that we need for our model domain.
In this way, we avoid to bloat `UserRepository` with dozen of unneeded methods.

Let's create an user with an avatar **single database operation**:

```ruby
repository = UserRepository.new

user = repository.create_with_avatar(name: "Luca", avatar: { url: "https://avatars.test/luca.png" })
  # => #<User:0x00007fa166ac8550 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 08:44:27 UTC, :updated_at=>2017-10-24 08:44:27 UTC, :avatar=>#<Avatar:0x00007fa166ac35c8 @attributes={:id=>1, :user_id=>1, :url=>"https://avatars.test/luca.png", :created_at=>2017-10-24 08:44:27 UTC, :updated_at=>2017-10-24 08:44:27 UTC}>}>

user.id
  # => 1

user.name
  # => "Luca"

user.avatar
  # => #<Avatar:0x00007fa166ac35c8 @attributes={:id=>1, :user_id=>1, :url=>"https://avatars.test/luca.png", :created_at=>2017-10-24 08:44:27 UTC, :updated_at=>2017-10-24 08:44:27 UTC}>
```

What happens if we load the user with `UserRepository#find`?

```ruby
user = repository.find(user.id)
  # => #<User:0x00007fa166aa3a70 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 08:44:27 UTC, :updated_at=>2017-10-24 08:44:27 UTC}>
user.avatar
  # => nil
```

Because we haven't [explicitly loaded](/guides/head/associations/overview#explicit-loading) the associated record, `user.avar` is `nil`.
We can use the method that we have defined on before (`#find_with_avatar`):

```ruby
user = repository.find_with_avatar(user.id)
  # => #<User:0x00007fa166a71048 @attributes={:id=>1, :name=>"Luca", :created_at=>2017-10-24 08:44:27 UTC, :updated_at=>2017-10-24 08:44:27 UTC, :avatar=>#<Avatar:0x00007fa166a70328 @attributes={:id=>1, :user_id=>1, :url=>"https://avatars.test/luca.png", :created_at=>2017-10-24 08:44:27 UTC, :updated_at=>2017-10-24 08:44:27 UTC}>}>

user.avatar
  # => #<Avatar:0x00007fa166a70328 @attributes={:id=>1, :user_id=>1, :url=>"https://avatars.test/luca.png", :created_at=>2017-10-24 08:44:27 UTC, :updated_at=>2017-10-24 08:44:27 UTC}>
```

This time `user.avatar` has the associated avatar.

### Add, remove, update, and replace

You can perform operations to add, remove, update, and replace the avatar:

```ruby
# lib/bookshelf/repositories/user_repository.rb
class UserRepository < Hanami::Repository
  # ...

  def add_avatar(user, data)
    assoc(:avatar, user).add(data)
  end

  def remove_avatar(user)
    assoc(:avatar, user).delete
  end

  def update_avatar(user, data)
    assoc(:avatar, user).update(data)
  end

  def replace_avatar(user, data)
    assoc(:avatar, user).replace(data)
  end
end
```
