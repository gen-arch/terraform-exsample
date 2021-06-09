ubuntu-default-policy:
	gcloud alpha compute os-config os-policy-assignments create ubuntu-default-policy \
		--location=asia-northeast1-a \
		--file=./ubuntu-default-policy.yml \
		--project=$(PROJECT_ID) \
		--async
ubuntu-container-policy:
	gcloud alpha compute os-config os-policy-assignments create ubuntu-container-policy \
		--location=asia-northeast1-a \
		--file=./ubuntu-container-policy.yml \
		--project=$(PROJECT_ID) \
		--async
ubuntu-test-policy:
	gcloud alpha compute os-config os-policy-assignments create ubuntu-test-policy \
		--location=asia-northeast1-a \
		--file=./ubuntu-test-policy.yml \
		--project=$(PROJECT_ID) \
		--async
ospolicy-update:
	gcloud alpha compute os-config os-policy-assignments update ubuntu-default-policy \
		--location=asia-northeast1-a \
		--file=./ubuntu-default-policy.yml \
		--project=$(PROJECT_ID) \
		--async
	gcloud alpha compute os-config os-policy-assignments update ubuntu-container-policy \
		--location=asia-northeast1-a \
		--file=./ubuntu-container-policy.yml \
		--project=$(PROJECT_ID) \
		--async
	gcloud alpha compute os-config os-policy-assignments update ubuntu-test-policy \
		--location=asia-northeast1-a \
		--file=./ubuntu-test-policy.yml \
		--project=$(PROJECT_ID) \
		--async


