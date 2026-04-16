# ==========================================
# 1. 路径设置
# ==========================================
set scriptPath [info script]
set baseDir    [file dirname $scriptPath]

set paramFile [file join $baseDir "params.txt"]
set hmFile    [file join $baseDir "qiang0416.hm"]
set tplFile   "D:/Program Files/Altair/2022.1/hwdesktop/templates/feoutput/ls-dyna971/dyna.key"

puts "======================================"
puts "Script Dir : $baseDir"
puts "Param File : $paramFile"
puts "HM File    : $hmFile"
puts "Template   : $tplFile"
puts "======================================"

# ==========================================
# 2. 基本检查
# ==========================================
if {![file exists $paramFile]} {
    error "Parameter file does not exist: $paramFile"
}
if {![file exists $hmFile]} {
    error "HM file does not exist: $hmFile"
}
if {![file exists $tplFile]} {
    error "Template file does not exist: $tplFile"
}

# ==========================================
# 3. 读取参数       （要修改，添加参数）
# params.txt 格式：
# 第1行: outRoot
# 第2行: caseID
# 第3行: fpq_F
# 第4行: fpq_s
# ==========================================
set fid [open $paramFile r]
set lines [split [string trim [read $fid]] "\n"]
close $fid

set outRoot [string map {"\\" "/"} [string trim [lindex $lines 0]]]
set caseID  [string trim [lindex $lines 1]]
set fpq_F   [string trim [lindex $lines 2]]
set fpq_s   [string trim [lindex $lines 3]]


# ==========================================
# 4. 创建输出目录   （put为显示作用，不必须修改）
# ==========================================
if {![file exists $outRoot]} {
    file mkdir $outRoot
}

set runName   [format "run__%05d" $caseID]
set caseDir   [file join $outRoot $runName]
set kfilepath [file join $caseDir "qiang041502.k"]

if {![file exists $caseDir]} {
    file mkdir $caseDir
}

puts "======================================"
puts "Output Root : $outRoot"
puts "Case ID     : $caseID"
puts "fpq_F       : $fpq_F"
puts "fpq_s       : $fpq_s"
puts "Output Dir  : $caseDir"
puts "Output K    : $kfilepath"
puts "======================================"

# ==========================================
# 5. HyperMesh 操作
# ==========================================
*templatefileset $tplFile

hm_answernext yes
*mergefile $hmFile 0 0

# ---------- 曲线修改 ----------
*curvemodifypointcords 1 3 "-y" [expr {$fpq_F * 1000.0}] "" 0
*curvemodifypointcords 1 4 "-y" [expr {$fpq_F * 1000.0}] "" 0
*curvemodifypointcords 1 5 "-y" [expr {$fpq_F * 1000.0 + 100000.0}] "" 0

*curvemodifypointcords 1 4 "-x" [expr {$fpq_s + 1.0}] "" 0
*curvemodifypointcords 1 5 "-x" [expr {$fpq_s + 2.0}] "" 0

# ---------- 导出k文件 ----------
*createstringarray 4 "HMCOMMENTS_SKIP" "HMBOMCOMMENTS_XML" "HMMATCOMMENTS_XML" "IDRULES_SKIP"

hm_answernext yes
*feoutputwithdata $tplFile $kfilepath 0 0 2 1 4

puts "Export finished: $kfilepath"