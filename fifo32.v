    `timescale 1ns / 1ps 
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 10/08/2025 12:08:35 PM
    // Design Name: 
    // Module Name: fifo32
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////
    
    
    module fifo32 #(
        parameter DEPTH = 4//16 // fifo nay chua dc 16 du lieu 32bit
        )(
        input wire clk,
        input wire rst,
        input wire wr_en,
        input wire [31:0] wr_data, //data in
        input wire rd_en,
        output reg [31:0] rd_data, //data out
        output wire full,
        output wire empty
        );
        reg [31:0] mem [DEPTH-1:0];//[0:DEPTH-1];
        reg [$clog2(DEPTH)-1:0] w_ptr; // con tro dung de di chuyen den index ghi
        reg [$clog2(DEPTH)-1:0] r_ptr; // con tro dung de di chuyen den index doc
        reg [$clog2(DEPTH):0] count; // dung de den so luong du lieu con trong fifo
        
        //reg one_time_full;
        assign full = (count == DEPTH);
        assign empty = (count == 0);
    
    /*
        always @(*) begin
            if(empty) rd_data = 32'h0;
            else rd_data = mem[r_ptr];
        end
        
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                w_ptr <= 0;
                r_ptr <= 0;
                count <= 0;
            end
            else begin
                //write
                if (wr_en && !full) begin
                    mem[w_ptr] <= wr_data;
                    w_ptr <= w_ptr +1;
                end
                //read
                if (rd_en && !empty) begin
                    r_ptr <= r_ptr + 1;
                end
                if (wr_en && !full && !rd_en) begin
                    //just write
                    count <= count + 1;
                end
                else if (!wr_en && rd_en && !empty) begin
                    //just read
                    count <= count -1;
                end
            end
        end
        */
        always @(posedge clk or posedge rst) begin
        if (rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
            rd_data <= 32'h0; // Reset cả dữ liệu đầu ra
        end
        else begin
            // Xử lý logic Ghi và Đọc con trỏ trước
            if (wr_en && !full) begin
                mem[w_ptr] <= wr_data;
                w_ptr <= w_ptr + 1;
            end

            if (rd_en && !empty) begin
                // SỬA LỖI: Cập nhật rd_data MỘT CÁCH TUẦN TỰ
                // Đọc dữ liệu từ vị trí con trỏ đọc HIỆN TẠI
                rd_data <= mem[r_ptr];
                // Sau đó mới tăng con trỏ đọc cho lần sau
                r_ptr <= r_ptr + 1;
            end

            // Xử lý logic đếm sau cùng
            // Trường hợp 1: Chỉ Ghi (Ghi=1, Đọc=0)
            if (wr_en && !full && !rd_en) begin
                count <= count + 1;
            end
            // Trường hợp 2: Chỉ Đọc (Ghi=0, Đọc=1)
            else if (!wr_en && rd_en && !empty) begin
                count <= count - 1;
            end
            // Trường hợp 3: Ghi và Đọc đồng thời -> count không đổi
            // Trường hợp 4: Không làm gì -> count không đổi
        end
    end
        /*
        reg flag_rd_en;
        reg flag_wr_en;
        
        
        always @(posedge clk or posedge rst ) begin //or posedge rd_en or posedge wr_en
            if (rst) begin
                w_ptr <= 0;
                r_ptr <= 0;
                count <= 0;
                one_time_full <= 1;
                flag_rd_en <= 1;
                flag_wr_en <= 1;
            end
            else begin
                // write
                if (wr_en && count < DEPTH && one_time_full && flag_wr_en) begin
                    mem[w_ptr] <= wr_data;
                    count <= count + 1;
                    w_ptr <= w_ptr + 1;
                    flag_wr_en <= 0;
                    
                end
                
                // read
                if (rd_en && count > 0 && flag_rd_en) begin //r_ptr <= DEPTH
                    rd_data <= mem[r_ptr];
                    count <= count - 1;
                    r_ptr <= r_ptr + 1;
                    flag_rd_en <= 0;
                    
                end
                
                if (!rd_en) begin
                    flag_rd_en <= 1;
                end
                if (!wr_en) begin
                    flag_wr_en <= 1;
                end
                
                
                if (count == DEPTH) begin
                    one_time_full <= 0;
                end
            end
        end
    */
    
        
    endmodule
    
