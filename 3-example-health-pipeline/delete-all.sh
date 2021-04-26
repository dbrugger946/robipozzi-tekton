oc project windfire
oc delete -f example-health-resources.yaml
oc delete -f example-health-pipeline.yaml
oc delete -f health-pipeline-run.yaml
oc delete -f health-pvc.yaml
oc delete -f openshift-client.yaml
oc delete -f s2i-nodejs.yaml
oc delete -f s2i-php.yaml