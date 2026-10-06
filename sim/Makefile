# ============================================================
# APB Based UART 16550 UVM Verification
# Simulator : Siemens Questa
# ============================================================

SIMULATOR = Questa

WORK = work

RTL_DIR  = ../uart_rtl
APB_DIR  = ../apb_agt
UART_DIR = ../uart_agt
TB_DIR   = ../tb
TEST_DIR = ../test

INC = +incdir+$(TB_DIR) \
      +incdir+$(TEST_DIR) \
      +incdir+$(APB_DIR) \
      +incdir+$(UART_DIR)

# ------------------------------------------------------------
# RTL
# Do NOT include apb_if.v / uart_if.v here if these interfaces
# are already defined in tb/top.sv
# ------------------------------------------------------------

RTL = $(RTL_DIR)/apb_if.v \
      $(RTL_DIR)/uart_if.v \
      $(RTL_DIR)/uart_fifo.v \
      $(RTL_DIR)/uart_register_file.v \
      $(RTL_DIR)/uart_tx.v \
      $(RTL_DIR)/uart_rx.v \
      $(RTL_DIR)/uart_16550.v

SVTB2 = $(TEST_DIR)/pkg.sv
SVTB1 = $(TB_DIR)/top.sv

VSIMOPT = -vopt -voptargs=+acc
VSIMCOV = -coverage -sva

# ------------------------------------------------------------
# Default target
# ------------------------------------------------------------

all: run_test


# ------------------------------------------------------------
# Help
# ------------------------------------------------------------

help:
	@echo "============================================================"
	@echo " APB Based UART 16550 UVM Verification"
	@echo "============================================================"
	@echo " make sv_cmp       : Compile the complete testbench"
	@echo " make run_test     : Run base_test"
	@echo " make run_test1    : Run half_duplex_test"
	@echo " make run_test2    : Run full_duplex_test"
	@echo " make run_test3    : Run loopback_test"
	@echo " make run_test4    : Run parity_error_test"
	@echo " make run_test5    : Run break_interrupt_test"
	@echo " make run_test6    : Run framing_error_test"
	@echo " make run_test7    : Run overrun_error_test"
	@echo " make run_test8    : Run thr_empty_test"
	@echo " make run_test9    : Run timeout_error_test"
	@echo " make run_test10   : Run multiple_characters_test"
	@echo " make regress      : Run all tests"
	@echo " make report       : Merge coverage"
	@echo " make clean        : Remove generated files"
	@echo "============================================================"


# ------------------------------------------------------------
# Generic targets
# ------------------------------------------------------------

clean: clean_$(SIMULATOR)

sv_cmp: sv_cmp_$(SIMULATOR)

run_test: run_test_$(SIMULATOR)
run_test1: run_test1_$(SIMULATOR)
run_test2: run_test2_$(SIMULATOR)
run_test3: run_test3_$(SIMULATOR)
run_test4: run_test4_$(SIMULATOR)
run_test5: run_test5_$(SIMULATOR)
run_test6: run_test6_$(SIMULATOR)
run_test7: run_test7_$(SIMULATOR)
run_test8: run_test8_$(SIMULATOR)
run_test9: run_test9_$(SIMULATOR)
run_test10: run_test10_$(SIMULATOR)

regress: regress_$(SIMULATOR)
report: report_$(SIMULATOR)


# ============================================================
# Questa
# ============================================================

sv_cmp_Questa:
	vlib $(WORK)
	vmap work $(WORK)
	vlog -sv -work $(WORK) $(INC) $(RTL) $(SVTB2) $(SVTB1)


run_test_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov1; run -all; exit" \
	-wlf wave_file1.wlf \
	-l test1.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=base_test


run_test1_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov2; run -all; exit" \
	-wlf wave_file2.wlf \
	-l test2.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=half_duplex_test


run_test2_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov3; run -all; exit" \
	-wlf wave_file3.wlf \
	-l test3.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=full_duplex_test


run_test3_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov4; run -all; exit" \
	-wlf wave_file4.wlf \
	-l test4.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=loopback_test


run_test4_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov5; run -all; exit" \
	-wlf wave_file5.wlf \
	-l test5.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=parity_error_test


run_test5_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov6; run -all; exit" \
	-wlf wave_file6.wlf \
	-l test6.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=break_interrupt_test


run_test6_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov7; run -all; exit" \
	-wlf wave_file7.wlf \
	-l test7.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=framing_error_test


run_test7_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov8; run -all; exit" \
	-wlf wave_file8.wlf \
	-l test8.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=overrun_error_test


run_test8_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov9; run -all; exit" \
	-wlf wave_file9.wlf \
	-l test9.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=thr_empty_test


run_test9_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov10; run -all; exit" \
	-wlf wave_file10.wlf \
	-l test10.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=timeout_error_test


run_test10_Questa: sv_cmp
	vsim -c $(VSIMOPT) $(VSIMCOV) \
	-do "log -r /*; coverage save -onexit mem_cov11; run -all; exit" \
	-wlf wave_file11.wlf \
	-l test11.log \
	-sv_seed random \
	work.tb_top \
	+UVM_TESTNAME=multiple_characters_test


# ------------------------------------------------------------
# Waveform
# ------------------------------------------------------------

view_wave1:
	vsim -view wave_file1.wlf

view_wave2:
	vsim -view wave_file2.wlf

view_wave3:
	vsim -view wave_file3.wlf

view_wave4:
	vsim -view wave_file4.wlf

view_wave5:
	vsim -view wave_file5.wlf

view_wave6:
	vsim -view wave_file6.wlf

view_wave7:
	vsim -view wave_file7.wlf

view_wave8:
	vsim -view wave_file8.wlf

view_wave9:
	vsim -view wave_file9.wlf

view_wave10:
	vsim -view wave_file10.wlf

view_wave11:
	vsim -view wave_file11.wlf


# ------------------------------------------------------------
# Regression
# ------------------------------------------------------------

regress_Questa:
	$(MAKE) clean
	$(MAKE) run_test
	$(MAKE) run_test1
	$(MAKE) run_test2
	$(MAKE) run_test3
	$(MAKE) run_test4
	$(MAKE) run_test5
	$(MAKE) run_test6
	$(MAKE) run_test7
	$(MAKE) run_test8
	$(MAKE) run_test9
	


# ------------------------------------------------------------
# Coverage
# ------------------------------------------------------------

report_Questa:
	vcover merge mem_cov \
		mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5 \
		mem_cov6 mem_cov7 mem_cov8 mem_cov9 mem_cov10 

	vcover report -cvg -details -nocompactcrossbins \
		-codeAll -assert -directive -html mem_cov


# ------------------------------------------------------------
# Clean
# ------------------------------------------------------------

clean_Questa:
	rm -rf transcript*
	rm -rf *.log
	rm -rf fcover*
	rm -rf covhtml*
	rm -rf mem_cov*
	rm -rf *.wlf
	rm -rf modelsim.ini
	rm -rf work
