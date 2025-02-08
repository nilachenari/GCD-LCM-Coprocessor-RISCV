module WDSel(input  logic [31:0] WDCop, WriteData,
           input  logic sel, // 1 if cop
           output logic [31:0] WDFinal);
  assign WDFinal = (sel == 1) ? WDCop : WriteData;
endmodule 