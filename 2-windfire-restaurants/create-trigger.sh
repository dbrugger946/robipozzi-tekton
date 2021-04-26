source ../../setenv.sh

# ##### START - Variable section
SCRIPT=create-trigger.sh
OPENSHIFT_PROJECT=windfire
# ##### END - Variable section

run()
{
    oc project $OPENSHIFT_PROJECT
    oc create -f trigger-binding.yaml
    oc create -f trigger-template.yaml
    oc create -f trigger.yaml
    oc create -f event-listener.yaml
    sleep 5
    oc expose svc el-windfire-restaurants-backend
    echo "URL: $(oc get route el-windfire-restaurants-backend --template='http://{{.spec.host}}')"
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