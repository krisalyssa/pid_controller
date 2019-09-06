# pid_controller

> A PID (proportional/integral/derivative) controller in Elixir.
> "PID" in this context is not to be confused with process ID.

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

## INSTALLATION

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pid_controller` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pid_controller, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pid_controller](https://hexdocs.pm/pid_controller).
