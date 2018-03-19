#!/usr/bin/env bats

TEST=1
PYTHON=${PYTHON:-/usr/bin/python3}
PWD=$(pwd)
TEST_DIR="${PWD}/test"
BINARY=${BINARY:-"/usr/libexec/registries"}
MIGRATOR=${MIGRATOR:-"/usr/libexec/registries_migrator"}

STR_RESULT[0]='--add-registry registry1 --insecure-registry registry2 --block-registry registry3 '
JSON_RESULT[0]='{"registries.search": {"registries": ["registry1"]}, "registries.insecure": {"registries": ["registry2"]}, "registries.block": {"registries": ["registry3"]}}'

STR_RESULT[1]='--add-registry registry1 --add-registry registry1a --insecure-registry registry2 --block-registry registry3 '
JSON_RESULT[1]='{"registries.search": {"registries": ["registry1", "registry1a"]}, "registries.insecure": {"registries": ["registry2"]}, "registries.block": {"registries": ["registry3"]}}'

STR_RESULT[2]='--add-registry registry1 --add-registry registry1a '
JSON_RESULT[2]='{"registries.search": {"registries": ["registry1", "registry1a"]}, "registries.insecure": {"registries": []}, "registries.block": {"registries": []}}'

STR_RESULT[3]='--add-registry registry1 --add-registry registry1a '
JSON_RESULT[3]='{"registries.search": {"registries": ["registry1", "registry1a"]}, "registries.insecure": {"registries": []}, "registries.block": {"registries": []}}'

STR_RESULT[4]='--add-registry registry1 --add-registry registry1a '
JSON_RESULT[4]='{"registries.search": {"registries": ["registry1", "registry1a"]}, "registries.insecure": {"registries": []}, "registries.block": {"registries": []}}'

STR_RESULT[5]=''
JSON_RESULT[5]='{"registries.search": {"registries": []}, "registries.insecure": {"registries": []}, "registries.block": {"registries": []}}'

STR_RESULT[6]='--add-registry example-1.com:5000 --add-registry example-2.com --insecure-registry example-3.com:6000 --block-registry example-4.com '
JSON_RESULT[6]='{"registries.search": {"registries": ["example-1.com:5000", "example-2.com"]}, "registries.insecure": {"registries": ["example-3.com:6000"]}, "registries.block": {"registries": ["example-4.com"]}}'

