/*
TP3 - Ejercicio 1 - Control de la activación de dos bombas de agua.
Máquina de estados de Mealy.

NOTA: El clock en este circuito tiene un período grande de tal forma que cuando el evento (entrada)
sea I = 1 ^ S = 0, las bombas se alternan en su trabajo de forma moderada.
*/

`timescale 1ms/1ms

module Flip_Flop_D(clk,D,R,Q);
    input clk,D,R;
    output reg Q;

    always@(posedge clk) begin
        if(R) //reset
            Q <= 1'b0; //estado reseato.
        else
            Q <= D; //estado presente del FFD.
    end
endmodule

module Clock(clk);
    output reg clk;
    parameter P = 1000; //período del clock = 1s.

    always begin //funcionamiento del clock.
        clk <= 1'b0;
        #(P/2);
        clk <= 1'b1;
        #(P/2);
    end
endmodule

module Water_Pumps(clk,I,S,B1,B2); //bombas de agua.
    input clk,I,S;
    output B1,B2;
    reg R;
    wire Y,y;
    wire a,b,c,d,e,f; //cables de conexión.

    Flip_Flop_D FFD(clk,Y,R,y); //se incluyen los flip flops al circuito.

    //lógica del circuito.
    //Para la entrada al flip flop (Y).
    or(a,S,~I);
    and(b,y,a);
    and(c,~S,I,~y);
    or(Y,c,b);
    //para la salida B1.
    and(d,~y,~S);
    or(B1,d,~I);
    //para la salida B2.
    and(e,y,~S);
    or(B2,e,~I);    

    initial begin //se reseatan los flip flops.
        R <= 1'b1;
        #1000;
        R <= 1'b0;
    end
endmodule

module main;
    reg I,S;
    wire clk,B1,B2;

    Clock CLK(clk);
    Water_Pumps WP(clk,I,S,B1,B2);

    initial begin //se simula el cirucito.
        //ningún sensor activado.
        I <= 1'b0;
        S <= 1'b0;
        #5000;
        //sólo el sensor I está activado.
        I <= 1'b1;
        S <= 1'b0;
        #5000;
        //los dos sensores están activados.
        I <= 1'b1;
        S <= 1'b1;
        #5000;
        //sólo el sensor I está activado.
        I <= 1'b1;
        S <= 1'b0;
        #5000;
        //ningún sensor activado.
        I <= 1'b0;
        S <= 1'b0;
        #5000;
        $finish;
    end

    //código para simular el programa en GTKWave.
    reg dummy;
    reg[8*64:0] dumpfile_path = "output.vcd";
    
    initial begin
        dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
        $dumpfile(dumpfile_path);
        $dumpvars(0,main);
    end
endmodule