#!/usr/bin/env bash

################################################################################
# Test script to validate the installation script locally
# This simulates what would happen when someone runs the install script
################################################################################

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="${SCRIPT_DIR}/test-project"

echo "🧪 Testing BMAD Parallel Agents Installation Script"
echo "=================================================="
echo ""

# Clean up any previous test
if [ -d "$TEST_DIR" ]; then
    echo "Cleaning up previous test directory..."
    rm -rf "$TEST_DIR"
fi

# Create test project
echo "Creating test project..."
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create a fake .bmad-core directory to simulate an existing BMAD project
mkdir -p .bmad-core/agents

# Create a dummy existing agent to test backup functionality
echo "# Original architect agent" > .bmad-core/agents/architect.md

echo ""
echo "Test project created at: $TEST_DIR"
echo ""

# Modify the installation script to use local files instead of downloading
echo "Creating local test version of installation script..."
TEST_SCRIPT="${TEST_DIR}/install-test.sh"

cat > "$TEST_SCRIPT" << 'TESTSCRIPT'
#!/usr/bin/env bash
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${YELLOW}ℹ $1${NC}"; }
print_step() { echo -e "${BLUE}→ $1${NC}"; }

# For testing, we'll copy from the parent export directory
EXPORT_DIR="__EXPORT_DIR__"

print_step "Testing local installation from: $EXPORT_DIR"

BMAD_DIR=".bmad-core/agents"

# Backup existing files
print_step "Creating backup..."
BACKUP_DIR="${BMAD_DIR}/.backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
if [ -f "${BMAD_DIR}/architect.md" ]; then
    cp "${BMAD_DIR}/architect.md" "${BACKUP_DIR}/architect.md"
    print_info "Backed up architect.md"
fi

# Copy files
print_step "Installing agents..."
for file in architect.md pm.md po.md developer-front.md developer-back.md; do
    if [ -f "${EXPORT_DIR}/${file}" ]; then
        cp "${EXPORT_DIR}/${file}" "${BMAD_DIR}/${file}"
        print_success "Installed: ${file}"
    else
        print_error "Missing: ${file}"
    fi
done

print_success "Installation complete!"
echo ""
echo "Installed files:"
ls -lh "${BMAD_DIR}"/*.md 2>/dev/null | awk '{print "  " $9}'
echo ""
echo "Backup location: ${BACKUP_DIR}"
TESTSCRIPT

# Replace placeholder with actual export directory path
sed -i.bak "s|__EXPORT_DIR__|${SCRIPT_DIR}|g" "$TEST_SCRIPT"
rm "${TEST_SCRIPT}.bak"

chmod +x "$TEST_SCRIPT"

# Run the test
echo ""
echo "Running test installation..."
echo "=================================================="
echo ""

bash "$TEST_SCRIPT"

echo ""
echo "=================================================="
echo "✅ Test completed successfully!"
echo ""
echo "Verification:"
echo "  - Check if backup was created: $(ls -d ${TEST_DIR}/.bmad-core/agents/.backup-* 2>/dev/null | wc -l | tr -d ' ') backup folder(s)"
echo "  - Installed agent count: $(ls ${TEST_DIR}/.bmad-core/agents/*.md 2>/dev/null | wc -l | tr -d ' ') files"
echo ""
echo "Test project location: $TEST_DIR"
echo ""
echo "To clean up:"
echo "  rm -rf $TEST_DIR"
echo ""
