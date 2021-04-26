source ../setenv.sh

# ##### START - Variable section
SCRIPT=create-serviceaccount.sh
OPENSHIFT_PROJECT=
IMAGE_REGISTRY_OPTION=
IMAGE_REGISTRY=
IMAGE_REGISTRY_USERNAME=
IMAGE_REGISTRY_PASSWORD=
IMAGE_REGISTRY_SECRET=
GITHUB_SECRET=
GITHUB_USERNAME=
GITHUB_ACCESS_TOKEN=
SERVICEACCOUNT=pipeline
# ##### END - Variable section

createOpenshiftProject()
{
    echo ${cyn}Creating $OPENSHIFT_PROJECT OpenShift Project ...${end}
    oc new-project $OPENSHIFT_PROJECT
    oc project $OPENSHIFT_PROJECT
    echo ${cyn}OpenShift Project created${end}
    echo
}

printSelectImageRegistry()
{
	echo ${grn}Select Image Registry :${end}
    echo "${grn}1. Quay${end}"
    echo "${grn}2. Docker${end}"
	read IMAGE_REGISTRY_OPTION
	selectImageRegistry
}

selectImageRegistry()
{
	case $IMAGE_REGISTRY_OPTION in
		1)  IMAGE_REGISTRY="quay.io"
			;;
        2)  IMAGE_REGISTRY="docker.io"
            ;;
		*) 	printf "\n${red}No valid option selected${end}\n"
			printSelectImageRegistry
			;;
	esac
}

createImageRegistrySecret()
{
    echo ${cyn}Creating $IMAGE_REGISTRY_SECRET Image Registry Secret ...${end}
	oc project $OPENSHIFT_PROJECT
    oc create secret docker-registry $IMAGE_REGISTRY_SECRET \
                    --docker-server=$IMAGE_REGISTRY \
                    --docker-username=$IMAGE_REGISTRY_USERNAME \
                    --docker-password=$IMAGE_REGISTRY_PASSWORD
    echo ${cyn}Image Registry Secret created${end}
    echo
}

createGitHubSecret()
{
    echo ${cyn}Creating $GITHUB_SECRET GitHub Secret ...${end}
	oc project $OPENSHIFT_PROJECT
    oc create secret generic $GITHUB_SECRET \
        --from-literal=username=$GITHUB_USERNAME \
        --from-literal=password=$GITHUB_ACCESS_TOKEN \
        --type=kubernetes.io/basic-auth
    echo ${cyn}GitHub Secret created${end}
    echo
}

setServiceAccount()
{
    echo ${cyn}Creating and configuring $SERVICEACCOUNT Service Account ...${end}
	oc project $OPENSHIFT_PROJECT
    oc create serviceaccount $SERVICEACCOUNT
    oc adm policy add-scc-to-user privileged -z $SERVICEACCOUNT
    oc adm policy add-role-to-user edit -z $SERVICEACCOUNT
    oc secrets link $SERVICEACCOUNT $GITHUB_SECRET
    oc annotate secret $GITHUB_SECRET "tekton.dev/git-0=https://github.com"
    oc secrets link $SERVICEACCOUNT $IMAGE_REGISTRY_SECRET
    oc annotate secret $IMAGE_REGISTRY_SECRET "tekton.dev/docker-0=quay.io"
    oc secrets link default $IMAGE_REGISTRY_SECRET --for pull
    echo ${cyn}Service Account created${end}
}

inputParameters()
{
    ## Create OpenShift Project
	echo ${grn}Enter OpenShift project - leaving blank will set project to ${end}${mag}windfire : ${end}
	read OPENSHIFT_PROJECT
    if [ "$OPENSHIFT_PROJECT" == "" ]; then
        OPENSHIFT_PROJECT=windfire
    fi
    createOpenshiftProject
    ## Select Image Registry
    printSelectImageRegistry
    ## Create Image Registry Secret
    echo ${grn}Enter Secret Name for Image Registry - leaving blank will set secret name to ${end}${mag}robipozzi-quay : ${end}
    read IMAGE_REGISTRY_SECRET
    if [ "$IMAGE_REGISTRY_SECRET" == "" ]; then
        IMAGE_REGISTRY_SECRET=robipozzi-quay
    fi
    echo ${grn}Enter Username for Image Registry : ${end}
    read IMAGE_REGISTRY_USERNAME
    echo ${grn}Enter Password for Image Registry : ${end}
    read -s IMAGE_REGISTRY_PASSWORD
    createImageRegistrySecret
    ## Create GitHub Secret
    echo ${grn}Enter Secret Name for GitHub - leaving blank will set secret name to ${end}${mag}robipozzi-github : ${end}
    read GITHUB_SECRET
    if [ "$GITHUB_SECRET" == "" ]; then
        GITHUB_SECRET=robipozzi-github
    fi
    echo ${grn}Enter GitHub Username : ${end}
    read GITHUB_USERNAME
    echo ${grn}Enter GitHub Personal Access Token : ${end}
    read -s GITHUB_ACCESS_TOKEN
    createGitHubSecret
    ## Create and configure Service Account
    setServiceAccount
}

# ##############################################
# #################### MAIN ####################
# ##############################################
inputParameters