`timescale 1ns / 1ps

module fullAdderMultiplexer_tb();
    reg A,B,Cin;
    wire S,Co;
    
    fullAdderMultiplexer uut(A,B,Cin,S,Co);
    integer i;
    initial begin
        $display("A B Cin | S Co");
        $display("----------------");

        for(i = 0; i < 8; i = i + 1) begin
            {A,B,Cin} = i;
            #10;

            $display("%b %b  %b  | %b %b", A, B, Cin, S, Co);
        end
    end
endmodule
