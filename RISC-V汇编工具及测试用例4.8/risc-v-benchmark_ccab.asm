#############################################################
#测试jal,jalr指令，
#############################################################
.text
 addi s1,zero, 1   #测试jal,jalrr指令
 j jmp_next1       #jal x0,8
 addi s1,zero, 1
 addi s2,zero, 2
 addi s3,zero, 3
jmp_next1:
 j jmp_next2
 addi s1,zero, 1
 addi s2,zero, 2
 addi s3,zero, 3
jmp_next2:
 j jmp_next3
 addi s1,zero, 1
 addi s2,zero, 2
 addi s3,zero, 3
jmp_next3:
 j jmp_next4
 addi s1,zero, 1
 addi s2,zero, 2
 addi s3,zero, 3
jmp_next4:jal jmp_count

#移位测试  需要支持超addi,sll,add,ecall,srl,sll,sra,beq,j,ecall    revise date:2015/12/16 tiger

.text
addi s0,zero,1     #简单移位，循环测试，0号区域显示的是初始值1左移1位重复15次的值，1号区域是累加值
addi s1,zero,1  
slli s1, s1, 31   #逻辑左移31位 s1=0x80000000
 

###################################################################
#                逻辑左移测试 
# 显示区域依次显示0x80000000 0x20000000 0x08000000 0x02000000 0x00800000 0x00200000 0x00080000 0x00020000 0x00008000 0x00002000 0x00000800 0x00000200 0x00000080 0x00000020 0x00000008 0x00000002 0x00000000  
###################################################################
LogicalRightShift:            #逻辑右移测试，将最高位1逐位向右右移直至结果为零

add    a0,zero,s1       #display s1
addi   a7,zero,34        # display hex
ecall                 # we are out of here.  
     
srli s1, s1, 2   
beq s1, zero, shift_next1
j LogicalRightShift

shift_next1:

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  


###################################################################
#                逻辑右移测试 
# 显示区域依次显示0x00000004 0x00000010 0x00000040 0x00000100 0x00000400 0x00001000 0x00004000 0x00010000 0x00040000 0x00100000 0x00400000 0x01000000 0x04000000 0x10000000 0x40000000 0x00000000 
###################################################################

addi s1,zero, 1   
LogicalLeftShift:         #逻辑左移测试，将最低位1逐位向左移直至结果为零
slli s1, s1, 2  

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  
      
beq s1, zero, ArithRightShift
j LogicalLeftShift


###################################################################
#                算术右移测试 
# 显示区域依次显示0x80000000 0xf0000000 0xff000000 0xfff00000 0xffff0000 0xfffff000 0xffffff00 0xfffffff0 0xffffffff 
###################################################################
ArithRightShift:          #算术右移测试，#算术移位测试，80000000算术右移，依次显示为F0000000,FF000000,FFF00000,FFFF0000直至FFFFFFFF

addi s1,zero,1  
slli s1, s1, 31   #逻辑左移31位 s1=0x80000000

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  

srai s1, s1, 3    #s1=0X80000000-->0XF0000000

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  


srai s1, s1, 4    #0XF0000000-->0XFF000000

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  


srai s1, s1, 4    #0XFF000000-->0XFFF00000

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  

srai s1, s1, 4    

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  

srai s1, s1, 4    

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  


srai s1, s1, 4    

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  


srai s1, s1, 4    

add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.  


srai s1, s1, 4    


add    a0,zero,s1       #display s1
addi   a7,zero,34         # display hex
ecall                 # we are out of here.    

#############################################################
#走马灯测试,测试addi,andi,sll,srl,sra,or,ori,nor,ecall  LED按走马灯方式来回显示数据
#############################################################

.text
addi s0,zero,1 
slli s3, s0, 31      # s3=0x80000000
srai s3, s3, 31      # s3=0xFFFFFFFF   
add s0,zero,zero   # s0=0         
addi s2,zero,12 

addi s6,zero,3  #走马灯计数
zmd_loop:

