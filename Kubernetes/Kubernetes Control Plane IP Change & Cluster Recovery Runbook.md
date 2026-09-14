# Kubernetes Control Plane IP Change & Cluster Recovery Runbook

## 1. Overview

This runbook documents the recovery of a kubeadm-based Kubernetes cluster after the control-plane node IP address changed.

### Environment

| Component | Version / Value |
|---|---|
| OS | Ubuntu Server 24.04.4 LTS |
| Kubernetes | v1.36.4 |
| Container Runtime | containerd 2.2.1 |
| CNI | Calico v3.32.1 |
| Cluster Type | kubeadm |
| Control Plane | `k8s-control-01` |
| Worker 01 | `k8s-worker-01` |
| Worker 02 | `k8s-worker-02` |

### IP Address Change

```text
Old Control Plane IP:
192.168.31.173

New Control Plane IP:
192.168.31.52
```

Worker IPs after recovery:

```text
k8s-worker-01    192.168.31.84
k8s-worker-02    192.168.31.122
```

---

# 2. Incident Symptoms

After the control-plane IP changed from:

```text
192.168.31.173
```

to:

```text
192.168.31.52
```

the Kubernetes cluster experienced:

- Workers becoming `NotReady`
- kubelet connection failures
- kube-proxy using the old API server address
- Scheduler instability
- Controller Manager instability
- API server restart activity
- Pods becoming `Pending` or `Terminating`
- Calico pod recovery problems
- Kubernetes Service connectivity problems
- `kubectl` attempting to connect to the old control-plane IP

Typical error:

```text
Unable to connect to the server:
dial tcp 192.168.31.173:6443:
connect: no route to host
```

---

# 3. Root Cause

The primary root cause was the control-plane IP address change.

Several Kubernetes configuration files and runtime configurations still referenced the old IP:

```text
192.168.31.173
```

The active control-plane IP was:

```text
192.168.31.52
```

The stale references caused Kubernetes components and worker nodes to attempt communication with an address that was no longer assigned to the control-plane node.

---

# 4. Recovery Strategy

The cluster was recovered without rebuilding the cluster.

The recovery sequence was:

```text
Control Plane IP Change
        |
        v
Update etcd
        |
        v
Update kube-apiserver
        |
        v
Update Kubernetes kubeconfig files
        |
        v
Fix kube-proxy ConfigMap
        |
        v
Restart kube-proxy
        |
        v
Fix worker kubelet configurations
        |
        v
Restart worker kubelets
        |
        v
All Nodes Ready
        |
        v
Calico Recovery
        |
        v
CoreDNS Recovery
        |
        v
Application Recovery
        |
        v
API readiness validation
        |
        v
DNS validation
        |
        v
Pod -> Kubernetes API validation
```

---

# 5. Control Plane IP Verification

Verify the current IP:

```bash
ip addr
```

Expected control-plane address:

```text
192.168.31.52
```

Verify node registration:

```bash
kubectl get nodes -o wide
```

---

# 6. etcd Recovery

The etcd static pod manifest was updated to use the new control-plane IP.

File:

```text
/etc/kubernetes/manifests/etcd.yaml
```

The active etcd configuration used:

```text
192.168.31.52
```

for the relevant advertise/listen client and peer URLs.

Verify:

```bash
grep -n "192.168.31." /etc/kubernetes/manifests/etcd.yaml
```

Verify etcd:

```bash
kubectl get pods -n kube-system | grep etcd
```

Expected:

```text
etcd-k8s-control-01    1/1    Running
```

---

# 7. kube-apiserver Recovery

The kube-apiserver was configured with the new advertise address:

```text
--advertise-address=192.168.31.52
```

The API server continued communicating with local etcd:

```text
--etcd-servers=https://127.0.0.1:2379
```

Verify:

```bash
grep -n "advertise-address" /etc/kubernetes/manifests/kube-apiserver.yaml
```

Expected:

```text
--advertise-address=192.168.31.52
```

Verify API server:

```bash
kubectl get pods -n kube-system | grep kube-apiserver
```

---

# 8. Kubernetes Kubeconfig Recovery

The following kubeconfig files were updated to reference the new control-plane IP:

```text
/etc/kubernetes/admin.conf
/etc/kubernetes/kubelet.conf
/etc/kubernetes/controller-manager.conf
/etc/kubernetes/scheduler.conf
/etc/kubernetes/super-admin.conf
```

The old IP was:

```text
192.168.31.173
```

The new IP is:

```text
192.168.31.52
```

Verify active configurations:

```bash
grep -R "192.168.31.173" /etc/kubernetes
```

Any remaining matches should only be expected backup files, not active configurations.

---

# 9. Local kubectl Configuration

The control-plane user's local kubeconfig was also found to contain the old IP.

File:

```text
~/.kube/config
```

The stale configuration contained:

```text
server: https://192.168.31.173:6443
```

It was updated to:

```text
server: https://192.168.31.52:6443
```

Command:

