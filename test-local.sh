#!/bin/bash

# Local test script for deployment validation logic
# Usage: ./test-local.sh <tenant> <environment> <test_mode>

TENANT=${1:-"dpm"}
TARGET_ENVIRONMENT=${2:-"uat"}
TEST_MODE=${3:-"all_success"}

echo "=== LOCAL TEST: DEPLOYMENT VALIDATION LOGIC ==="
echo "Tenant: $TENANT"
echo "Target Environment: $TARGET_ENVIRONMENT"
echo "Test Mode: $TEST_MODE"
echo ""
sleep 2

echo "STEP 1: Setting up environment validation logic..."
sleep 2

# Define the list of environments
ALL_ENVIRONMENTS=("dev" "sit" "uat" "prod")
echo "   Default environment sequence: ${ALL_ENVIRONMENTS[*]}"
sleep 2

echo ""
echo "STEP 2: Checking tenant-specific rules..."
sleep 2

# Skip 'sit' environment if tenant is 'mig'
if [[ "$TENANT" == "mig" ]]; then
    echo "   Tenant is '$TENANT' - checking if it matches 'mig'..."
    sleep 2
    echo "   MATCH FOUND! Tenant '$TENANT' equals 'mig'"
    sleep 2
    echo "   Skipping 'sit' environment validation for 'mig' tenant"
    sleep 2
    # Remove 'sit' from the environments array for 'mig' tenant
    ALL_ENVIRONMENTS=("dev" "uat" "prod")
    echo "   Updated environment sequence: ${ALL_ENVIRONMENTS[*]}"
    sleep 2
else
    echo "   Tenant is '$TENANT' - checking if it matches 'mig'..."
    sleep 2
    echo "   NO MATCH! Tenant '$TENANT' does not equal 'mig'"
    sleep 2
    echo "   Keeping all environments including 'sit'"
    sleep 2
    echo "   Environment sequence remains: ${ALL_ENVIRONMENTS[*]}"
    sleep 2
fi
echo ""
sleep 2

echo "STEP 3: Setting up test simulation..."
sleep 2
# Simulate version (for testing purposes)
VERSION="v1.2.3"
echo "   Version to be deployed: $VERSION"
sleep 2
echo "   Test mode: $TEST_MODE (simulating deployment results)"
sleep 2
echo ""

# Function to simulate deployment check
simulate_deployment_check() {
    local env=$1
    local test_mode=$2
    
    echo "STEP 4: Checking deployments in $env..."
    sleep 2
    
    case $test_mode in
        "all_success")
            echo "   Simulating: All deployments are successful"
            sleep 2
            echo "   Simulating successful deployment in $env"
            sleep 2
            return 0
            ;;
        "dev_fail")
            echo "   Simulating: Dev environment deployment failed"
            sleep 2
            if [[ "$env" == "dev" ]]; then
                echo "   Simulating failed deployment in $env"
                sleep 2
                return 1
            else
                echo "   Simulating successful deployment in $env"
                sleep 2
                return 0
            fi
            ;;
        "sit_fail")
            echo "   Simulating: Sit environment deployment failed"
            sleep 2
            if [[ "$env" == "sit" ]]; then
                echo "   Simulating failed deployment in $env"
                sleep 2
                return 1
            else
                echo "   Simulating successful deployment in $env"
                sleep 2
                return 0
            fi
            ;;
        "uat_fail")
            echo "   Simulating: UAT environment deployment failed"
            sleep 2
            if [[ "$env" == "uat" ]]; then
                echo "   Simulating failed deployment in $env"
                sleep 2
                return 1
            else
                echo "   Simulating successful deployment in $env"
                sleep 2
                return 0
            fi
            ;;
    esac
}

echo "STEP 5: Starting environment validation loop..."
sleep 2
echo "   Target environment: $TARGET_ENVIRONMENT"
sleep 2
echo "   Environments to check: ${ALL_ENVIRONMENTS[*]}"
sleep 2
echo ""

# Loop through environments prior to the target environment
echo "STEP 6: Validating each environment in sequence..."
sleep 2
for ENV in "${ALL_ENVIRONMENTS[@]}"; do
    echo ""
    echo "   Processing environment: $ENV"
    sleep 2
    
    if [[ "$ENV" == "$TARGET_ENVIRONMENT" ]]; then
        echo "   REACHED TARGET! Environment '$ENV' equals target '$TARGET_ENVIRONMENT'"
        sleep 2
        echo "   Stopping validation - no need to check target environment"
        sleep 2
        break
    fi

    echo "   Environment '$ENV' comes before target '$TARGET_ENVIRONMENT'"
    sleep 2
    echo "   Must validate successful deployment in '$ENV' before proceeding"
    sleep 2
    
    if ! simulate_deployment_check "$ENV" "$TEST_MODE"; then
        echo ""
        echo "STEP 7: VALIDATION FAILED!"
        sleep 2
        echo "   Deployment check failed for environment $ENV"
        sleep 2
        echo "   Cannot proceed to target environment '$TARGET_ENVIRONMENT'"
        sleep 2
        echo "   Validation failed - deployment cannot proceed"
        sleep 2
        exit 1
    fi
    echo "   Environment '$ENV' validation passed"
    sleep 2
done

echo ""
echo "STEP 7: VALIDATION SUCCESS!"
sleep 2
echo "   All required environment checks passed"
sleep 2
echo "   Deployment can proceed to $TARGET_ENVIRONMENT!"
sleep 2
echo ""

echo "FINAL SUMMARY:"
sleep 2
echo "   Tenant: $TENANT"
sleep 2
echo "   Target: $TARGET_ENVIRONMENT"
sleep 2
echo "   Environments validated: ${ALL_ENVIRONMENTS[*]}"
sleep 2

if [[ "$TENANT" == "mig" ]]; then
    echo "   SIT environment was skipped for 'mig' tenant"
    sleep 2
    echo "   This means 'mig' tenant can deploy: dev -> uat -> prod (skipping sit)"
    sleep 2
else
    echo "   This means '$TENANT' tenant follows normal flow: dev -> sit -> uat -> prod"
    sleep 2
fi

echo ""
echo "Test completed successfully!" 