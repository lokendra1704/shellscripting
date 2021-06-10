#!/bin/bash
# Create an array which holds list of courses. This should be used to compare if the course name is passed in CLI
courses=(
"machinelearning"
"Linux_course/Linux_course1"
"Linux_course/Linux_course2"
"SQLFundamentals1"
)

# function for usage
usage() {
	echo "Usage:"
        echo "     ./course_mount.sh -h To print this help message"
        echo "     ./course_mount.sh -m -c [course] For mounting a given course"
        echo "     ./course_mount.sh -u -c [course] For unmounting a given course"
        echo "If course name is ommited all courses will be (un)mounted"
}

#function to check mount exists
check_mount() {
	mount_dir="/home/trainee/courses/"
	courseName=$1
	folder=${courseName#*/}
	mount_dir+=$folder
	if [ -d $mount_dir ]
	then
		echo 0
	else
		echo 1
	fi
}


mount_course() {
    	present_in_courses=0
    	for i in "${courses[@]}"
    	do
		if [ "$i" == "$1" ];then
			present_in_courses=1
			break
		fi
    	done
    	isMounted=$(check_mount $1)
    	COURSE_PATH=""
    	TARGET_PATH=""
    	if [ $present_in_courses -eq 1 ] && [ $isMounted -eq 1 ]
    	then
		COURSE_PATH="/data/courses/"$1
		courseName=$1
		folder=${courseName#*/}
		TARGET_PATH="/home/trainee/courses/"$folder
		mkdir -p $TARGET_PATH
		bindfs -p a-w -u trainee -g ftpaccess ${COURSE_PATH} ${TARGET_PATH}
    	fi
}


mount_all() {
    for i in ${courses[@]}
    do
	mount_course "$i"
    done
}

unmount_course() {
    	isCourseMounted=$(check_mount "$1")
    	if [ $isCourseMounted -eq 0 ]
	then
        	courseName=$1
        	folder=${courseName#*/}
        	TARGET_PATH="/home/trainee/courses/"$folder
    		umount $TARGET_PATH
		rmdir $TARGET_PATH
    	fi
}


unmount_all() {
    for i in ${courses[@]}
    do
    	unmount_course "$i"
    done
}

if [ "$1" == "-h" ];then
	usage
elif [ "$1" == "-m" ] && [ "$2" == "-c" ];then
	if [ "$#" -eq 3 ];then
		mount_course "$3"
	elif [ "$#" -eq 2 ];then
		mount_all
	else
		echo "do -h to find more"
	fi
elif [ "$1" == "-u" ] && [ "$2" == "-c" ];then
	if [ $# -eq 3 ];then
		unmount_course "$3"
	elif [ $# -eq 2 ];then
		unmount_all	
	else
		echo "do -h to find more"
	fi
else 
	echo "do -h to find more"
fi