addi s0, s0, 1    #计算下一个走马灯的数据
andi s0, s0, 15  

#######################################
addi t0,zero,8    
addi t1,zero,1
left:

slli s3, s3, 4   #走马灯左移
or s3, s3, s0

add    a0,zero,s3       # display s3
addi   a7,zero,34         # system call for LED display 
ecall                 # display 

sub t0,t0,t1
bne t0,zero,left
#######################################

addi s0, s0, 1   #计算下一个走马灯的数据
addi t6,zero,15
and s0, s0, t6
slli s0, s0, 28     

addi t0,zero,8
addi t1,zero,1

zmd_right:

srli s3, s3, 4  #走马灯右移
or s3, s3, s0

add    a0,zero,s3       # display s3
addi   a7,zero,34         # system call for LED display 
ecall                 # display 

sub t0,t0,t1
bne t0,zero,zmd_right
srli s0, s0, 28  
#######################################

sub s6,s6,t1
beq s6,zero, exit
j zmd_loop

exit:

add t0,zero,zero
xori t0,t0,-1      #test r  xori
slli t0,t0,8
ori t0,t0,255

add   a0,zero,t0       # display t0
addi   a7,zero,34         # system call for LED display 
ecall                 # display 

#################################################################################
#本程序实现0-15号字单元的降序排序,此程序可在rars 仿真器中运行
#运行时请将rars Setting中的Memory Configuration设置为Compact，data at address 0
#################################################################################
 .text
sort_init:
 addi s0,zero,-1
 addi s1,zero,0
 
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
  sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
  sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
 sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
  sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
  sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
  sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
  sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
    sw s0,0(s1)
 addi s0,s0,1
 addi s1,s1,4
   
 addi s0,s0,1
 
 add s0,zero,zero   
 addi s1,zero,60   #排序区间
sort_loop:
 lw s3,0(s0)     
 lw s4,0(s1)
 slt t0,s3,s4
 beq t0,zero,sort_next   #降序排序
 sw s3, 0(s1)
 sw s4, 0(s0)   
sort_next:
 addi s1, s1, -4   
 bne s0, s1, sort_loop  
 
 add    a0,zero,s0       #display s0
 addi   a7,zero,34         # display hex
 ecall                 # we are out of here.  DISP: disp r0, 0
 
 addi s0,s0,4
 addi s1,zero,60
 bne s0, s1, sort_loop


 addi   a7,zero,10         # system call for pause
 ecall                  # we are out of here.   
 
 
#############################################
# insert your ccmb benchmark program here!!!
#############################################

#j benchmark_start       #delete this instruction for ccmb bencmark
#C1 instruction benchmark

#XOR测试    revise date:2021/1/24 tiger
# 0x00007777 xor   0xffffffff =  0xffff8888 
# 0xffff8888 xor   0xffffffff =  0x00007777 
#依次输出 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777 0xffff8888 0x00007777

.text

addi t0,zero,-1     #
addi s1,zero,  0x77
slli s1,s1,8
addi s1,s1,0x77



add a0,zero,s1           
addi a7,zero,34         # system call for print
ecall                  # print

addi t3,zero, 0x10

xor_branch:
xor s1,s1,t0     #先移1位
add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall                  # print
addi t3,t3, -1    
bne t3,zero,xor_branch   #循环8次

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   

#C2 instruction benchmark

#LUI测试    revise date:2021/1/24 tiger
#依次输出 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000 0xfedcffff 0xba980000 0x76540000 0x32100000

.text

addi t3,zero,  0x8

lui_branch:
lui s1,  0xFEDC0 
addi s0,zero, -1
srli  s0,s0,16
or s1,s1,s0

add a0,zero,s1          
addi a7,zero,34         # system call for print
ecall    
lui s1,  0xBA980
add a0,zero,s1          
ecall    
lui s1,  0x76540
add a0,zero,s1          
ecall    
lui s1,  0x32100     
add a0,zero,s1          
ecall    
                           # print
