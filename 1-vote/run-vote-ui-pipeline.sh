source ../../setenv.sh

# ##### START - Variable section
SCRIPT=run-vote-ui-pipeline.sh
OPENSHIFT_PROJECT=windfire
# ##### END - Variable section

run()
{
    oc project $OPENSHIFT_PROJECT
    tkn pipeline start vote-build-and-deploy -s pipeline -w name=shared-workspace,claimName=vote-pvc -p deployment-name=vote-ui -p git-url=https://github.com/robipozzi/vote-ui.git -p IMAGE=quay.io/robipozzi/vote-ui:1.0 #-p IMAGE=image-registry.openshift-image-registry.svc:5000/windfire/vote-ui:1.0
    #oc create -f vote-ui-pipelinerun.yaml
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