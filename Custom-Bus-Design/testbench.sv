`timescale 1ns/1ps


module testbench();
	// Clock and Reset
	reg				clk;
	reg				rst;

	// Signals to request the master to initiate the transaction
	reg				wr_start;
	reg				rd_start;
	reg		[7:0]	wr_data;
	wire	[7:0]	rd_data;

	// Bus Interface Signals
	wire			m_req;
	wire			m_r0_w1;
	wire	[7:0]	m_wr_data;
	wire	[7:0]	m_rd_data;
	wire			m_done;
	wire			s_ack;
	wire			s_data_ack;
	reg		[7:0]	wr_addr;
	reg		[7:0]	rd_addr;

	always #5 clk = !clk;

	custom_bus_master	master_inst(.*);
	custom_bus_slave	slave_inst(.*);

	initial begin
		clk 		= 1'b0;
		rst 		= 1'b0;
		wr_start 	= 1'b0;
		rd_start 	= 1'b0;
		wr_data 	= 8'd0;
		wr_addr     = 8'd0;
		rd_addr     = 8'd0;

		#1;
		rst = 1'b1;

		#2;
		rst = 1'b0;
	end

	initial begin
		// Change the number of iterations depending on number of write requests from Master required
		repeat(5) begin
			@(posedge clk);
			write_req;
			wait(m_done == 1'b1);
			read_req;
			wait(m_done == 1'b1);
		end

		repeat(2) begin
			@(posedge clk);
			write_read_req;
			wait(m_done == 1'b1);
		end

		repeat(5) @(posedge clk);

		$finish();
	end

	task write_req;
		begin
			@(posedge clk);
			wr_start 	<= 1'b1;
			wr_data		<= $random;
			wr_addr     <= $random;
			@(posedge clk);
			wr_start	<= 1'b0;
			wr_data		<= 8'd0;
		end
	endtask

	task read_req;
		begin
			@(posedge clk);
			rd_start 	<= 1'b1;
			@(posedge clk);
			rd_start	<= 1'b0;
			rd_addr     <= $random;
		end
	endtask

	task write_read_req;
		begin
			@(posedge clk);
			wr_start 	<= 1'b1;
			rd_start 	<= 1'b1;
			wr_data		<= $random;
			wr_addr		<= $random;
			rd_addr		<= $random;

			@(posedge clk);
			wr_start	<= 1'b0;
			rd_start 	<= 1'b0;
			wr_data		<= 8'd0;
		end
	endtask

endmodule

