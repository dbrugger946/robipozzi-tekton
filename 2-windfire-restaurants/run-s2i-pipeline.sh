source ../../setenv.sh

# ##### START - Variable section
SCRIPT=run-s2i-pipeline.sh
OPENSHIFT_PROJECT=windfire
# ##### END - Variable section

run()
{
    oc project $OPENSHIFT_PROJECT
    tkn pipeline start windfire-restaurants-backend-s2i -s pipeline -w name=workspace,claimName=windfire-restaurants-pvc -p APP_NAME=windfire-restaurants-backend -p GIT_REPO=https://github.com/robipozzi/windfire-restaurants-node -p IMAGE=quay.io/robipozzi/windfire-restaurants-node:1.0
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