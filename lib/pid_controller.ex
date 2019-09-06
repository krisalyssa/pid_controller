defmodule PidController do
  @moduledoc """
  Documentation for PidController.

  ## Controller action

  By default, the controller will produce a direct control action, meaning that
  an increasing error term will result in an increasing control value.
  If the controller action is set to `:reverse`, an increasing error term
  will result in a _decreasing_ control value. (This is generally needed only
  if the element being controlled, such as a valve, requires it.)
  """

  @type controller_action :: :direct | :reverse
  @type state :: %{required(atom()) => any()}

  @doc ~S"""
  Create a new instance.
  """
  @spec new(keyword()) :: state()
  def new(initial_values \\ []) do
    %{
      setpoint: 0.0,
      kp: 0.0,
      ki: 0.0,
      kd: 0.0,
      action: :direct,
      output_limits: {nil, nil},

      # used internally; not subject to changing by the user
      error_sum: 0.0,
      last_input: 0.0
    }
    |> set_setpoint(Keyword.get(initial_values, :setpoint))
    |> set_kp(Keyword.get(initial_values, :kp))
    |> set_ki(Keyword.get(initial_values, :ki))
    |> set_kd(Keyword.get(initial_values, :kd))
    |> set_action(Keyword.get(initial_values, :action))
    |> set_output_limits(Keyword.get(initial_values, :output_limits))
  end

  @doc ~S"""
  Returns the current setpoint for the controller.
  """
  @spec setpoint(state()) :: float()
  def setpoint(state), do: state.setpoint

  @doc ~S"""
  Returns the proportional coefficient (Kp) for the controller.
  """
  @spec kp(state()) :: float()
  def kp(state), do: state.kp

  @doc ~S"""
  Returns the integral coefficient (Ki) for the controller.
  """
  @spec ki(state()) :: float()
  def ki(state), do: state.ki

  @doc ~S"""
  Returns the derivative coefficient (Kd) for the controller.
  """
  @spec kd(state()) :: float()
  def kd(state), do: state.kd

  @doc ~S"""
  Returns the controller action (direct or reverse).
  """
  @spec action(state()) :: controller_action()
  def action(state), do: state.action

  @doc ~S"""
  Returns the range to which the output will be limited, in the form
  `{min, max}`. If either value is `nil`, the range is unbounded at that end.
  """
  @spec output_limits(state()) :: {float() | nil, float() | nil}
  def output_limits(state), do: state.output_limits

  @doc ~S"""
  Sets the setpoint for the controller. Returns the new state.
  """
  @spec set_setpoint(state(), float() | nil) :: state()
  def set_setpoint(state, nil), do: state
  def set_setpoint(state, new_setpoint), do: %{state | setpoint: new_setpoint}

  @doc ~S"""
  Sets the proportional coefficient (Kp) for the controller. Returns the new state.
  """
  @spec set_kp(state(), float() | nil) :: state()
  def set_kp(state, nil), do: state
  def set_kp(state, new_kp), do: %{state | kp: new_kp}

  @doc ~S"""
  Sets the integral coefficient (Ki) for the controller. Returns the new state.
  """
  @spec set_ki(state(), float() | nil) :: state()
  def set_ki(state, nil), do: state
  def set_ki(state, new_ki), do: %{state | ki: new_ki}

  @doc ~S"""
  Sets the derivative coefficient (Kd) for the controller. Returns the new state.
  """
  @spec set_kd(state(), float() | nil) :: state()
  def set_kd(state, nil), do: state
  def set_kd(state, new_kd), do: %{state | kd: new_kd}

  @doc ~S"""
  Sets the controller action. Returns the new state.
  """
  @spec set_action(state(), controller_action()) :: state()
  def set_action(state, new_action) when new_action in [:direct, :reverse],
    do: %{state | action: new_action}

  def set_action(state, _), do: state

  @doc ~S"""
  Sets the range to which the output will be limited, in the form
  `{min, max}`. If either value is `nil`, the output will not be limited
  in that direction.
  """
  @spec set_output_limits(state(), {float() | nil, float() | nil}) :: state()
  def set_output_limits(state, {nil, nil} = new_output_limits),
    do: %{state | output_limits: new_output_limits}

  def set_output_limits(state, {nil, new_max} = new_output_limits)
      when is_float(new_max),
      do: %{state | output_limits: new_output_limits}

  def set_output_limits(state, {new_min, nil} = new_output_limits)
      when is_float(new_min),
      do: %{state | output_limits: new_output_limits}

  def set_output_limits(state, {new_min, new_max} = new_output_limits)
      when is_float(new_min) and is_float(new_max),
      do: %{state | output_limits: new_output_limits}

  def set_output_limits(state, _), do: state

  @doc ~S"""
  Performs the PID calculation.

  Returns {:ok, new_output, state}.
  """
  @spec compute(float(), state()) :: {:ok, float(), state()}
  def compute(input, state) do
    {output, state} = compute_output(input, state)
    {:ok, output, state}
  end

  defp action_multiplier(:direct), do: 1.0
  defp action_multiplier(:reverse), do: -1.0

  defp clamp(value, %{output_limits: {nil, nil}}), do: value
  defp clamp(value, %{output_limits: {nil, max}}) when value <= max, do: value
  defp clamp(value, %{output_limits: {min, nil}}) when value >= min, do: value
  defp clamp(value, %{output_limits: {min, _}}) when value < min, do: min
  defp clamp(value, %{output_limits: {_, max}}) when value > max, do: max

  defp compute_output(input, state) do
    error = state.setpoint - input

    p_term = state.kp * action_multiplier(state.action) * error
    i_term = state.ki * action_multiplier(state.action) * (state.error_sum + error)
    d_term = state.kd * action_multiplier(state.action) * (input - state.last_input)

    output = clamp(p_term + i_term + d_term, state)

    {output, %{state | last_input: input, error_sum: clamp(state.error_sum + error, state)}}
  end
end
