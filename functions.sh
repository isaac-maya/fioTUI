### SHARED FUNCTIONS

#1
hello_disclaimer() {
clear
whiptail --title "fioTUI" --msgbox "Terminal user interface wrapper for FIO.\n 
WARNING!!! \n 
Proceed reponsibly and with caution. This tool may cause letal damage to a system!" 13 60 
RUNFILENAME=$(date +%s)
}


#2
modeSel() {
#while [ 1 ]
#do
CHOICE=$(
whiptail --title "Operation Mode" --menu "Make your choice" 13 60 4 \
        "1)" "ez - easy peasy "   \
        "2)" "oc - obvious control"  \
        "3)" "End script"  3>&2 2>&1 1>&3       
)

case $CHOICE in
        "1)")   
                ezMode
        ;;
        "2)")   
                ocMode
        ;;

        "3)") exit
        ;;
esac
#whiptail --msgbox "$result" 20 78
#done
}

#3A
ezMode() {   
OP_MODE=ez_opts
test_name        
}

#3B
ocMode() {      
OP_MODE=oc_opts
test_name        
}

#4
test_name() {
TESTNAME=$(whiptail --title "Test Name" --inputbox "What is the name for FIO workload?" 13 60  3>&1 1>&2 2>&3)
RUNFILENAME=$TESTNAME$RUNFILENAME
exitstatus=$?
        if [ $exitstatus = 0 ]; then
            target
        else
            echo "You chose Cancel."
            exit
        fi
 
}

#5            
target() {          
LOCATION=$(whiptail --title "Workload target" --inputbox "Where should FIO run?" 13 60 /mnt/ 3>&1 1>&2 2>&3)
exitstatus=$?
        if [ $exitstatus = 0 ]; then
             $OP_MODE 
        else
            echo "You chose Cancel."
            exit
        fi
}


### EZ FUNCTIONS

#6A
ez_opts() {
RUNTIME=$(whiptail --title "Workload runtime" --inputbox "How many seconds should FIO run per load?" 13 60 14400s 3>&1 1>&2 2>&3)
exitstatus=$?
        if [ $exitstatus = 1 ]; then
            echo "You chose Cancel."
            exit 1
        else
            #echo "augusto!"
	    EZglobalFIO
            EZiotype
        fi
}

#7A
EZglobalFIO() {
{
echo "[global]"           
echo "directory=$LOCATION" 
echo "refill_buffers"             
echo "lockfile=readwrite"             
echo "allrandrepeat=1"             
echo "time_based"            
echo "runtime=$RUNTIME"
echo "ioengine=posixaio"            
echo "direct=1"            
echo "group_reporting"            
echo "numjobs=1"
echo "openfiles=300" 
echo "thinktime=16s-196s"  
echo "iodepth=1-8"

} >> $RUNFILENAME.FIO
}

