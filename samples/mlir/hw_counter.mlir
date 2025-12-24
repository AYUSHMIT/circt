// Minimal HW dialect example: a counter with an increment and an output bit.
hw.module @Counter(%clk: i1, %rst: i1) -> (led: i1) {
  %c0 = hw.constant 0 : i1
  %one = hw.constant 1 : i1

  // Pseudo state register (illustrative: real flows use FIRRTL/lowerings)
  %state = hw.instance "state_reg" @state_reg(%clk) : (i1) -> (q: i1)

  %inc = comb.add %state, %one : i1
  comb.if %rst {
    hw.instance "state_reg_wr" @state_reg_wr(%c0) : (i1) -> ()
  } else {
    hw.instance "state_reg_wr" @state_reg_wr(%inc) : (i1) -> ()
  }

  %ledbit = comb.and %state, %one : i1
  hw.output %ledbit : i1
}

// Stub declarations to keep the example self-contained.
hw.module.extern @state_reg(%clk: i1) -> (q: i1)
hw.module.extern @state_reg_wr(%d: i1)
