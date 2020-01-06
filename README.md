# pid_controller

> A PID (proportional/integral/derivative) controller in Elixir.
> “PID” in this context is not to be confused with process ID.

[![CircleCI](https://img.shields.io/circleci/project/github/CraigCottingham/pid_controller.svg?style=flat)](https://circleci.com/gh/CraigCottingham/pid_controller)
[![Github open issues](https://img.shields.io/github/issues/CraigCottingham/pid_controller.svg?style=flat)](https://github.com/CraigCottingham/pid_controller/issues)
[![Github open PRs](https://img.shields.io/github/issues-pr/CraigCottingham/pid_controller.svg?style=flat)](https://github.com/CraigCottingham/pid_controller/pulls)
[![License](https://img.shields.io/github/license/CraigCottingham/pid_controller.svg)](https://github.com/CraigCottingham/pid_controller/blob/master/LICENSE)

## QUICK START

    controller =
      PidController.new(kp: 0.2, ki: 0.1)
      |> PidController.set_setpoint(5.0)

    # in a loop
    {:ok, output, controller} = PidController.output(input, controller)

## OVERVIEW

`PidController` implements a control loop-style feedback controller similar to
what is commonly found in industrial control systems. It takes a measured value
from the system under control (the _process value_ or _process variable_),
compares it to a _setpoint value_ to produce an _error term_, then generates a
_control value_ based on **p**roportional, **i**ntegral, and **d**erivative functions
of the error term. The control value is then fed back into the system under control.

For a full description of PID controllers and how they work, see
https://en.wikipedia.org/wiki/PID_controller.

While the proportional term is a function of the error value only, the integral
and derivative terms are also functions of time. The first iteration of
`PidController` acts as if the `output/2` function is being called at regular
and consistent intervals, even though in practice this is unlikely. A future version
will take into account the elapsed time between calls to `output/2`.

## AN INTRODUCTION

### What is “control theory”?

Simply put, control theory is the math used to control a system whose state
is a function of time. More precisely, we’re interested in controlling the system
such that it is _stable_ (none of the values which compose the state grow to
infinity) and that when disturbed returns to a steady state without excessive
oscillation or damping.

Control theory covers a broad range of possible systems, so we’ll limit ourselves
to closed-loop (or _feedback_) control of a single state variable of a linear system.

### You use big words. How are you with metaphors?

Okay. Every closed-loop controller is made up of several parts.

  * The **system** being controlled
  * An **input** to the system, to change its state
  * An **output** from the system, to be measured
  * A reference value (the **set point**) against which the output is compared
  * The **error signal** (the difference between the measured output and the set point)
  * The **controller**, which converts the error signal to the output fed back into the system

For the **system**, think of your residence&mdash;your house, apartment,
parents’ basement, yurt, whatever. There are lots of **state variables** which
describe the time-dependent state of the system (temperature, humidity,
air pressure, to name just three). The controller will control only one state variable;
We’ll call this one of interest the **process variable**.

We want to hold the temperature constant, so temperature is our **process variable**.
For the sake of the metaphor, assume that it’s winter where you are, so outside
of your residence is colder than the inside, so the temperature will drop over
time.

Some sensor, somewhere in your residence, measures the _current_ temperature. It is
compared to the _desired_ temperature (the **set point**); the difference between
the two is the **error value**.

## INSTALLATION

Add `pid_controller` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pid_controller, "~> 0.1.3"}
  ]
end
```

Don’t forget to run `mix deps.get` afterwards.

## USAGE

Documentation can be found at https://hexdocs.pm/pid_controller.

## CONTRIBUTING

  1. Clone the repository.
  2. Install dependencies with `mix deps.get`.

Pull requests are welcome. Pull requests with specs covering the changes
are especially welcome. Pull requests with specs, which have been run through
`mix format`, and pass `mix credo` are extra-especially welcome. :smile:

Unit tests were written with [ESpec](https://github.com/antonmi/espec).

## TO DO

See the [open issues on Github](https://github.com/CraigCottingham/pid_controller/issues).

## COPYRIGHT

Copyright (c) 2019-2020 Craig S. Cottingham, except where stated otherwise.

## LICENSE

Licensed under the Apache License, Version 2.0 (the “License”);
you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions
and limitations under the License.