#8A
EZiotype() {
STEP_LIST=(

        "EZseqread" "Sequential reads"
        "EZseqwrite" "Sequential writes"
        "EZrandread" "Random reads"
        "EZrandwrite" "Random writes"
        "EZreadwrite" "Sequential mixed reads and writes"
        "EZrandrw" "Random mixed reads and writes"
        "EZtrimwrite" "Sequential trim+write sequences"

)

entry_options=()
entries_count=${#STEP_LIST[@]}
message='Select IO patterns!'

for i in ${!STEP_LIST[@]}; do
    if [ $((i % 2)) == 0 ]; then
        entry_options+=($(($i / 2)))
        entry_options+=("${STEP_LIST[$(($i + 1))]}")
        entry_options+=('OFF')
    fi
done

SELECTED_STEPS_RAW=$(
    whiptail \
        --checklist \
        --separate-output \
        --title 'IO Type' \
        "$message" \
        20 60 \
        "$entries_count" -- "${entry_options[@]}" \
        3>&1 1>&2 2>&3
)

if [[ ! -z SELECTED_STEPS_RAW ]]; then
    for STEP_FN_ID in ${SELECTED_STEPS_RAW[@]}; do
        FN_NAME_ID=$(($STEP_FN_ID * 2))
        STEP_FN_NAME="${STEP_LIST[$FN_NAME_ID]}"
        echo "---Running ${STEP_FN_NAME}---"
        $STEP_FN_NAME
    done
fi
}

#9A
EZseqreadFIO() {
{
echo            
echo 
echo "[read]"
echo "rw=read" 
echo "bs=$BS" 
echo "size=$SIZE" 
} >> $RUNFILENAME.FIO
}

EZseqread() { 
OPE=EZseqreadFIO
whiptail --title "$LOCATION" --msgbox "SEQREAD options.\n " 10 60 
EZtamano
}

EZseqwriteFIO() {
{
echo 
echo
echo "[write]"
echo "rw=write"
echo "bs=$BS" 
echo "filesize=$SIZE" 
} >> $RUNFILENAME.FIO       
}

EZseqwrite() { 
OPE=EZseqwriteFIO
whiptail --title "$LOCATION" --msgbox "SEQWRITE options.\n " 10 60 
EZtamano
}

EZrandreadFIO() {
{
echo
echo
echo "[randread]"
echo "rw=randread"
echo "bs=$BS"
echo "size=$SIZE"
} >> $RUNFILENAME.FIO
}

EZrandread() { 
OPE=EZrandreadFIO
whiptail --title "$LOCATION" --msgbox "RANDREAD options.\n " 10 60 
EZtamano
}

EZrandwriteFIO(){
{
echo
echo
echo "[randwrite]"
echo "rw=randwrite"
echo "bs=$BS"
echo "filesize=$SIZE"
} >> $RUNFILENAME.FIO
}

EZrandwrite() { 
OPE=EZrandwriteFIO
whiptail --title "$LOCATION" --msgbox "RANDWRITE options.\n " 10 60 
EZtamano
}

EZreadwriteFIO(){
{
echo
echo
echo "[readwrite]"
echo "rw=readwrite"
echo "bs=$BS"
echo "filesize=$SIZE"
} >> $RUNFILENAME.FIO
}

EZreadwrite() { 
OPE=EZreadwriteFIO
whiptail --title "$LOCATION" --msgbox "READWRITE options.\n " 10 60 
EZtamano
}

EZrandrwFIO(){
{
echo
echo
echo "[randrw]"
echo "rw=randrw"
echo "bs=$BS"
echo "filesize=$SIZE"
echo "rwmixread=66"
} >> $RUNFILENAME.FIO
}

EZrandrw() { 
OPE=EZrandrwFIO
whiptail --title "$LOCATION" --msgbox "RANDRW options.\n " 10 60 
EZtamano
}

#10A
EZtamano() {
#while [ 1 ]
#do
CHOICE2=$(
whiptail --title "File size" --menu "Make your choice" 13 60 5 \
        "1)" "small - 1K-10K "   \
        "2)" "medium - 2M-35M"  \
        "3)" "large - 90M-1G"  \
        "4)" "End script"  3>&2 2>&1 1>&3       
)

case $CHOICE2 in
        "1)")   
                BS=4K
                SIZE=1K-10K
                $OPE
        ;;
        "2)")   
                BS=2M
                SIZE=2M-35M
                $OPE
        ;;

        "3)")   BS=10M
                SIZE=90M-1G
                $OPE
        ;;
        
        "4)") exit  
        ;;
esac
#whiptail --msgbox "$result" 13 60
#done
}

#6B
oc_opts() {	
RUNTIME=$(whiptail --title "Workload runtime" --inputbox "How many seconds should FIO run per load?" 13 60 14400s 3>&1 1>&2 2>&3)
exitstatus=$?
	if [ $exitstatus = 1 ]; then
            echo "You chose Cancel."
	    exit 1
	else
	    globalFIO
	    iotype
	fi
}

#7B
globalFIO() {
{
echo "[global]"           
echo "directory=$LOCATION" 
echo "refill_buffers"             
echo "lockfile=readwrite"             
echo "allrandrepeat=1"             
echo "time_based"            
echo "runtime=$RUNTIME"
echo "ioengine=posixaio"            
echo "direct=1"            
echo "group_reporting"            
} >> $RUNFILENAME.FIO
}

