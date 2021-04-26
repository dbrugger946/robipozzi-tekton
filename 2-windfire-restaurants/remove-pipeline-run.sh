source ../../setenv.sh

# ##### START - Variable section
SCRIPT=remove-pipeline-run.sh
OPENSHIFT_PROJECT=windfire
# ##### END - Variable section

run()
{
    oc project $OPENSHIFT_PROJECT
    tkn pipelinerun delete -p windfire-restaurants-backend -f
    # Also delete OpenShift objects related to windfire-restaurant-node application created by the pipeline
    oc delete route windfire-restaurants-backend
    oc delete svc windfire-restaurants-backend
    oc delete imagestream windfire-restaurants-backend
    oc delete dc windfire-restaurants-backend
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