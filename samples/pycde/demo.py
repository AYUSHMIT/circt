# Minimal PyCDE demo that emits MLIR/SV
from pycde import Module, generator, types, App, Input, Output

class Adder(Module):
    a = Input(types.i32)
    b = Input(types.i32)
    y = Output(types.i32)

    @generator
    def construct(self):
        self.y = self.a + self.b

if __name__ == "__main__":
    app = App(Adder, name="pycde_adder")
    # Generate IRs and emit outputs into out/pycde
    app.generate()
    app.emit_outputs("out/pycde")
