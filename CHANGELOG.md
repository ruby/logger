# HEAD

* Add thread-local log levels using `Logger#with_level` [#84](https://github.com/ruby/logger/issue/84)

# 1.4.2

* Document that shift_age of 0 disables log file rotation [#43](https://github.com/ruby/logger/pull/43) (thanks to jeremyevans)
* Raise ArgumentError for invalid shift_age [#42](https://github.com/ruby/logger/pull/42) (thanks to jeremyevans)
* Honor Logger#level overrides [#41](https://github.com/ruby/logger/pull/41) (thanks to georgeclaghorn)

# 1.4.1

Fixes:

* Add missing files in gem (thanks to hsbt)

# 1.4.0

Enhancements:

* Add support for changing severity using bang methods [#15](https://github.com/ruby/logger/pull/15) (thanks to ioquatix)
* Set filename when initializing logger with a File object to make reopen work  [#30](https://github.com/ruby/logger/pull/30) (thanks to jeremyevans)
* Add option to set the binary mode of the log device [#33](https://github.com/ruby/logger/pull/33) (thanks to refaelfranca)

Also, large refactorings of codes and testing libraries are introduced.
