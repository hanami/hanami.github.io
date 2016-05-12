---
title: "Guides - Command Line: Custom Commands"
---

# Command Line

## Custom Commands

Hanami provide simple way to create custom CLI commands. For this you need to use `custom_commands` class method for specific class.

For exapmle this code will add new `custom` command:

``` ruby
Hanami::Cli.custom_commands do
  desc 'custom', 'Empty command'
  def custom
    puts 'custom command'
  end
end
```

And this code will add new `custom` generator:

``` ruby
Hanami::CliSubCommands::Generate.custom_commands do
  desc 'custom', 'Empty command'
  def custom
    puts 'custom command'
  end
end
```
