# Open Policy Agent

## Install

Instructions to deploy on OpenShift:

Add the following fragment to your `master-config.yaml` file at the section admissionConfig->pluginConfig :

```yaml
    MutatingAdmissionWebhook:
      configuration:
        apiVersion: apiserver.config.k8s.io/v1alpha1
        kind: WebhookAdmission
        kubeConfigFile: /dev/null
    ValidatingAdmissionWebhook:
      configuration:
        apiVersion: apiserver.config.k8s.io/v1alpha1
        kind: WebhookAdmission
        kubeConfigFile: /dev/null
```

Identify the value of the OpenShift service caBundle.
One way to do is to run:

```shell
SECRET=$(oc describe sa default -n default | grep 'Tokens:' | awk '{print $2}')
CA_BUNDLE=$(oc get secret $SECRET -n default -o "jsonpath={.data['service-ca\.crt']}")
```

Deploy the helm chart:

```shell
oc new-project opa
helm template ./charts/open-policy-agent --namespace opa --set kubernetes_policy_controller.image_tag=2.0 --set kubernetes_policy_controller.image=quay.io/raffaelespazzoli/kubernetes-policy-controller --set caBundle=$CA_BUNDLE --set log_level=debug | oc apply -f  - -n opa
```

This configuration will enforce rules only on those namespaces with the following label `opa-controlled=true`. This is done to have a "safe" deployment. You can easily customize the helm template to change this rule.

### Enable authorization

If you want to enable authorization, you need to do the following:

1. Copy the ocp-policy-controller.kubeconfig file to the `/etc/origin/master` directory in each of your masters.
2. Edit the master-config.yaml file adding the following:

```yaml
kubernetesMasterConfig:
...
  apiServerArguments:
...
    authorization-mooc new-project opa
helm template ./charts/open-policy-agent --namespace opa --set kubernetes_policy_controller.image_tag=2.0 --set kubernetes_policy_controller.image=quay.io/raffaelespazzoli/kubernetes-policy-controller --set caBundle=$CA_BUNDLE --set log_level=debug | oc apply -f  - -n opade:
    - Node
    - Webhook
    - RBAC
    authorization-webhook-config-file:
    - /etc/origin/master/opa-policy-controller.kubeconfig  
```

These above steps are intentionally left manual because the are significantly different between the 3.x and 4.x version of OCP.

## Examples

### no IfnotPresent image pull policy and latest images

This rule will prevent users from deploying images with the IfNotPresent image pull policy and the latest tag in the image.

Run the following command to deploy the rule.

```shell
oc create configmap no-ifnotpresent-latest-rule --from-file=./examples/validating-admission-webhook/latest_and_IfNotPresent.rego -n opa
```

Once the rule is deployed run the following:

```shell
oc new-project ifnotpresent-latest-opa-test
oc label ns ifnotpresent-latest-opa-test opa-controlled=true
oc apply -f ./examples/validating-admission-webhook/latest_and_IfNotPresent_test.yaml -n ifnotpresent-latest-opa-test
```

you should get an error.

To clean up run the following:

```shell
oc delete project ifnotpresent-latest-opa-test
oc delete configmap no-ifnotpresent-latest-rule -n opa
```

## Quota on LoadBalancer service types

LoadBalancer type services are billable ressources in cloud deployment so it might be a good idea to put a quota on them.
In this example the quota is 2 per namespace.

Run the following command to deploy the rule.

```shell
oc create configmap loadbalancer-quota-rule --from-file=./examples/validating-admission-webhook/loadbalancer_quota.rego -n opa
```

Once the rule is deployed run the following:

```shell
oc new-project loadbalancer-quota-opa-test
oc label ns loadbalancer-quota-opa-test opa-controlled=true
oc apply -f ./examples/validating-admission-webhook/loadbalancer_quota_test1.yaml -n loadbalancer-quota-opa-test
```

wait a few seconds for opa to catch up with the cluster status then type:

```shell
oc apply -f ./examples/validating-admission-webhook/loadbalancer_quota_test2.yaml -n loadbalancer-quota-opa-test
```

you should get an error.

To clean up run the following:

```shell
oc delete project loadbalancer-quota-opa-test
oc delete configmap loadbalancer-quota-rule -n opa
```

## CMDB Integration

Sometimes apps deployed in OpenShift need to be referrable back to a CMDB database. You can do that with label. This rule enforces that the following labels are defined:

- cmdb_id
- emergency_contact
- tier

Run the following command to deploy the rule.

```shell
oc create configmap cmdb-integration-rule --from-file=./examples/validating-admission-webhook/cmdb_integration.rego -n opa
```

Once the rule is deployed run the following:

```shell
oc new-project cmdb-integration-test
oc label ns cmdb-integration-test opa-controlled=true
oc apply -f ./examples/validating-admission-webhook/cmdb_integration_test.yaml -n cmdb-integration-test
```

you should get an error.

To clean up run the following:

```shell
oc delete project cmdb-integration-test
oc delete configmap cmdb-integration-rule -n opa
```

## Enforcing software license

Sometimes software licences can be tied to a measurable dimension. In this case we can write policies that ensure that we don't go over a specific limit within a cluster (in a way this is a cluster-wide quota).
In this example we use CPU request and we assume that we have licensed the sofware for 500 cpus.

Run the following command to deploy the rule.

```shell
oc create configmap software-license-rule --from-file=./examples/validating-admission-webhook/software_license.rego -n opa
```

Once the rule is deployed run the following:

```shell
oc new-project software-license-test
oc label ns software-license-test opa-controlled=true
oc apply -f ./examples/validating-admission-webhook/software_license_test1.yaml -n software-license-test
```

wait a few seconds for opa to sync and the type:

```shell
oc apply -f ./examples/validating-admission-webhook/software_license_test2.yaml -n software-license-test
```

you should get an error.

To clean up run the following:

```shell
oc delete project software-license-test
oc delete configmap software-license-rule -n opa
```

## Preventing mounting the service account secret

Arguably the service account secret should not be mounted by default. To flip the default behavior we can add an annotation to request the service account to be mounted (`requires-service-account-secret`). Then we can create a mutating admission rule that will remove the service account secret if the above annotation is not set:

Run the following command to deploy the rule.

```shell
oc create configmap no-serviceaccount-secret-rule --from-file=./examples/mutating-admission-webhooks/no_serviceaccount_secret.rego -n opa
```

Once the rule is deployed run the following:

```shell
oc new-project no-serviceaccount-secret-test
oc label ns no-serviceaccount-secret-test opa-controlled=true
oc apply -f ./examples/mutating-admission-webhooks/no_serviceaccount_secret_test.yaml -n no-serviceaccount-secret-test
```

check that the pod did not mount a volume:

```shell
oc get pod busybox -n no-serviceaccount-secret-test -o yaml | grep -A 4 volumeMount
```

The output should be empty.

To clean up run the following:

```shell
oc delete project no-serviceaccount-secret-test
oc delete configmap no-serviceaccount-secret-rule -n opa