```bash
sed -i 's/192.168.31.173/192.168.31.52/g' ~/.kube/config
```

Verify:

```bash
grep 'server:' ~/.kube/config
```

Expected:

```text
server: https://192.168.31.52:6443
```

---

# 10. kube-proxy Recovery

A stale API server address was found in the Kubernetes `kube-proxy` ConfigMap.

Inspect:

```bash
kubectl get configmap kube-proxy -n kube-system -o yaml
```

The kube-proxy kubeconfig contained the old server:

```text
server: https://192.168.31.173:6443
```

The configuration was updated to:

```text
server: https://192.168.31.52:6443
```

After updating the ConfigMap, the control-plane kube-proxy pod was recreated.

Verify:

```bash
kubectl get pods -n kube-system -o wide | grep kube-proxy
```

Expected:

```text
kube-proxy    1/1    Running
```

---

# 11. Kubernetes Service Routing Validation

Kubernetes Service routing was verified using the Kubernetes Service IP:

```text
10.96.0.1
```

Check kube-proxy service rules:

```bash
sudo iptables -t nat -L KUBE-SERVICES -n -v | grep 10.96.0.1
```

Direct connectivity test:

```bash
sudo curl -k --connect-timeout 5 https://10.96.0.1:443/livez
```

Expected:

```text
ok
```

This confirmed that Kubernetes Service routing was functioning on the control-plane node.

---

# 12. Worker Node Recovery

Both workers originally had kubelet configurations pointing to the old API server:

```text
https://192.168.31.173:6443
```

This caused kubelet registration and lease failures.

## Worker 01

File:

```text
/etc/kubernetes/kubelet.conf
```

Updated using:

```bash
sudo sed -i 's/192.168.31.173/192.168.31.52/g' /etc/kubernetes/kubelet.conf
```

Verify:

```bash
sudo grep 'server:' /etc/kubernetes/kubelet.conf
```

Restart:

```bash
sudo systemctl restart kubelet
```

Verify:

```bash
sudo systemctl status kubelet --no-pager
```

---

## Worker 02

The same stale configuration was found:

```text
server: https://192.168.31.173:6443
```

Updated using:

```bash
sudo sed -i 's/192.168.31.173/192.168.31.52/g' /etc/kubernetes/kubelet.conf
```

Verify:

```bash
sudo grep 'server:' /etc/kubernetes/kubelet.conf
```

Restart:

```bash
sudo systemctl restart kubelet
```

Verify:

```bash
sudo systemctl status kubelet --no-pager
```

---

# 13. Node Recovery Validation

After the kubelet configurations were corrected:

```bash
kubectl get nodes -o wide
```

Final recovered state:

```text
NAME             STATUS   ROLES           INTERNAL-IP
k8s-control-01   Ready    control-plane   192.168.31.52
k8s-worker-01    Ready    <none>          192.168.31.84
k8s-worker-02    Ready    <none>          192.168.31.122
```

All three nodes were successfully restored to:

```text
Ready
```

---

# 14. Calico Validation

Calico was verified on all three nodes:

```bash
kubectl get pods -n kube-system -o wide | grep calico
```

Final state:

```text
calico-node on control plane    Running
calico-node on worker-01        Running
calico-node on worker-02        Running
calico-kube-controllers         Running
```

This confirmed that cluster networking recovered after the worker kubelet/API connectivity was restored.

---

# 15. CoreDNS Validation

CoreDNS pods were verified:

```bash
kubectl get pods -n kube-system | grep coredns
```

Final state:

```text
coredns    1/1    Running
coredns    1/1    Running
```

---

# 16. Application Workload Validation

All application workloads were verified:

```bash
kubectl get pods -A -o wide
```

Recovered workloads included:

```text
default
  nginx

dev
  dev-app
  dev-nginx
```

All displayed application pods were:

```text
Running
```

with:

```text
READY = 1/1
```

---

# 17. Kubernetes API Readiness Validation

The Kubernetes API server was tested using:

```bash
kubectl get --raw='/readyz?verbose'
```

The final result was:

```text
[+]ping ok
[+]log ok
[+]etcd ok
[+]etcd-readiness ok
[+]informer-sync ok
...
[+]storage-readiness ok
...
[+]shutdown ok

readyz check passed
```

This confirmed that the API server and its critical internal components were ready.

---

# 18. DNS Functional Test

A temporary BusyBox pod was created:

```bash
kubectl run dns-test \
  --image=busybox:1.36 \
  --restart=Never \
  --rm -it \
  -- nslookup kubernetes.default.svc.cluster.local
```

Successful result:

```text
Server:         10.96.0.10
Address:        10.96.0.10:53

Name:   kubernetes.default.svc.cluster.local
Address: 10.96.0.1
```

This verified:

```text
Pod
 |
 v
CoreDNS 10.96.0.10
 |
 v
Kubernetes DNS
 |
 v
10.96.0.1
```

The temporary diagnostic pod was automatically removed using:

