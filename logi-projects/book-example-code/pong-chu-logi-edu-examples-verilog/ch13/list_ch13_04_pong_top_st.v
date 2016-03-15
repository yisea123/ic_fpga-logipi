// Listing 13.4
module pong_top_st
   (
    input wire clk, reset_n,
    output wire hsync, vsync,
    output wire [2:0] red, green, blue
   );

   // signal declaration
   wire [9:0] pixel_x, pixel_y;
   wire video_on, pixel_tick;
   reg [2:0] rgb_reg;
   wire [2:0] rgb_next;
	wire reset;
	
	assign reset = ~reset_n;

   // body
   // instantiate vga sync circuit
   vga_sync vsync_unit
      (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
       .video_on(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
   // instantiate graphic generator
   pong_graph_st pong_grf_unit
      (.video_on(video_on), .pix_x(pixel_x), .pix_y(pixel_y),
       .graph_rgb(rgb_next));
   // rgb buffer
   always @(posedge clk)
      if (pixel_tick)
         rgb_reg <= rgb_next;
   // output
   assign red = (video_on && rgb_reg[0] == 1'b1) ? 3'b111 : 3'b000;
	assign green = (video_on && rgb_reg[1] == 1'b1) ? 3'b111 : 3'b000;
	assign blue = (video_on && rgb_reg[2] == 1'b1) ? 3'b111 : 3'b000;


endmodule
