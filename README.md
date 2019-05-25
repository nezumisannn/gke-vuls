# GKE for vuls

## 0. Initial setting
```
# gcloud auth configure-docker
```

## 1. Pull docker images for vuls
- The following command is executed in cloud shell.

### go-cve-dictionary
```
# docker pull vuls/go-cve-dictionary
# docker run --rm vuls/go-cve-dictionary -v
```

### goval-dictionary
```
# docker pull vuls/goval-dictionary
# docker run --rm vuls/goval-dictionary -v
```

### gost
```
# docker pull vuls/gost
# docker run --rm vuls/gost -v
```

### vuls
```
# docker pull vuls/vuls
# docker run --rm vuls/vuls -v
```

## 2. Tag the docker image
```
# docker images
# docker tag [IMAGE ID] gcr.io/[PROJECT ID]/vuls/go-cve-dictionary:latest
# docker tag [IMAGE ID] gcr.io/[PROJECT ID]/vuls/goval-dictionary:latest
# docker tag [IMAGE ID] gcr.io/[PROJECT ID]/vuls/gost:latest
# docker tag [IMAGE ID] gcr.io/[PROJECT ID]/vuls/vuls:latest
```

## 3. Push docker images to Google Container Registry
```
# docker push gcr.io/[PROJECT ID]/vuls/go-cve-dictionary
# docker push gcr.io/[PROJECT ID]/vuls/goval-dictionary
# docker push gcr.io/[PROJECT ID]/vuls/gost
# docker push gcr.io/[PROJECT ID]/vuls/vuls
```

## 4. Create VPC network and GKE cluster

### Run Terraform command

```
# terraform init
# terraform plan
# terraform apply
```

## 5. Confirm connection to cluster
```
# gcloud config set compute/zone [COMPUTE_ZONE]
# gcloud container clusters get-credentials [MY_KUBERNETES_CLUSTER]

# kubectl cluster-info
# kubectl get nodes
```

## 6. Create NVD database
```
# kubectl apply -f job_fetch_nvd.yaml
```

## 7. Create JVN database
```
# kubectl apply -f job_fetch_jvd.yaml
```

## 8. Create OVAL database
```
# kubectl apply -f job_fetch_oval_redhat.yaml
# kubectl apply -f job_fetch_oval_ubuntu.yaml
# kubectl apply -f job_fetch_oval_debian.yaml
# kubectl apply -f job_fetch_oval_alpine.yaml
```

## 9. Create GOST database
```
# kubectl apply -f job_fetch_gost_redhat.yaml
# kubectl apply -f job_fetch_gost_debian.yaml
```

## 10. Create configMap for vuls config
```
# kubectl apply -f configmap_vuls_config.yaml
```

## 11. Create configMap for ssh config
```
# kubectl apply -f configmap_ssh_config.yaml
```

## 12. Create Secret for vuls scan
```
# kubectl create secret generic vuls-scan-key --from-file=id_rsa=[path/to/secret/key/file]
```

## 13. Create CronJob for vuls scan
```
# kubectl apply -f cronjob_scan.yaml
```

## 14. Create CronJob for vuls report
```
# kubectl apply -f cronjob_report.yaml
```