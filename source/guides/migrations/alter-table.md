---
title: Lotus - Guides - Migrations Alter Tables
---

# Migrations

## Alter Tables

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

Those methods accept the **name of the target table as first argument**, then the other args.
There is a convenient shortcut for this: `#alter_table`. It accepts the **name of the table** and a **block** that describes the alterations.

The following syntaxes are **equivalent**.

```ruby
Lotus::Model.migration do
  change do
    add_column         :users, :email, String,  null: false, unique: true
    set_column_default :users, :visits_counts, default: 0
  end
end
```

The code above can be DRY'd with:

```ruby
Lotus::Model.migration do
  change do
    alter_table :users do
      # `users` table is implicit within this block, so it can be omitted.
      add_column :email, String,  null: false, unique: true    
      set_column_default :visits_counts, default: 0
    end
  end
end
```

### Rename Table

Tables can be renamed via `#rename_table`. It accepts the **old name** and the **new name** as arguments.

```ruby
rename_table :users, :people
```

### Drop Table

Tables can be dropped via `#drop_table`. It accepts the **name** as argument.

```ruby
drop_table :users
```

Safe operation can be performed via `#drop_table?`. It drops the table only if it exists.
