---
title: "Guides - Repositories: PostgreSQL"
version: 1.3
---

# PostgreSQL

Hanami natively supports PostgreSQL data types.

Please check your PostgreSQL version for the available features.

## UUID

Here's how to use UUID for a column:

```ruby
# db/migrations/20161113184557_create_projects.rb
Hanami::Model.migration do
  up do
    execute 'CREATE EXTENSION IF NOT EXISTS "pgcrypto"'

    create_table :projects do
      primary_key :id
      column :name,  String
      column :token, 'uuid'
    end
  end

  down do
    drop_table :projects
    execute 'DROP EXTENSION IF EXISTS "pgcrypto"'
  end
end
```

```ruby
require "securerandom"

ProjectRepository.new.create(name: "Hanami", token: SecureRandom.uuid)
  # => #<Project:0x007fbbc78f0a40 @attributes={:id=>1, :name=>"Hanami", :token=>"0aa7ecff-15e4-4aa4-8c00-0e699e2c66f0"}>
```

### UUID as Primary Key

```ruby
Hanami::Model.migration do
  up do
    execute 'CREATE EXTENSION IF NOT EXISTS "pgcrypto"'

    create_table :project_files do
      primary_key :id, 'uuid', null: false, default: Hanami::Model::Sql.function(:gen_random_uuid)
      column :name, String
    end
  end

  down do
    drop_table :project_files
    execute 'DROP EXTENSION IF EXISTS "pgcrypto"'
  end
end
```

```ruby
ProjectFileRepository.new.create(name: "source.rb")
  # => #<ProjectFile:0x007ff29c4b9740 @attributes={:id=>"239f8e0f-d764-4a76-aaa7-7b59b5301c72", :name=>"source.rb"}>
```

## Array

```ruby
Hanami::Model.migration do
  change do
    create_table :articles do
      primary_key :id
      column :title, String
      column :tags, "text[]"
    end
  end
end
```

```ruby
ArticleRepository.new.create(title: "Announcing Hanami 1.0", tags: ["announcements"])
  # => #<Article:0x007ffe1a5d9da8 @attributes={:id=>1, :title=>"Announcing Hanami 1.0", :tags=>["announcements"]}>
```

## JSON(B)

```ruby
Hanami::Model.migration do
  change do
    create_table :commits do
      primary_key       :id
      column :metadata, "jsonb"
    end
  end
end
```

```ruby
CommitRepository.new.create(metadata: { sha: "8775b81" })
  # => #<Commit:0x007f8573dcbbf8 @attributes={:id=>1, :metadata=>{:sha=>"8775b81"}}>
```
