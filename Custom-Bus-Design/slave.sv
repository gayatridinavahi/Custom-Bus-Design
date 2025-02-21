`timescale 1ns/1ps


module custom_bus_slave(
	// Clock and Reset
	input				clk,
	input				rst,

	// Bus Interface Signals
	input				m_req,
	input				m_r0_w1,
	input		[7:0]	m_wr_data,
	output	reg	[7:0]	m_rd_data,
	input				m_done,
	output	reg			s_ack,
	output	reg			s_data_ack
	);

	// Register to store the data received
	reg [7:0] data;

	enum reg [2:0] {M_REQ, S_WR_ACK, S_DATA, S_DATA_ACK, M_WR_ACK, S_RD_RESP, M_RD_ACK} s_current_state, s_next_state;

	always @(posedge clk or posedge rst) begin
		if(rst)
			s_current_state <= M_REQ;
		else
			s_current_state <= s_next_state;
	end

	always @(*) begin
		case(s_current_state)
			M_REQ		:	begin
								if(m_req && ~m_r0_w1)
									s_next_state = S_RD_RESP;
								else if(m_req && m_r0_w1)
									s_next_state = S_WR_ACK;
								else
									s_next_state = M_REQ;
							end
			S_WR_ACK	:	s_next_state = S_DATA;
			S_DATA   	:	s_next_state = S_DATA_ACK;
			S_DATA_ACK	:	s_next_state = M_WR_ACK;
			M_WR_ACK	:	s_next_state = m_done ? M_REQ : M_WR_ACK;
			S_RD_RESP	:	s_next_state = M_RD_ACK;
			M_RD_ACK	:	s_next_state = m_done ? M_REQ : M_RD_ACK;
			default		:	s_next_state = M_REQ;
		endcase
	end

	always @(*) begin
		case(s_current_state)
			S_WR_ACK	: 	begin
								s_ack 		= 1'b1;
								s_data_ack		= 1'b0;
								m_rd_data 	= 8'd0;
							end
			S_DATA_ACK	: 	begin
								s_ack		= 1'b0;
								s_data_ack		= 1'b1;
								m_rd_data 	= 8'd0;
							end
			S_RD_RESP	: 	begin
								s_ack 		= 1'b1;
								s_data_ack		= 1'b0;
								m_rd_data 	= data;
							end
			default		: 	begin
								s_ack		= 1'b0;
								s_data_ack		= 1'b0;
								m_rd_data 	= 8'd0;
							end
		endcase
	end

	always @(posedge clk or posedge rst) begin
		if(rst)
			data <= 8'd0;
		else
			data <= (s_current_state == S_DATA) ? m_wr_data : data;
	end

endmodule

