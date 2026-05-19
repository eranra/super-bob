#!/usr/bin/env bash
# Test script for install.sh --update flag

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_HOME="/tmp/bob-install-test-$$"
INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0

# Setup test environment
setup_test_env() {
    echo "Setting up test environment at $TEST_HOME"
    rm -rf "$TEST_HOME"
    mkdir -p "$TEST_HOME/.bob/settings"
    mkdir -p "$TEST_HOME/.bob/commands"
    mkdir -p "$TEST_HOME/.bob/settings/rules"
    export HOME="$TEST_HOME"
}

# Cleanup test environment
cleanup_test_env() {
    echo "Cleaning up test environment"
    rm -rf "$TEST_HOME"
}

# Test helper functions
assert_file_exists() {
    local file="$1"
    local description="$2"
    
    if [[ -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} PASS: $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} FAIL: $description - file not found: $file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_file_not_exists() {
    local file="$1"
    local description="$2"
    
    if [[ ! -f "$file" ]]; then
        echo -e "${GREEN}✓${NC} PASS: $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} FAIL: $description - file exists: $file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_file_contains() {
    local file="$1"
    local pattern="$2"
    local description="$3"
    
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} PASS: $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} FAIL: $description - pattern not found in $file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

assert_backup_created() {
    local base_file="$1"
    local description="$2"
    
    # Check if any backup file exists with the pattern
    if ls "${base_file}.bak."* 1> /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} PASS: $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} FAIL: $description - no backup found for $base_file"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    fi
}

# Test 1: Initial installation (baseline)
test_initial_install() {
    echo ""
    echo "=== Test 1: Initial Installation ==="
    setup_test_env
    
    bash "$INSTALL_SCRIPT" > /dev/null 2>&1
    
    assert_file_exists "$TEST_HOME/.bob/settings/custom_modes.yaml" "custom_modes.yaml installed"
    assert_file_exists "$TEST_HOME/.bob/commands/tdd.md" "tdd.md command installed"
    assert_file_exists "$TEST_HOME/.bob/settings/rules/superbob-workspace.md" "workspace rules installed"
    
    cleanup_test_env
}

# Test 2: --update flag overwrites custom_modes.yaml
test_update_overwrites_modes() {
    echo ""
    echo "=== Test 2: --update Overwrites custom_modes.yaml ==="
    setup_test_env
    
    # Initial install
    bash "$INSTALL_SCRIPT" > /dev/null 2>&1
    
    # Modify the file
    echo "# MODIFIED CONTENT" > "$TEST_HOME/.bob/settings/custom_modes.yaml"
    
    # Run with --update flag
    bash "$INSTALL_SCRIPT" --update > /dev/null 2>&1
    
    # Should be overwritten (not contain MODIFIED CONTENT)
    if grep -q "MODIFIED CONTENT" "$TEST_HOME/.bob/settings/custom_modes.yaml" 2>/dev/null; then
        echo -e "${RED}✗${NC} FAIL: custom_modes.yaml was not overwritten by --update"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo -e "${GREEN}✓${NC} PASS: custom_modes.yaml was overwritten by --update"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
    
    cleanup_test_env
}

# Test 3: --update creates backup of custom_modes.yaml
test_update_creates_backup() {
    echo ""
    echo "=== Test 3: --update Creates Backup ==="
    setup_test_env
    
    # Initial install
    bash "$INSTALL_SCRIPT" > /dev/null 2>&1
    
    # Modify the file
    echo "customModes: [test]" > "$TEST_HOME/.bob/settings/custom_modes.yaml"
    
    # Run with --update flag
    bash "$INSTALL_SCRIPT" --update > /dev/null 2>&1
    
    assert_backup_created "$TEST_HOME/.bob/settings/custom_modes.yaml" "Backup created for custom_modes.yaml"
    
    cleanup_test_env
}

# Test 4: --update overwrites existing commands
test_update_overwrites_commands() {
    echo ""
    echo "=== Test 4: --update Overwrites Commands ==="
    setup_test_env
    
    # Initial install
    bash "$INSTALL_SCRIPT" > /dev/null 2>&1
    
    # Modify a command
    echo "# MODIFIED COMMAND" > "$TEST_HOME/.bob/commands/tdd.md"
    
    # Run with --update flag
    bash "$INSTALL_SCRIPT" --update > /dev/null 2>&1
    
    # Should be overwritten
    if grep -q "MODIFIED COMMAND" "$TEST_HOME/.bob/commands/tdd.md" 2>/dev/null; then
        echo -e "${RED}✗${NC} FAIL: tdd.md was not overwritten by --update"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo -e "${GREEN}✓${NC} PASS: tdd.md was overwritten by --update"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
    
    cleanup_test_env
}

# Test 5: --update overwrites workspace rules
test_update_overwrites_rules() {
    echo ""
    echo "=== Test 5: --update Overwrites Rules ==="
    setup_test_env
    
    # Initial install
    bash "$INSTALL_SCRIPT" > /dev/null 2>&1
    
    # Modify the rule
    echo "# MODIFIED RULE" > "$TEST_HOME/.bob/settings/rules/superbob-workspace.md"
    
    # Run with --update flag
    bash "$INSTALL_SCRIPT" --update > /dev/null 2>&1
    
    # Should be overwritten
    if grep -q "MODIFIED RULE" "$TEST_HOME/.bob/settings/rules/superbob-workspace.md" 2>/dev/null; then
        echo -e "${RED}✗${NC} FAIL: superbob-workspace.md was not overwritten by --update"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo -e "${GREEN}✓${NC} PASS: superbob-workspace.md was overwritten by --update"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
    
    cleanup_test_env
}

# Test 6: Normal install (without --update) skips existing commands
test_normal_install_skips_existing() {
    echo ""
    echo "=== Test 6: Normal Install Skips Existing Commands ==="
    setup_test_env
    
    # Initial install
    bash "$INSTALL_SCRIPT" > /dev/null 2>&1
    
    # Modify a command
    echo "# MODIFIED COMMAND" > "$TEST_HOME/.bob/commands/tdd.md"
    
    # Run normal install (without --update)
    bash "$INSTALL_SCRIPT" > /dev/null 2>&1
    
    # Should NOT be overwritten
    if grep -q "MODIFIED COMMAND" "$TEST_HOME/.bob/commands/tdd.md" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} PASS: tdd.md was preserved (not overwritten)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} FAIL: tdd.md was overwritten without --update flag"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    cleanup_test_env
}

# Run all tests
echo "=== Running Install Script Tests ==="
echo "Testing install.sh with --update flag functionality"

test_initial_install
test_update_overwrites_modes
test_update_creates_backup
test_update_overwrites_commands
test_update_overwrites_rules
test_normal_install_skips_existing

# Summary
echo ""
echo "=== Test Summary ==="
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi
