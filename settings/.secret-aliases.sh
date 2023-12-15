export GOPRIVATE="github.com/waabi-ai/tooling-clis"

# Add tools folder to PATH (for bazel, python and other helpers)
PATH=$HOME/av/tools:${PATH}
export PATH

# mypy cache dir (when running manually without bazel)
mkdir -p "${HOME}/.cache/mypy"
MYPY_CACHE_DIR="${HOME}/.cache/mypy"
export MYPY_CACHE_DIR

#source /home/jli/.cache/bazel/6.0.0/lib/bazel/bin/bazel-complete.bash

alias uaws="update_aws_credentials.sh"
alias bbd="build_binary_deps.sh"

function triage_unit_tests {
    bazel run '//waabi/data/triage/report:report_tests' "$1" && bazel run '//waabi/data/triage/metric_fns:metric_fns_tests' "$2"
}

function report_unit_tests {
    bazel run '//waabi/data/triage/report:report_tests' "$@"
}

function metric_fns_unit_tests {
    bazel run '//waabi/data/triage/metric_fns:metric_fns_tests' "$@"
}

report_log_file="$HOME/triage-reports/report-test-logs.csv"
touch $report_log_file

function report_test_dry {
    timestamp=$(date +"%m-%d-%Y:%T")
    echo $timestamp >> $report_log_file
    echo "dry run" >> $report_log_file

    bazel run //waabi/data/triage/report:cli -- \
        snippet \
        foxglove://dev_bdxdMTp9iSiCOZFW \
        None \
        1698796920038713229 \
        1698797560066601710 \
        --user-mode=None \
        --metric_list='[engagement_summary]' \
        --create_foxglove_events=True \
        --override_foxglove_event_device="triage_report_test" \
        >> $report_log_file
}

function report_test_wet {
    timestamp=$(date +"%m-%d-%Y:%T")
    echo $timestamp >> $report_log_file
    echo "wet run" >> $report_log_file
    bazel run //waabi/data/triage/report:cli -- snippet foxglove://dev_bdxdMTp9iSiCOZFW None \
        1698796920038713229 \
        1698797560066601710 \
        --user-mode=None \
        --metric_list='[engagement_summary]' \
        --create_foxglove_events=True \
        --dry-run=False \
        --log_name='test-log' \
        --override_foxglove_event_device="triage_report_test" \
        >> $report_log_file
}

function report_test_long {
    timestamp=$(date +"%m-%d-%Y:%T")
    echo $timestamp >> $report_log_file
    bazel run //waabi/data/triage/report:cli -- \
        snippet \
        foxglove://dev_bdxdMTp9iSiCOZFW \
        None \
        1698796920038713229 \
        1698812481103116382 \
        --user-mode=None \
        --metric_list='[engagement_summary]' \
        --create_foxglove_events=True \
        --override_foxglove_event_device="triage_report_test" \
        >> $report_log_file
}

function ns_to_datetime {
python <<HEREDOC
from typing import Union
import datetime
NANOSECONDS_IN_SECOND = 1e9

def ns_to_secs(value: Union[int, float], nanoseconds_in_second: float = NANOSECONDS_IN_SECOND) -> float:
    """Convert nanoseconds to seconds.
    Global variable is passed in as a param for jit exports (jit does not support global variables)
    """
    return float(value) / nanoseconds_in_second

def ns_to_datetime(ns: int, timezone: datetime.timezone = datetime.timezone.utc) -> datetime.datetime:
    """Convert nanoseconds to a datetime"""
    return datetime.datetime.fromtimestamp(ns_to_secs(ns), tz=timezone)

def ns_to_datetime_str(ns: int, timezone: datetime.timezone = datetime.timezone.utc) -> str:
    """Convert nanoseconds to a datetime formatted string that includes nanoseconds"""
    return (
        ns_to_datetime(ns, timezone=timezone).strftime("%Y-%m-%d %H:%M:%S")
        + "."
        + str(ns % int(NANOSECONDS_IN_SECOND)).zfill(9)
    )

print(ns_to_datetime_str($1))
HEREDOC
}

function s3_logset_upload {
    local_path=$1
    s3_dir=s3://waabi-training-live-batch-job-data/users/jli/

    # Copies the local file into s3
    aws s3 cp $local_path $s3_path
}

