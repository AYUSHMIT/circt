circuit Blinky :
  module Blinky :
    input clock : Clock
    input reset : UInt<1>
    output io_led : UInt<1>

    reg cnt : UInt<25>, clock with :
      (reset => (reset, UInt<25>(0)))

    cnt <= add(cnt, UInt<25>(1))
    io_led <= bits(cnt, 24, 24)
