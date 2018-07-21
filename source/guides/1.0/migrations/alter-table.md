---
title: Guides - Migrations Alter Tables
version: 1.0
---

# Alter Tables

The following methods are available for table alterations:

  * `#add_column` (see `#column` for usage)
  * `#drop_column`
  * `#rename_column` (the first argument is the **old name**, while the second is the **new name**)
  * `#add_index` (see `#index` for usage)
  * `#drop_index`
  * `#add_primary_key` (see `#primary_key` for usage)
  * `#add_foreign_key` (see `#foreign_key` for usage)
  * `#add_constraint` (see `#constraint` for usage)
  * `#drop_constraint` (accepts the **name** of the constraint as argument)
  * `#add_unique_constraint`
  * `#set_column_default` (accepts the **name** of the column and the **default value** as comma separated args)
  * `#set_column_type` (accepts the **name** of the column and the **new type** as comma separated args)
  * `#set_column_allow_null` (accepts the **name** of the column)
  * `#set_column_not_null` (accepts the **name** of the column)

```ruby
Hanami::Model.migration do
  change do
    alter_table :users do
      # `users` table is implicit within this block, so it can be omitted.
      add_column :email, String,  null: false, unique: true
      set_column_default :visits_counts, default: 0
    end
  end
end
```

Some methods can be used without `alter_table` block. Those methods **accept the name of the target table as first argument**, then the other args.

```ruby
add_index :users, :email
#instead of
alter_table(:users) do
  add_index :email
end
```

 List of available methods which are shortcuts to the same methods in `alter_table`:

  * `#add_column`
  * `#drop_column`
  * `#rename_column`
  * `#add_index`
  * `#drop_index`
  * `#set_column_default`
  * `#set_column_type`

## Rename Table

Tables can be renamed via `#rename_table`. It accepts the **old name** and the **new name** as arguments.

```ruby
rename_table :users, :people
```

## Drop Table

Tables can be dropped via `#drop_table`. It accepts the **name** as argument.

```ruby
drop_table :users
```

Safe operation can be performed via `#drop_table?`. It drops the table only if it exists.