```text
--rm
```

---

# 19. Pod -> Kubernetes API Functional Test

A temporary curl pod was created:

```bash
kubectl run api-test \
  --image=curlimages/curl:8.18.0 \
  --restart=Never \
  --rm -it \
  -- curl -k --connect-timeout 5 \
  https://kubernetes.default.svc.cluster.local/version
```

Successful response:

```json
{
  "major": "1",
  "minor": "36",
  "gitVersion": "v1.36.4"
}
```

This confirmed the complete path:

```text
Application Pod
      |
      v
CoreDNS
      |
      v
kubernetes.default.svc.cluster.local
      |
      v
Kubernetes Service
      |
      v
kube-proxy / Service Routing
      |
      v
kube-apiserver
      |
      v
API Response
```

The temporary diagnostic pod was automatically removed.

---

# 20. Final Cluster Health

Final validation:

```text
Control Plane        READY
Worker 01            READY
Worker 02            READY

Calico               HEALTHY
CoreDNS              HEALTHY
kube-proxy           HEALTHY
etcd                 HEALTHY
kube-apiserver       HEALTHY
scheduler             RUNNING
controller-manager    RUNNING

Pod DNS              WORKING
Service Routing      WORKING
Pod -> API           WORKING
Application Pods      RUNNING
API readyz            PASSED
```

---

# 21. Important Lessons Learned

## 21.1 IP changes affect more than the API server

Changing the control-plane IP requires checking all components that communicate with the Kubernetes API.

Important locations include:

```text
/etc/kubernetes/
/var/lib/kubelet/
/var/lib/kube-proxy/
/etc/kubernetes/manifests/
/etc/kubernetes/*.conf
~/.kube/config
```

The Kubernetes `kube-proxy` ConfigMap must also be considered.

---

## 21.2 Worker kubelets can remain alive but still be disconnected

A kubelet service showing:

```text
Active: active (running)
```

does not necessarily mean the node can communicate with the Kubernetes API server.

Always verify:

```bash
kubectl get nodes
```

and inspect kubelet logs when a node is `NotReady`.

---

## 21.3 Check for stale IP references

After changing a control-plane IP, search for the old address:

```bash
sudo grep -R "192.168.31.173" \
  /etc/kubernetes \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  2>/dev/null
```

Any active configuration referencing the old IP should be investigated.

Backup files may legitimately contain the old address.

---

# 22. Recommended Post-Recovery Checks

After recovering a Kubernetes cluster from an IP change, perform:

```bash
kubectl get nodes -o wide
```

```bash
kubectl get pods -A -o wide
```

```bash
kubectl get --raw='/readyz?verbose'
```

```bash
kubectl get svc -A
```

```bash
kubectl get endpointslices -A
```

Check system logs:

```bash
journalctl -u kubelet --since "30 minutes ago"
```

Check container runtime:

```bash
sudo systemctl status containerd --no-pager
```

Check for old IP references:

```bash
sudo grep -R "192.168.31.173" \
  /etc/kubernetes \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  2>/dev/null
```

---

# 23. Production Recommendation

For production Kubernetes environments, avoid relying on dynamically changing control-plane IP addresses.

Recommended architecture:

```text
                    +----------------------+
                    | Kubernetes API VIP   |
                    | / Load Balancer      |
                    +----------+-----------+
                               |
                 +-------------+-------------+
                 |                           |
          Control Plane 01            Control Plane 02
          API Server                  API Server
                 |                           |
                 +-------------+-------------+
                               |
                         Control Plane 03
                         API Server
```

Workers should communicate with a stable Kubernetes API endpoint rather than directly depending on a single control-plane node IP.

For example:

```text
https://k8s-api.example.internal:6443
```

instead of:

```text
https://192.168.31.52:6443
```

This significantly reduces the impact of future control-plane IP changes or node failures.

---

# 24. Recovery Summary

### Incident

Control-plane IP changed:

```text
192.168.31.173
        ↓
192.168.31.52
```

### Root Cause

Multiple Kubernetes components retained the old control-plane IP.

### Remediation

- Updated etcd
- Updated kube-apiserver
- Updated Kubernetes kubeconfigs
- Updated local `~/.kube/config`
- Updated kube-proxy configuration
- Restarted kube-proxy
- Updated worker-01 kubelet
- Updated worker-02 kubelet
- Restarted worker kubelets
- Validated Calico
- Validated CoreDNS
- Validated workloads
- Validated API readiness
- Validated DNS
- Validated Pod → Kubernetes API connectivity

### Final Result

```text
                 KUBERNETES CLUSTER
                       |
          +------------+------------+
          |            |            |
          v            v            v
       Control       Worker       Worker
         Plane         01           02
        READY         READY        READY
          |            |            |
          +------------+------------+
                       |
                  Calico HEALTHY
                       |
                  CoreDNS HEALTHY
                       |
                 API SERVER READY
                       |
                 APPLICATIONS OK
```

**Recovery Status: SUCCESS**