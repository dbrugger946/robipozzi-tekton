source ../../setenv.sh

# ##### START - Variable section
SCRIPT=delete-pipeline.sh
OPENSHIFT_PROJECT=windfire
# ##### END - Variable section

run()
{
    oc project $OPENSHIFT_PROJECT
    oc delete -f vote-resources.yaml
    oc delete -f vote-pipeline.yaml
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