addi t3,t3, -1    
bne t3,zero,lui_branch

addi   a7,zero,10         # system call for exit
ecall                     # we are out of here.   

#Mem instruction benchmark

#LH 测试    revise date:2021/1/24 tiger
#依次输出  0xffff8281 0xffff8483 0xffff8685 0xffff8887 0xffff8a89 0xffff8c8b 0xffff8e8d 0xffff908f 0xffff9291 0xffff9493 0xffff9695 0xffff9897 0xffff9a99 0xffff9c9b 0xffff9e9d 0xffffa09f 0xffffa2a1 0xffffa4a3 0xffffa6a5 0xffffa8a7 0xffffaaa9 0xffffacab 0xffffaead 0xffffb0af 0xffffb2b1 0xffffb4b3 0xffffb6b5 0xffffb8b7 0xffffbab9 0xffffbcbb 0xffffbebd 0xffffc0bf
.text

addi t1,zero,0     #init_addr 
addi t3,zero,16     #counter

#预先写入数据，实际是按字节顺序存入 0x81,82,84,86,87,88,89.......等差数列

addi s1,zero,  0x84
slli s1,s1,8
addi s1,s1,0x83 
addi s2,zero,  0x04
slli s2,s2,8
addi s2,s2,0x04
slli s1,s1,8
addi s1,s1,0x82 
slli s1,s1,8
addi s1,s1,0x81
slli s2,s2,8
addi s2,s2,0x04
slli s2,s2,8
addi s2,s2,0x04    #    init_data= 0x84838281 next_data=init_data+ 0x04040404


lh_store:
sw s1,(t1)
add s1,s1,s2   #data +1
addi t1,t1,4    # addr +4  
addi t3,t3,-1   #counter
bne t3,zero,lh_store

addi t3,zero,32
addi t1,zero,0    # addr  
lh_branch:
lh s1,(t1)     #测试指令
add a0,zero,s1          
addi a7,zero,34         
ecall                  # print
addi t1,t1, 2    
addi t3,t3, -1    
bne t3,zero,lh_branch

addi   a7,zero,10         # system call for exit
ecall                  # we are out of here.   


#Branch instruction benchmark

#bltu 测试    小于等于零跳转     累加运算，从负数开始向零运算  revise date:2022/1/24 tiger  
#依次输出0xfffffff1 0xfffffff2 0xfffffff3 0xfffffff4 0xfffffff5 0xfffffff6 0xfffffff7 0xfffffff8 0xfffffff9 0xfffffffa 0xfffffffb 0xfffffffc 0xfffffffd 0xfffffffe 0xffffffff 0x00000000
.text

addi s1,zero,-15       #初始值
bltu_branch:
add a0,zero,s1          
addi a7,zero,34         
ecall                  #输出当前值
addi s1,s1,1  
bltu zero,s1,bltu_branch   
add a0,zero,s1          
addi a7,zero,34         
ecall                  #输出当前值
end:
addi   a7,zero,10         
ecall                  # 暂停或退出



                 
 addi   a7,zero,10         # system call for exit
 ecall                  # we are out of here.   
 
 #处理器实现中请用停机指令实现ecall

jmp_count: addi s0,zero, 0
       addi s0,s0, 1
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       ecall                 # we are out of here.  
       
       addi s0,s0, 2
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       ecall                 # we are out of here.  
       
       addi s0,s0, 3
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       ecall                 # we are out of here.  
       
       addi s0,s0, 4       
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       ecall                 # we are out of here.  
       
       addi s0,s0, 5              
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       ecall                 # we are out of here.  

       addi s0,s0, 6              
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       ecall                 # we are out of here.  

       addi s0,s0, 7              
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       ecall                 # we are out of here.  

       addi s0,s0, 8              
       add    a0,zero,s0      
       addi   a7,zero,34         # display hex
       addi   a7,zero,34         # display hex       
       ecall                 # we are out of here.  
       
       ret  #persudo instruction  jalr x0,x1,0
