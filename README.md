# Open Policy Agent

## Install

Instructions to deploy in OpenShift
Indetofy the value of the openshift caBundle.
One way to do is to run
```
SECRET=$(oc describe sa default -n default | grep 'Tokens:' | awk '{print $2}')
CA_BUNDLE=$(oc get secret $SECRET -n default -o "jsonpath={.data['ca\.crt']}")
oc new-project opa
helm template ./charts/open-policy-agent --namespace opa --set kubernetes_policy_controller.image_tag=2.0 --set kubernetes_policy_controller.image=quay.io/raffaelespazzoli/kubernetes-policy-controller --set caBundle=$CA_BUNDLE --set log-leve=debug | oc apply -f -
```

```
oc new-project opa-test
oc label ns opa-test opa-controlled=true
```

## Examples

### no IfnotPresent image pull policy and latest images

```
oc create configmap no-ifnotpresent-latest-rule --from-file=./examples/latest_and_IfNotPresent.rego -n opa
```