function run_offline_labelling {
LOGSET=$1 # path to logset in s3
if [ $# -ge 2 ] && [ $2 = "--no-push" ]; then
    export OFFLINE_LABEL_IMG=223569079908.dkr.ecr.us-east-2.amazonaws.com/dataset-curation-live:offline-labelling-$(awk '/BUILD_DOCKER_TAG/ { print $2 }' < bazel-out/volatile-status.txt) &&
    bazel run waabi/labelling/offline_labelling:batch -- image=$OFFLINE_LABEL_IMG hydra_config_name=truck_multilidar_prod '++offline_label_args=["profile=True"]' logset=$LOGSET cost_allocation_tag=curationLabelling_triageSafetyAnalysis_systemsEng
else
    bazel run waabi/labelling/offline_labelling:push_docker_image &&
    export OFFLINE_LABEL_IMG=223569079908.dkr.ecr.us-east-2.amazonaws.com/dataset-curation-live:offline-labelling-$(awk '/BUILD_DOCKER_TAG/ { print $2 }' < bazel-out/volatile-status.txt) &&
    bazel run waabi/labelling/offline_labelling:batch -- image=$OFFLINE_LABEL_IMG hydra_config_name=truck_multilidar_prod '++offline_label_args=["profile=True"]' logset=$LOGSET cost_allocation_tag=curationLabelling_triageSafetyAnalysis_systemsEng
fi
}

function run_offline_labelling_local {
    logset=$1
    $2
    #logset="waabi/common/data/logsets/logset_files/09-21-2023_SMPI_takeover_logset.yaml"
    bazel run //waabi/labelling/offline_labelling:generate_offline_labels -- \
        --config-name=truck_multilidar_prod \
        label_storage_uri=/tmp/offline_labels \
        $(bazel run //waabi/common/data/logsets:print_args hydra -- truck_human_labelled_eval --prefix=data_source) \
        logset=$logset
}


function generate_scenario {
scenario_dir="waabi/sim/scenario/logical_scenario_files/sys_eng_road_logset"
scenario_name=$1
scenario_file="scenario_dir/$1"
logset_with_offline_labels=$2 # s3://waabi-training-live-batch-job-data/offline_labels_logsets/11-28-2023_merge_logset-with-offline-labels_1701364227.yaml
echo "parameter_sets:
- set_asset_set:
    asset_set_uri:
        - asset_sets/asset_set_curated_dcv_cad_w_sdv_truck_pandaset_val_v2_versioned.csv
    asset_set_version:
        - xOjdWO6H8E6dhWrMqdLTo_lG3WuPZR3x
    replay_log_scenario:
    snippet:
        LogSetGenerator:
        logset: $2
    asset_query_option:
        - CLOSEST_BBOX
    add_system_health_ok_criteria: {}
    dynamic_trigger_reactive_actors:
    reactive_trajectory_following:
        - true
" >> $scenario_file
echo $scenario_file
}

function run_scenario {
scenario_name=$1
#scenario_name=sys_eng_road_logset:09-21-2023_SMPI_takeover_logset
if [ $# -ge 2 ]; then
    if [ $2 = "--no-push" ]; then
        bazel run //waabi/sim:batch -- \
            image=223569079908.dkr.ecr.us-east-2.amazonaws.com/av-sim:sim_cli-$(awk '/BUILD_DOCKER_TAG/ { print $2 }' < bazel-out/volatile-status.txt) \
            gpu=True \
            ++scenario_name=$scenario_name \
            sim_mode=syseng__scenario_w_pnp_mp \
            batch_template_spec=sim_gpu_template_2xlarge \
            ++sim_args='["viz.foxglove.enabled=true", "viz.foxglove.mode=mcap_writer"]' \
            cost_allocation_tag=sim_exp_systemsEng
    fi
    if [ $2 = "--local" ]; then
        bazel run //waabi/sim:cli -- \
            mode.scenario_name=$scenario_name \
            mode=syseng__scenario_w_pnp_mp \
            viz=disabled
    fi
else
    bazel run //waabi/sim:push_docker_image &&
    bazel run //waabi/sim:batch -- \
        image=223569079908.dkr.ecr.us-east-2.amazonaws.com/av-sim:sim_cli-$(awk '/BUILD_DOCKER_TAG/ { print $2 }' < bazel-out/volatile-status.txt) \
        gpu=True \
        ++scenario_name=$scenario_name \
        sim_mode=syseng__scenario_w_pnp_mp \
        batch_template_spec=sim_gpu_template_2xlarge \
        ++sim_args='["viz.foxglove.enabled=true", "viz.foxglove.mode=mcap_writer"]' \
        cost_allocation_tag=sim_exp_systemsEng
fi
}

function resnippet_workflow {

    bazel run //waabi/labelling/dataset_curation/resnippet/from_logset:push_docker_image &&
    export RESNIPPET_IMAGE=223569079908.dkr.ecr.us-east-2.amazonaws.com/dataset-curation-live:resnippet-$(awk '/BUILD_DOCKER_TAG/ { print $2 }' < bazel-out/volatile-status.txt) &&
    #bazel run waabi/labelling/offline_labelling:push_docker_image &&
    #export OFFLINE_LABEL_IMG=223569079908.dkr.ecr.us-east-2.amazonaws.com/dataset-curation-live:offline-labelling-$(awk '/BUILD_DOCKER_TAG/ { print $2 }' < bazel-out/volatile-status.txt) &&
    bazel run //waabi/labelling/dataset_curation/workflow:run_curation_workflow -- workflow \
        --resnippet_image=$RESNIPPET_IMAGE \
        #--offline_labelling_image=$OFFLINE_LABEL_IMG \
}

alias airflow-sync="~/av/tools/local_airflow.sh --sync"
alias gbb="bazel run //waabi/tools:generate_bazel_build_files"
