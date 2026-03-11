`timescale 1ns / 1ps

module fullAdderMultiplexer(
    input A,
    input B,
    input Cin,
    output S,
    output Co
    );
    
    assign I0S = Cin;
    assign I1S = ~Cin;
    assign I2S = ~Cin;
    assign I3S = Cin;
    
    assign I0Co = 1'b0;
    assign I1Co = Cin;
    assign I2Co = Cin;
    assign I3Co = 1'b1;
    
    fourToOneMultiplexer Sum(A,B,I0S,I1S,I2S,I3S,1'b1,S);
    fourToOneMultiplexer Cout(A,B,I0Co,I1Co,I2Co,I3Co,1'b1,Co);
endmodule
