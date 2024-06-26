//
module alu(input  logic [31:0] a, b,
           input  logic [2:0]  op,
           output logic [31:0] y,
           output logic        z);
  assign z = (y == 0) ? 1 : 0;

  always_comb
    case(op)
      3'b000:       y = a + b;
      3'b001:       y = a - b;
      3'b010:       y = a & b;
      3'b011:       y = a | b;
      3'b100:       y = a ^ b;
      3'b101:       y = (a < b) ? 1 : 0;
      default: y = 'x;
    endcase
endmodule