# Enable
gcloud container clusters create [CLUSTER_NAME] --enable-network-policy

or 

gcloud container clusters update [CLUSTER_NAME] --update-addons=NetworkPolicy=ENABLED
gcloud container clusters update [CLUSTER_NAME] --enable-network-policy


# Disable

gcloud container clusters update [CLUSTER_NAME] --no-enable-network-policy