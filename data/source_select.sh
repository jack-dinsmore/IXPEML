case $SOURCE in 

    gx301)
        export DATA_SUBDIR='leakage'
        export SEQ='01002601'
        export SETNUM=$SEQ
        export OBS='01002601'
        export ERSION='02'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    gx301mom)
        export DATA_SUBDIR='leakage'
        export SEQ='m1002601'
        export OBS='01002601'
        export SETNUM=$SEQ
        export VERSION='02'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    4u)
        export DATA_SUBDIR='leakage'
        export SEQ='02002399'
        export SETNUM=$SEQ
        export OBS='02002302'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    gx99)
        export SOURCE='gx99'
        export SEQ='01002401'
        export DATA_SUBDIR='leakage'
        export SETNUM=$SEQ
        export OBS='01002401'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    lmc)
        export DATA_SUBDIR='leakage'
        export SEQ='02001901'
        export OBS='02001901'
        export VERSION='02'
        export SETNUM=$SEQ
        export ATTNUM='02'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    cirx1)
        export DATA_SUBDIR='leakage'
        export SEQ='02002699'
        export OBS='02002602'
        export VERSION='02'
        export SETNUM=$SEQ
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    scox1)
        export DATA_SUBDIR='leakage'
        export SEQ='02002401'
        export SETNUM=$SEQ
        export OBS='02002401'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    sim)
        export DATA_SUBDIR='leakage'
        export SEQ='sim'
        export OBS='sim'
        export VERSION='01'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab1)
        export DATA_SUBDIR='crab'
        export SEQ='01001099'
        export SETNUM='01001001'
        export OBS='01001010'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;
    
    crab2)
        export DATA_SUBDIR='crab'
        export SEQ='01001099'
        export OBS='01001020'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;

    crab3)
        export DATA_SUBDIR='crab'
        export SEQ='01001099'
        export OBS='01001030'
        export SETNUM='01001001'
        export VERSION='00'
        export ATTNUM='12'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;


    crab4)
        export DATA_SUBDIR='crab'
        export SEQ='01001099'
        export OBS='01001040'
        export SETNUM='01001002'
        export VERSION='00'
        export ATTNUM='11'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;
    
    crab5)
        export DATA_SUBDIR='crab'
        export SEQ='01001099'
        export OBS='01001050'
        export VERSION='00'
        export SETNUM='01001002'
        export ATTNUM='11'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;

    crab6)
        export DATA_SUBDIR='crab'
        export SEQ='01001099'
        export OBS='01001060'
        export VERSION='00'
        export SETNUM='01001002'
        export ATTNUM='11'
        export PAYNUM1='09'
        export PAYNUM2='10'
        export PAYNUM3='08'
        ;;

    crab7)
        export DATA_SUBDIR='crab'
        export SEQ='02001099'
        export OBS='02001010'
        export VERSION='00'
        export ATTNUM='01'
        export SETNUM='02001001'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab8)
        export DATA_SUBDIR='crab'
        export SEQ='02001099'
        export OBS='02001020'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab9)
        export DATA_SUBDIR='crab'
        export SEQ='02001099'
        export OBS='02001030'
        export SETNUM='02001001'
        export VERSION='00'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab10)
        export DATA_SUBDIR='crab'
        export SEQ='02001099'
        export OBS='02001040'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab11)
        export DATA_SUBDIR='crab'
        export SEQ='02001099'
        export OBS='02001050'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    crab12)
        export DATA_SUBDIR='crab'
        export SEQ='02001099'
        export OBS='02001060'
        export VERSION='00'
        export SETNUM='02001001'
        export ATTNUM='01'
        export PAYNUM1='01'
        export PAYNUM2='01'
        export PAYNUM3='01'
        ;;

    *)
        echo "This source "$SOURCE" was not identified."
        exit
        ;;

esac