@test "yaml test 0" {
	TN=0
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "yaml test 1" {
	TN=1
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	echo "${STR_RESULT[$TN]}"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "yaml test 2" {
	TN=2
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	echo "${STR_RESULT[$TN]}"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "yaml test 3" {
	TN=3
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.yaml"
	echo "${STR_RESULT[$TN]}"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "yaml test 4" {
	TN=4
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.yaml"
	echo "${STR_RESULT[$TN]}"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "yaml test 5" {
	TN=5
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "yaml test 6" {
	TN=6
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.yaml"
	echo "${STR_RESULT[$TN]}"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "yaml json test 0" {
	TN=0
	run "$PYTHON" "$BINARY" -j -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${JSON_RESULT[$TN]}" ]
}

@test "yaml json test 1" {
	TN=1
	run "$PYTHON" "$BINARY" -j -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${JSON_RESULT[$TN]}" ]
}

@test "yaml json test 2" {
	TN=2
	run "$PYTHON" "$BINARY" -j -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${JSON_RESULT[$TN]}" ]
}

@test "yaml json test 3" {
	TN=3
	run "$PYTHON" "$BINARY" -j -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${JSON_RESULT[$TN]}" ]
}

@test "yaml json test 4" {
	TN=4
	run "$PYTHON" "$BINARY" -j -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${JSON_RESULT[$TN]}" ]
}

@test "yaml json test 5" {
	TN=5
	run "$PYTHON" "$BINARY" -j -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${JSON_RESULT[$TN]}" ]
}

@test "yaml json test 6" {
	TN=6
	run "$PYTHON" "$BINARY" -j -i "$TEST_DIR/test$TN.yaml"
	echo "$output"
	[ "$output" = "${JSON_RESULT[$TN]}" ]
}


# TOML tests


@test "toml test 0" {
	TN=0
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.toml"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "toml test 1" {
	TN=1
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.toml"
	echo "$output"
	echo "${STR_RESULT[$TN]}"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "toml test 2" {
	TN=2
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.toml"
	echo "$output"
	echo "${STR_RESULT[$TN]}"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "toml test 3" {
	TN=3
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.toml"
	echo "${STR_RESULT[$TN]}"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "toml test 4" {
	TN=4
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.toml"
	echo "${STR_RESULT[$TN]}"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "toml test 5" {
	TN=5
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.toml"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

@test "toml test 6" {
	TN=6
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test$TN.toml"
	echo "${STR_RESULT[$TN]}"
	echo "$output"
	[ "$output" = "${STR_RESULT[$TN]}" ]
}

# Migration tests
@test "migrator test 0" {
	run "$PYTHON" "$MIGRATOR" -i "$TEST_DIR/test0.yaml"
	RESULT='["registries.search"]
registries = ["registry1"]

["registries.insecure"]
registries = ["registry2"]

["registries.block"]
registries = ["registry3"]'
	echo "$output"
	[ "$output" = "$RESULT" ]
}

@test "migrator test 1" {
	run "$PYTHON" "$MIGRATOR" -i "$TEST_DIR/test1.yaml"
	RESULT='["registries.search"]
registries = ["registry1", "registry1a"]

["registries.insecure"]
registries = ["registry2"]

["registries.block"]
registries = ["registry3"]'
	echo "$output"
	[ "$output" = "$RESULT" ]
}

@test "migrator test 2" {
	run "$PYTHON" "$MIGRATOR" -i "$TEST_DIR/test2.yaml"
	RESULT='["registries.search"]
registries = ["registry1", "registry1a"]

["registries.insecure"]
registries = []

["registries.block"]
registries = []'

	echo "$output"
	[ "$output" = "$RESULT" ]
}

@test "migrator test 3" {
	run "$PYTHON" "$MIGRATOR" -i "$TEST_DIR/test3.yaml"
	RESULT='["registries.search"]
registries = ["registry1", "registry1a"]

["registries.insecure"]
registries = []

["registries.block"]
registries = []'
	echo "$output"
	[ "$output" = "$RESULT" ]
}

@test "migrator test 4" {
	run "$PYTHON" "$MIGRATOR" -i "$TEST_DIR/test4.yaml"
	RESULT='["registries.search"]
registries = ["registry1", "registry1a"]

["registries.insecure"]
registries = []

["registries.block"]
registries = []'
	echo "$output"
	[ "$output" = "$RESULT" ]
}

@test "migrator test 5" {
	run "$PYTHON" "$MIGRATOR" -i "$TEST_DIR/test5.yaml"
	RESULT='["registries.search"]
registries = []

["registries.insecure"]
registries = []

["registries.block"]
registries = []'
	echo "$output"
	[ "$output" = "$RESULT" ]
}

@test "migrator test 6" {
	run "$PYTHON" "$MIGRATOR" -i "$TEST_DIR/test6.yaml"
	RESULT='["registries.search"]
registries = ["example-1.com:5000", "example-2.com"]

["registries.insecure"]
registries = ["example-3.com:6000"]

["registries.block"]
registries = ["example-4.com"]'
	echo "$output"
	[ "$output" = "$RESULT" ]
}

# Quoted TOML Test
@test "quoted toml test" {
	run "$PYTHON" "$BINARY" -i "$TEST_DIR/test98.toml"
    RESULT='--add-registry registry1 --insecure-registry registry2 --block-registry registry3 '
	[ "$output" = "$RESULT" ]
}
