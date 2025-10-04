
# create storage account (must be globally unique & lowercase)
az storage account create \
  -n tfstatemsx777 \
  -g lab_project \
  -l canadacentral \
  --sku Standard_LRS

# create blob container
az storage container create \
  --name tfstate \
  --account-name tfstatemsx777
