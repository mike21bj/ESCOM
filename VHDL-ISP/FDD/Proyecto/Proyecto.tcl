
########## Tcl recorder starts at 12/11/16 21:05:29 ##########

set version "2.0"
set proj_dir "C:/Users/ELITH/Documents/GitHub/VHDL-ISP/Proyecto"
cd $proj_dir

# Get directory paths
set pver $version
regsub -all {\.} $pver {_} pver
set lscfile "lsc_"
append lscfile $pver ".ini"
set lsvini_dir [lindex [array get env LSC_INI_PATH] 1]
set lsvini_path [file join $lsvini_dir $lscfile]
if {[catch {set fid [open $lsvini_path]} msg]} {
	 puts "File Open Error: $lsvini_path"
	 return false
} else {set data [read $fid]; close $fid }
foreach line [split $data '\n'] { 
	set lline [string tolower $line]
	set lline [string trim $lline]
	if {[string compare $lline "\[paths\]"] == 0} { set path 1; continue}
	if {$path && [regexp {^\[} $lline]} {set path 0; break}
	if {$path && [regexp {^bin} $lline]} {set cpld_bin $line; continue}
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line; continue}
	if {$path && [regexp {^fpgabinpath} $lline]} {set fpga_bin $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]
set fpga_bin [string range $fpga_bin [expr [string first "=" $fpga_bin]+1] end]
regsub -all "\"" $fpga_bin "" fpga_bin
set fpga_bin [file join $fpga_bin]

if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$fpga_bin;$env(PATH)" }

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:05:29 ###########


########## Tcl recorder starts at 12/11/16 21:05:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:05:33 ###########


########## Tcl recorder starts at 12/11/16 21:05:42 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 21:05:42 ###########


########## Tcl recorder starts at 12/11/16 21:06:51 ##########

# Commands to make the Process: 
# VHDL Test Bench Template
if [runCmd "\"$cpld_bin/vhd2naf\" -tfi -proj proyecto -mod CalculadoraChida -out CalculadoraChida -tpl \"$install_dir/ispcpld/generic/vhdl/testbnch.tft\" -ext vht calculadorachida.vhd"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:06:51 ###########


########## Tcl recorder starts at 12/11/16 21:07:12 ##########

# Commands to make the Process: 
# Aldec VHDL Functional Simulation
if [catch {open udo.rsp w} rspFile] {
	puts stderr "Cannot create response file udo.rsp: $rspFile"
} else {
	puts $rspFile "# ispDesignExpert VHDL Functional Simulation Template: simulacion_vhdaf.udo.
# You may edit this file to control your simulation.
# You may specify your design unit.
# You may specify your waveforms.
add wave *
# You may specify your simulation run time.
run 1000 ns
"
	close $rspFile
}
if [catch {open simulacion.rsp w} rspFile] {
	puts stderr "Cannot create response file simulacion.rsp: $rspFile"
} else {
	puts $rspFile "#simulator Aldec
#insert # NOTE: Do not edit this file.
#insert # Auto generated by VHDL Functional Simulation Models
#insert #
#insert design create work .
#insert design open work
#insert adel -all
#path
#insert source {$cpld_bin/chipsim_cmd.tcl}
#prjInfo proyecto.sty
#do 
#vcomSrc   calculadorachida.vhd
#vcom simulacion.vhd
#stimulus vhdl CalculadoraChida simulacion.vhd
#insert vsim +access +r %<StimModule>%
#youdo simulacion_vhdaf.udo
#insert # End
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/chipsim\" simulacion.rsp simulacion.fado udo.rsp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete udo.rsp
file delete simulacion.rsp
# Application to view the Process: 
# Aldec VHDL Functional Simulation
if [catch {open simulacion_activehdl.do w} rspFile] {
	puts stderr "Cannot create response file simulacion_activehdl.do: $rspFile"
} else {
	puts $rspFile "set SIM_WORKING_FOLDER .
do -tcl simulacion.fado
"
	close $rspFile
}
if [runCmd "\"$install_dir/active-hdl/BIN/avhdl\" -do \"simulacion_activehdl.do\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:07:12 ###########


########## Tcl recorder starts at 12/11/16 21:20:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:20:39 ###########


########## Tcl recorder starts at 12/11/16 21:24:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:24:08 ###########


########## Tcl recorder starts at 12/11/16 21:24:15 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 21:24:15 ###########


########## Tcl recorder starts at 12/11/16 21:24:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:24:52 ###########


########## Tcl recorder starts at 12/11/16 21:24:58 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 21:24:58 ###########


########## Tcl recorder starts at 12/11/16 21:26:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:26:28 ###########


########## Tcl recorder starts at 12/11/16 21:26:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:26:33 ###########


########## Tcl recorder starts at 12/11/16 21:26:44 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 21:26:44 ###########


########## Tcl recorder starts at 12/11/16 21:27:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:27:14 ###########


########## Tcl recorder starts at 12/11/16 21:27:17 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 21:27:17 ###########


########## Tcl recorder starts at 12/11/16 21:27:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:27:52 ###########


########## Tcl recorder starts at 12/11/16 21:27:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:27:54 ###########


########## Tcl recorder starts at 12/11/16 21:28:00 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 21:28:00 ###########


########## Tcl recorder starts at 12/11/16 21:28:20 ##########

# Commands to make the Process: 
# VHDL Test Bench Template
if [runCmd "\"$cpld_bin/vhd2naf\" -tfi -proj proyecto -mod CalculadoraChida -out CalculadoraChida -tpl \"$install_dir/ispcpld/generic/vhdl/testbnch.tft\" -ext vht calculadorachida.vhd"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:28:20 ###########


########## Tcl recorder starts at 12/11/16 21:28:42 ##########

# Commands to make the Process: 
# Aldec VHDL Functional Simulation
if [catch {open udo.rsp w} rspFile] {
	puts stderr "Cannot create response file udo.rsp: $rspFile"
} else {
	puts $rspFile "# ispDesignExpert VHDL Functional Simulation Template: simulacion_vhdaf.udo.
# You may edit this file to control your simulation.
# You may specify your design unit.
# You may specify your waveforms.
add wave *
# You may specify your simulation run time.
run 1000 ns
"
	close $rspFile
}
if [catch {open simulacion.rsp w} rspFile] {
	puts stderr "Cannot create response file simulacion.rsp: $rspFile"
} else {
	puts $rspFile "#simulator Aldec
#insert # NOTE: Do not edit this file.
#insert # Auto generated by VHDL Functional Simulation Models
#insert #
#insert design create work .
#insert design open work
#insert adel -all
#path
#insert source {$cpld_bin/chipsim_cmd.tcl}
#prjInfo proyecto.sty
#do 
#vcomSrc   calculadorachida.vhd
#vcom simulacion.vhd
#stimulus vhdl CalculadoraChida simulacion.vhd
#insert vsim +access +r %<StimModule>%
#youdo simulacion_vhdaf.udo
#insert # End
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/chipsim\" simulacion.rsp simulacion.fado udo.rsp"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete udo.rsp
file delete simulacion.rsp
# Application to view the Process: 
# Aldec VHDL Functional Simulation
if [catch {open simulacion_activehdl.do w} rspFile] {
	puts stderr "Cannot create response file simulacion_activehdl.do: $rspFile"
} else {
	puts $rspFile "set SIM_WORKING_FOLDER .
do -tcl simulacion.fado
"
	close $rspFile
}
if [runCmd "\"$install_dir/active-hdl/BIN/avhdl\" -do \"simulacion_activehdl.do\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:28:42 ###########


########## Tcl recorder starts at 12/11/16 21:31:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:31:29 ###########


########## Tcl recorder starts at 12/11/16 21:32:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:32:04 ###########


########## Tcl recorder starts at 12/11/16 21:32:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 21:32:30 ###########


########## Tcl recorder starts at 12/11/16 22:09:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 22:09:25 ###########


########## Tcl recorder starts at 12/11/16 22:09:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 22:09:30 ###########


########## Tcl recorder starts at 12/11/16 22:09:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 22:09:32 ###########


########## Tcl recorder starts at 12/11/16 22:09:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 22:09:45 ###########


########## Tcl recorder starts at 12/11/16 22:09:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 22:09:47 ###########


########## Tcl recorder starts at 12/11/16 22:09:57 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 22:09:57 ###########


########## Tcl recorder starts at 12/11/16 22:10:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 22:10:36 ###########


########## Tcl recorder starts at 12/11/16 22:10:41 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 22:10:41 ###########


########## Tcl recorder starts at 12/11/16 22:11:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vhd2jhd\" calculadorachida.vhd -o calculadorachida.jhd -m \"$install_dir/ispcpld/generic/lib/vhd/location.map\" -p \"$install_dir/ispcpld/generic/lib\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 12/11/16 22:11:46 ###########


########## Tcl recorder starts at 12/11/16 22:11:48 ##########

# Commands to make the Process: 
# Synplify Synthesize VHDL File
if [catch {open CalculadoraChida.cmd w} rspFile] {
	puts stderr "Cannot create response file CalculadoraChida.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: proyecto.sty
PROJECT: CalculadoraChida
WORKING_PATH: \"$proj_dir\"
MODULE: CalculadoraChida
VHDL_FILE_LIST: calculadorachida.vhd
OUTPUT_FILE_NAME: CalculadoraChida
SUFFIX_NAME: edi
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DEFAULT_ENUM_ENCODING: default
ARRANGE_VHDL_FILES: true
synthesis_onoff_pragma: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -e CalculadoraChida -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete CalculadoraChida.cmd

########## Tcl recorder end at 12/11/16 22:11:48 ###########

