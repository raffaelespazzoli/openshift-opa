package admission

import data.k8s.matches

# we cannot have more than 500 total cpu core for the myrepo/myimage workload

default max_cpu_requests = 500

deny[{
	"id": "software-license",
	"resolution": {"message": "we cannot have more than 500 total cpu core for the workload"},
}] {
     images := {i |  c = data.kubernetes.pods[_][_].object.spec.containers[_]; i = c.image }
     image = images[_]
     containers := [c | c := data.kubernetes.pods[_][_].object.spec.containers[_]; c.image == image]
     container_millicore_requests := [s | num := containers[_]; s = process_millicore_cpu(num.resources.requests.cpu) ]
     container_core_requests := [s | num := containers[_]; s = process_core_cpu(num.resources.requests.cpu) ]
     total_requests := sum(container_millicore_requests) + sum(container_core_requests)
     total_requests > max_cpu_requests
}

process_millicore_cpu(obj) = millicore_cpu_result {
    re_match("m$",obj)
    regex.split("m$", obj, parsed_obj)
    to_number(parsed_obj[0],int_obj)
    millicore_cpu_result = int_obj / 1000
}

process_core_cpu(obj) = core_cpu_result {
    not re_match("m$",obj)
    to_number(obj,int_obj)
    core_cpu_result = int_obj
}