#8B
iotype() {
STEP_LIST=(

        "seqread" "Sequential reads"
        "seqwrite" "Sequential writes"
        "randread" "Random reads"
        "randwrite" "Random writes"
        "readwrite" "Sequential mixed reads and writes"
        "randrw" "Random mixed reads and writes"
        "trimwrite" "Sequential trim+write sequences"

)

entry_options=()
entries_count=${#STEP_LIST[@]}
message='Select IO patterns!'

for i in ${!STEP_LIST[@]}; do
    if [ $((i % 2)) == 0 ]; then
        entry_options+=($(($i / 2)))
        entry_options+=("${STEP_LIST[$(($i + 1))]}")
        entry_options+=('OFF')
    fi
done

SELECTED_STEPS_RAW=$(
    whiptail \
        --checklist \
        --separate-output \
        --title 'IO Type' \
        "$message" \
        20 60 \
        "$entries_count" -- "${entry_options[@]}" \
        3>&1 1>&2 2>&3
)

if [[ ! -z SELECTED_STEPS_RAW ]]; then
    for STEP_FN_ID in ${SELECTED_STEPS_RAW[@]}; do
        FN_NAME_ID=$(($STEP_FN_ID * 2))
        STEP_FN_NAME="${STEP_LIST[$FN_NAME_ID]}"
        echo "---Running ${STEP_FN_NAME}---"
        $STEP_FN_NAME
    done
fi
}

#9B
readFIO() {
{
echo            
echo 
echo "[read]"
echo "rw=read" 
echo "numjobs=$NUMJOBS"  
echo "bs=$BS" 
echo "size=$SIZE" 
echo "openfiles=$OPENFILES" 
echo "thinktime=$THINKTIME"  
echo "iodepth=1-8"
} >> $RUNFILENAME.FIO
}

randreadFIO() {
{
echo            
echo 
echo "[randread]"
echo "rw=randread" 
echo "numjobs=$NUMJOBS"  
echo "bs=$BS" 
echo "size=$SIZE" 
echo "openfiles=$OPENFILES" 
echo "thinktime=$THINKTIME"  
echo "iodepth=1-8"
} >> $RUNFILENAME.FIO
}

writeFIO() {
{
echo 
echo
echo "[write]"
echo "rw=write"
echo "numjobs=$NUMJOBS"  
echo "bs=$BS" 
echo "filesize=$SIZE" 
echo "openfiles=$OPENFILES" 
echo "thinktime=$THINKTIME"  
echo "iodepth=1-8" 
echo "verify=md5"
echo "do_verify=1"                                                                                                                                                                                                                                                                                                           
echo "lockfile=readwrite"                                                                                                                                                                                                                                                                                                    
} >> $RUNFILENAME.FIO                                                                                                                                                                                                                                                                                                            
}                                                                                                                                                                                                                                                                                                                            
randwriteFIO(){
{
echo
echo
echo "[randwrite]"
echo "rw=randwrite"
echo "numjobs=$NUMJOBS"  
echo "bs=$BS" 
echo "filesize=$SIZE" 
echo "openfiles=$OPENFILES" 
echo "thinktime=$THINKTIME"  
echo "iodepth=1-8" 
echo "verify=md5"
echo "do_verify=1"                                                                                                                                                                                                                                                                                                           
echo "lockfile=readwrite"                                                                                                                                                                                                                                                                                                   
} >> $RUNFILENAME.FIO                                                                                                                                                                                                                                                                                                            
}
readwriteFIO(){
{
echo
echo
echo "[readwrite]"
echo "rw=readwrite"
echo "numjobs=$NUMJOBS"  
echo "bs=$BS" 
echo "filesize=$SIZE" 
echo "openfiles=$OPENFILES" 
echo "thinktime=$THINKTIME"  
echo "iodepth=1-8" 
echo "verify=md5"
echo "do_verify=1"
echo "lockfile=readwrite"                                                                                                                                                                                                                                                                                                    
} >> $RUNFILENAME.FIO                                                                                                                                                                                                                                                                                                            
}

randrwFIO(){
{
echo
echo
echo "[randrw]"
echo "rw=randrw"
echo "numjobs=$NUMJOBS"  
echo "bs=$BS" 
echo "filesize=$SIZE" 
echo "openfiles=$OPENFILES" 
echo "thinktime=$THINKTIME"  
echo "iodepth=1-8" 
echo "rwmixread=66"
echo "verify=md5"
echo "do_verify=1"                                                                                                                                                                                                                                                                                                           
echo "lockfile=readwrite"                                                                                                                                                                                                                                                                                                    
} >> $RUNFILENAME.FIO                                                                                                                                                                                                                                                                                                            
}

seqread() { 
whiptail --title "$LOCATION" --msgbox "SEQREAD options.\n " 10 60 
trabajo
readFIO
}

seqwrite() {
whiptail --title "SEQWRITE options" --msgbox "$TESTNAME SEQWRITE options.\n " 10 60 
trabajo
writeFIO
}

randread() {
whiptail --title "RANDREAD options" --msgbox "$TESTNAME RANDREAD options.\n " 10 60 
trabajo
randreadFIO
}

randwrite() {
whiptail --title "RANDWRITE options" --msgbox "$TESTNAME RANDWRITE options.\n " 10 60 
trabajo
randwriteFIO
}

readwrite() {
whiptail --title "READWRITE options" --msgbox "$TESTNAME READWRITE options.\n " 10 60 
trabajo
readwriteFIO
}

randrw() { 
whiptail --title "RANDRW options" --msgbox "$TESTNAME RANDRW options.\n " 10 60 
trabajo
randrwFIO
}

trimwrite() { 
whiptail --title "TRIMWRITE options" --msgbox "$TESTNAME TRIMWRITE options.\n " 10 60 
trabajo
}

#10B
trabajo() {
NUMJOBS=$(whiptail --title "Number of jobs" --inputbox "How many jobs should FIO run?" 13 60 1 3>&1 1>&2 2>&3)
exitstatus=$?
	if [ $exitstatus = 0 ]; then
            bullshit
	else
	    echo "You chose Cancel."
	    exit
	fi
}

bullshit() {
BS=$(whiptail --title "Block Size" --inputbox "IO Block Size?" 13 60 4K 3>&1 1>&2 2>&3)
exitstatus=$?
	if [ $exitstatus = 0 ]; then
            tamano
	else
	    echo "You chose Cancel."
	    exit
	fi
}

tamano() {
SIZE=$(whiptail --title "File size" --inputbox "How large files will be" 13 60 5M 3>&1 1>&2 2>&3)
exitstatus=$?
	if [ $exitstatus = 0 ]; then
            bloqueos
	else
	    echo "You chose Cancel."
	    exit
	fi
}

bloqueos() {
OPENFILES=$(whiptail --title "Number of files opened" --inputbox "How much files opened against each other will be" 13 60 200 3>&1 1>&2 2>&3)
exitstatus=$?
	if [ $exitstatus = 0 ]; then
            piensa
	else
	    echo "You chose Cancel."
	    exit
	fi
}

piensa() {
THINKTIME=$(whiptail --title "Thinktime" --inputbox "Seconds between operations" 13 60 65s 3>&1 1>&2 2>&3)
exitstatus=$?
	if [ $exitstatus = 1 ]; then
            echo "You chose cancel"
	    exit
	else
	    verification
	fi
}

verification() {
if [ -f "$RUNFILENAME.FIO" ]; then
	echo "file created!"
fi
}
 
warning_before_writing() {                                                                                                          
if whiptail --yesno "CAUTION! Next step will execute the workload just created. Are you sure?" 10 100; then
  fio2CMD
else
  exit
fi
}


fio2CMD() {
fio $RUNFILENAME.FIO 
#>> $RUNFILENAME.log
# && rm -rf $RUNFILENAME.FIO
}    













