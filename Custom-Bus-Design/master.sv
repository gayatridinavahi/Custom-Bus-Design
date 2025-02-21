`timescale 1ns/1ps


module custom_bus_master(
	// Clock and Reset
	input				clk,
	input				rst,

	// Signals to request the master to initiate the transaction
	input				wr_start,
	input				rd_start,
	input		[7:0]	wr_data,
	output	reg	[7:0]	rd_data,

	// Bus Interface Signals
	output	reg			m_req,
	output	reg			m_r0_w1,	// 0 - If Read, 1- If Write
	output	reg	[7:0]	m_wr_data,
//	output	reg	[7:0]	m_addr,
	input		[7:0]	m_rd_data,
	output	reg			m_done,
	input				s_ack,
	input				s_data_ack
	);

	// Register to store the data requested to be written from master to slave
	reg [7:0] data;

	enum reg [3:0] {IDLE, M_WR_REQ, S_WR_ACK, M_DATA, S_DATA_ACK, M_WR_ACK, M_RD_REQ, S_RD_RESP, M_RD_ACK} m_current_state, m_next_state;

	always @(posedge clk or posedge rst) begin
		if(rst)
			m_current_state <= IDLE;
		else
			m_current_state <= m_next_state;
	end

	always @(*) begin
		case(m_current_state)
			IDLE	    :	begin
					    		casez ({wr_start, rd_start}) 
									2'b?1	: m_next_state = M_RD_REQ;
									2'b10	: m_next_state = M_WR_REQ;
									default	: m_next_state = IDLE;
					    		endcase
							end
			M_WR_REQ    :	m_next_state = S_WR_ACK;
			S_WR_ACK   :	m_next_state = s_ack ? M_DATA : S_WR_ACK;
			M_DATA      :   m_next_state = S_DATA_ACK;
			S_DATA_ACK    :	m_next_state = s_data_ack ? M_WR_ACK : S_DATA_ACK;
			M_WR_ACK    :	m_next_state = IDLE;
			M_RD_REQ    :	m_next_state = S_RD_RESP;
			S_RD_RESP   :	m_next_state = s_ack ? M_RD_ACK : S_RD_RESP;
			M_RD_ACK    :	m_next_state = IDLE;
			default	    :	m_next_state = IDLE;
		endcase
	end

	always @(posedge clk or posedge rst) begin
		if(rst)
			data <= 8'd0;
		else
			data <= wr_start ? wr_data : data;
	end

	always @(posedge clk or posedge rst) begin
	    if(rst)
			rd_data <= 8'd0;
	    else if(m_current_state == S_RD_RESP && s_ack == 1'b1)
			rd_data <= m_rd_data;
	end

	always @(*) begin
		case(m_current_state)
			M_WR_REQ	:   begin
					   			m_req 		= 1'b1;
				       			m_wr_data 	= 8'd0;
				       			m_done 		= 1'b0;
					   			m_r0_w1 	= 1'b1;
				       		 end
			
			M_DATA        : begin
					   			m_req 		= 1'b0;
				       			m_wr_data 	= data;
				       			m_done 		= 1'b0;
					   			m_r0_w1 	= 1'b0;
				       		 end
			
			M_WR_ACK, M_RD_ACK    :	begin
					   					m_req 		= 1'b0;
				       					m_wr_data 	= 8'd0;
				       					m_done 		= 1'b1;
					   					m_r0_w1 	= 1'b0;
				        			end
			M_RD_REQ    :	begin
					   			m_req 		= 1'b1;
				       			m_wr_data 	= 8'd0;
				       			m_done 		= 1'b0;
					   			m_r0_w1 	= 1'b0;
							end
			default	    :   begin
					   			m_req 		= 1'b0;
				       			m_wr_data 	= 8'd0;
				       			m_done 		= 1'b0;
					   			m_r0_w1 	= 1'b0;
				        	end
		endcase
	end

endmodule

