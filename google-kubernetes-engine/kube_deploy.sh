gcloud container clusters get-credentials pr-exercise_ci_cd-gke-cluster
kubectl create secret generic cloud-storage-bucket-credentials --from-file=storageBucketsBackendServiceKey.json
kubectl create secret generic cloud-endpoint-credentials --from-file=gkeCloudEndpointServiceKey.json

kubectl apply -R -f .