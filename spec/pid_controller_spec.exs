defmodule PidController.Spec do
  @moduledoc false

  use ESpec

  doctest PidController

  example_group "getters and setters" do
    before do
      controller =
        PidController.new(
          setpoint: 1.0,
          kp: 2.0,
          ki: 3.0,
          kd: 3.5,
          action: :reverse,
          sample_period: 500,
          output_limits: {0.0, 10.0}
        )

      {:shared, controller: controller}
    end

    context "successes" do
      it "should get and set properties" do
        expect(PidController.setpoint(shared.controller)) |> to(eq(1.0))
        expect(PidController.kp(shared.controller)) |> to(eq(2.0))
        expect(PidController.ki(shared.controller)) |> to(eq(3.0))
        expect(PidController.kd(shared.controller)) |> to(eq(3.5))
        expect(PidController.action(shared.controller)) |> to(eq(:reverse))
        expect(PidController.output_limits(shared.controller)) |> to(eq({0.0, 10.0}))
      end
    end

    context "failures" do
      it "should reject invalid action values" do
        expect(
          PidController.set_action(shared.controller, :direct)
          |> PidController.set_action(:foo)
          |> PidController.action()
        )
        |> to(eq(:direct))

        expect(
          PidController.set_action(shared.controller, :reverse)
          |> PidController.set_action(:bar)
          |> PidController.action()
        )
        |> to(eq(:reverse))
      end
    end
  end

  example_group "controller response" do
    context "when :direct" do
      context "for P" do
        before do
          controller =
            PidController.new(
              setpoint: 5.0,
              kp: 0.2
            )

          {:shared, controller: controller}
        end

        it "converges" do
          {_, steps, _} =
            Enum.reduce(1..10, {0.0, [], shared.controller}, fn _,
                                                                {input_value, intermediate_values,
                                                                 state} ->
              {:ok, output_value, new_state} = PidController.compute(input_value, state)
              next_input_value = input_value + output_value
              {next_input_value, [intermediate_values | [next_input_value]], new_state}
            end)

          steps
          |> List.flatten()
          |> Enum.map(&Float.round(&1, 2))
          |> expect()
          |> to(eq([1.0, 1.8, 2.44, 2.95, 3.36, 3.69, 3.95, 4.16, 4.33, 4.46]))
        end
      end

      context "for PI" do
        before do
          controller =
            PidController.new(
              setpoint: 5.0,
              kp: 0.2,
              ki: 0.1,
              action: :direct
            )

          {:shared, controller: controller}
        end

        it "converges" do
          {_, steps, _} =
            Enum.reduce(1..10, {0.0, [], shared.controller}, fn _,
                                                                {input_value, intermediate_values,
                                                                 state} ->
              {:ok, output_value, new_state} = PidController.compute(input_value, state)
              next_input_value = input_value + output_value
              {next_input_value, [intermediate_values | [next_input_value]], new_state}
            end)

          steps
          |> List.flatten()
          |> Enum.map(&Float.round(&1, 2))
          |> expect()
          |> to(eq([1.5, 3.05, 4.49, 5.68, 6.58, 7.13, 7.36, 7.31, 7.04, 6.62]))
        end
      end
    end

    context "when :reverse" do
      context "for P" do
        before do
          controller =
            PidController.new(
              setpoint: 5.0,
              kp: 0.2,
              action: :reverse
            )

          {:shared, controller: controller}
        end

        it "converges" do
          {_, steps, _} =
            Enum.reduce(1..10, {0.0, [], shared.controller}, fn _,
                                                                {input_value, intermediate_values,
                                                                 state} ->
              {:ok, output_value, new_state} = PidController.compute(input_value, state)
              next_input_value = input_value - output_value
              {next_input_value, [intermediate_values | [next_input_value]], new_state}
            end)

          steps
          |> List.flatten()
          |> Enum.map(&Float.round(&1, 2))
          |> expect()
          |> to(eq([1.0, 1.8, 2.44, 2.95, 3.36, 3.69, 3.95, 4.16, 4.33, 4.46]))
        end
      end

      context "for PI" do
        before do
          controller =
            PidController.new(
              setpoint: 5.0,
              kp: 0.2,
              ki: 0.1,
              action: :reverse
            )

          {:shared, controller: controller}
        end

        it "converges" do
          {_, steps, _} =
            Enum.reduce(1..10, {0.0, [], shared.controller}, fn _,
                                                                {input_value, intermediate_values,
                                                                 state} ->
              {:ok, output_value, new_state} = PidController.compute(input_value, state)
              next_input_value = input_value - output_value
              {next_input_value, [intermediate_values | [next_input_value]], new_state}
            end)

          steps
          |> List.flatten()
          |> Enum.map(&Float.round(&1, 2))
          |> expect()
          |> to(eq([1.5, 3.05, 4.49, 5.68, 6.58, 7.13, 7.36, 7.31, 7.04, 6.62]))
        end
      end
    end
  end
end
