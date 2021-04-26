source ../../setenv.sh

# ##### START - Variable section
SCRIPT=delete-trigger.sh
OPENSHIFT_PROJECT=windfire
# ##### END - Variable section

run()
{
    oc project $OPENSHIFT_PROJECT
    oc delete -f trigger-binding.yaml
    oc delete -f trigger-template.yaml
    oc delete -f trigger.yaml
    oc delete -f event-listener.yaml
    oc delete route el-windfire-restaurants-backend
}

setOpenshiftProject()
{
    ## Create OpenShift Project
	echo ${grn}Enter OpenShift project - leaving blank will set project to ${end}${mag}windfire : ${end}
	read OPENSHIFT_PROJECT
    if [ "$OPENSHIFT_PROJECT" == "" ]; then
        OPENSHIFT_PROJECT=windfire
    fi
    run
}

# ##############################################
# #################### MAIN ####################
# ##############################################
setOpenshiftProject